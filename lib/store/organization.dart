import 'package:architecto/models/audit.dart';
import 'package:architecto/models/invitations.dart';
import 'package:architecto/models/organization.dart';
import 'package:architecto/models/member.dart';
import 'package:architecto/utils/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrganizationStore {
  final CollectionReference organizations =
      FirebaseFirestore.instance.collection('organizations');

  Future<Organization?> getUserOrganization(String user) async {
    QuerySnapshot querySnapshot =
        await organizations.where('members.$user', isNotEqualTo: null).get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    DocumentSnapshot orgDoc = querySnapshot.docs.first;
    return Organization.fromFirestore(orgDoc as DocumentSnapshot<Map<String, dynamic>>);
  }

  Future<Organization> createOrganization(
      String name, String createdBy, String email,
      [String? about, String? address]) async {
    Organization? existingOrg = await getUserOrganization(createdBy);
    if (existingOrg != null) return existingOrg;

    String orgId = generateId("org");
    Organization org = Organization(
      name: name,
      about: about,
      address: address,
      audit: Audit.defaultAudit(createdBy),
    );

    await organizations.doc(orgId).set(org.toFirestore());

    await addMember(orgId, createdBy, email, MemberRole.owner, createdBy);
    return org;
  }

  Future<Member> addMember(String organizationId, String user, String email,
      MemberRole role, String addedBy) async {
    QuerySnapshot memberQuerySnapshot = await FirebaseFirestore.instance
        .collectionGroup('members')
        .where('user', isEqualTo: user)
        .get();

    if (memberQuerySnapshot.docs.isNotEmpty) {
      throw Exception("User is already a member of another organization.");
    }

    String memberId = generateId("org_mbr");
    Member member = Member(
      user: user,
      email: email,
      role: role,
      audit: Audit.defaultAudit(addedBy),
    );

    await organizations
        .doc(organizationId)
        .collection('members')
        .doc(memberId)
        .set(member.toFirestore());
    return member;
  }

  Future<void> removeMember(
      String organizationId, String userId, String removedBy) async {
    DocumentSnapshot removedByMemberSnapshot = await organizations
        .doc(organizationId)
        .collection('members')
        .where('user', isEqualTo: removedBy)
        .get()
        .then((snapshot) => snapshot.docs.first);

    Member removedByMember = Member.fromFirestore(removedByMemberSnapshot as DocumentSnapshot<Map<String, dynamic>>);

    if (removedByMember.role != MemberRole.owner &&
        removedByMember.role != MemberRole.admin) {
      throw Exception("Action not allowed.");
    }

    QuerySnapshot userMemberSnapshot = await organizations
        .doc(organizationId)
        .collection('members')
        .where('user', isEqualTo: userId)
        .get();

    if (userMemberSnapshot.docs.isEmpty) {
      throw Exception("User not found in this organization.");
    }

    DocumentSnapshot userDoc = userMemberSnapshot.docs.first;
    Member userMember = Member.fromFirestore(userDoc as DocumentSnapshot<Map<String, dynamic>>);

    if (userMember.role == MemberRole.owner) {
      throw Exception("Owners cannot be removed.");
    }

    await organizations
        .doc(organizationId)
        .collection('members')
        .doc(userDoc.id)
        .delete();
  }

  Future<void> inviteUser(String organizationId, String email, MemberRole role,
      String invitedBy) async {
    QuerySnapshot memberQuerySnapshot = await FirebaseFirestore.instance
        .collectionGroup('members')
        .where('email', isEqualTo: email)
        .get();

    if (memberQuerySnapshot.docs.isNotEmpty) {
      throw Exception("User is already a member of another organization.");
    }

    QuerySnapshot inviteQuerySnapshot = await organizations
        .doc(organizationId)
        .collection('invitations')
        .where('email', isEqualTo: email)
        .get();

    if (inviteQuerySnapshot.docs.isNotEmpty) {
      throw Exception("User is already invited.");
    }

    String inviteId = generateId("org_inv");
    Invitations invitation = Invitations(
      email: email,
      role: role,
      invitedBy: invitedBy,
      audit: Audit.defaultAudit(invitedBy),
    );

    await organizations
        .doc(organizationId)
        .collection('invitations')
        .doc(inviteId)
        .set(invitation.toFirestore());
  }
}
