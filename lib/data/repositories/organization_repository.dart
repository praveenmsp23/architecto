import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:architecto/data/models/models.dart';
import 'package:architecto/constants/db_constants.dart';

class OrganizationRepository {
  final CollectionReference _collection = 
      FirebaseFirestore.instance.collection(DBConstants.organizations);
  
  // Create a new organization
  Future<String> createOrganization(
    String ownerId,
    String name,
  ) async {
    // Create organization data
    final org = OrganizationModel(
      id: '', // Will be replaced with auto-generated ID
      name: name,
      ownerId: ownerId,
      members: [
        OrganizationMember(
          userId: ownerId,
          role: UserRole.owner,
        ),
      ],
      createdAt: DateTime.now(),
      createdBy: ownerId,
    );
    
    // Add to Firestore with auto-generated ID
    final docRef = await _collection.add(org.toJson());
    
    // Update the organization with its ID
    await docRef.update({'id': docRef.id});
    
    return docRef.id;
  }
  
  // Get organization by ID
  Future<OrganizationModel?> getOrganizationById(String orgId) async {
    final doc = await _collection.doc(orgId).get();
    if (doc.exists) {
      return OrganizationModel.fromFirestore(doc);
    }
    return null;
  }
  
  // Get organizations for user
  Future<List<OrganizationModel>> getOrganizationsForUser(String userId) async {
    final querySnapshot = await _collection
        .where('members', arrayContains: {'user_id': userId})
        .get();
    
    return querySnapshot.docs
        .map((doc) => OrganizationModel.fromFirestore(doc))
        .toList();
  }
  
  // Update organization
  Future<void> updateOrganization(String orgId, String name) async {
    await _collection.doc(orgId).update({
      'name': name,
      'updated_at': Timestamp.now(),
    });
  }
  
  // Delete organization
  Future<void> deleteOrganization(String orgId) async {
    await _collection.doc(orgId).delete();
  }
  
  // Add member to organization
  Future<void> addMember(String orgId, String userId, UserRole role) async {
    final org = await getOrganizationById(orgId);
    if (org == null) return;
    
    // Create new members list
    final members = List<OrganizationMember>.from(org.members);
    members.add(OrganizationMember(userId: userId, role: role));
    
    // Update organization
    await _collection.doc(orgId).update({
      'members': members.map((m) => m.toJson()).toList(),
      'updated_at': Timestamp.now(),
    });
  }
  
  // Remove member from organization
  Future<void> removeMember(String orgId, String userId) async {
    final org = await getOrganizationById(orgId);
    if (org == null) return;
    
    // Filter out the member
    final members = org.members.where((m) => m.userId != userId).toList();
    
    // Update organization
    await _collection.doc(orgId).update({
      'members': members.map((m) => m.toJson()).toList(),
      'updated_at': Timestamp.now(),
    });
  }
  
  // Update member role
  Future<void> updateMemberRole(String orgId, String userId, UserRole role) async {
    final org = await getOrganizationById(orgId);
    if (org == null) return;
    
    // Create new members list with updated role
    final members = org.members.map((m) {
      if (m.userId == userId) {
        return OrganizationMember(userId: userId, role: role);
      }
      return m;
    }).toList();
    
    // Update organization
    await _collection.doc(orgId).update({
      'members': members.map((m) => m.toJson()).toList(),
      'updated_at': Timestamp.now(),
    });
  }
  
  // Stream organization data
  Stream<OrganizationModel?> streamOrganization(String orgId) {
    return _collection.doc(orgId).snapshots().map((doc) {
      if (doc.exists) {
        return OrganizationModel.fromFirestore(doc);
      }
      return null;
    });
  }
  
  // Stream organizations for user
  Stream<List<OrganizationModel>> streamUserOrganizations(String userId) {
    return _collection
        .where('members', arrayContains: {'user_id': userId})
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrganizationModel.fromFirestore(doc))
            .toList());
  }
}