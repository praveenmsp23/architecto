import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:architecto/data/models/models.dart';
import 'package:architecto/constants/db_constants.dart';
import 'package:architecto/constants/app_constants.dart';

class InviteRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection(DBConstants.invites);
  
  // Create a new invitation
  Future<String> createInvite(
    String organizationId,
    String organizationName,
    String email,
    UserRole role,
    String invitedById,
  ) async {
    // Create invite expiry date (e.g., 7 days from now)
    final expiryDate = DateTime.now().add(
      Duration(days: AppConstants.inviteExpiryDays),
    );
    
    // Create invite data
    final invite = InviteModel(
      id: '', // Will be replaced with auto-generated ID
      organizationId: organizationId,
      organizationName: organizationName,
      email: email.toLowerCase().trim(),
      role: role,
      status: InviteStatus.pending,
      expiryDate: expiryDate,
      invitedById: invitedById,
      createdAt: DateTime.now(),
      createdBy: invitedById,
    );
    
    // Add to Firestore with auto-generated ID
    final docRef = await _collection.add(invite.toJson());
    
    // Update the invite with its ID
    await docRef.update({'id': docRef.id});
    
    return docRef.id;
  }
  
  // Get invite by ID
  Future<InviteModel?> getInviteById(String inviteId) async {
    final doc = await _collection.doc(inviteId).get();
    if (doc.exists) {
      return InviteModel.fromFirestore(doc);
    }
    return null;
  }
  
  // Get pending invites for an email
  Future<List<InviteModel>> getPendingInvitesForEmail(String email) async {
    final standardizedEmail = email.toLowerCase().trim();
    
    final querySnapshot = await _collection
        .where('email', isEqualTo: standardizedEmail)
        .where('status', isEqualTo: InviteStatus.pending.toString().split('.').last)
        .where('expiry_date', isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .get();
    
    return querySnapshot.docs
        .map((doc) => InviteModel.fromFirestore(doc))
        .toList();
  }
  
  // Get invites for an organization
  Future<List<InviteModel>> getInvitesForOrganization(
    String organizationId, {
    bool pendingOnly = true,
  }) async {
    Query query = _collection.where('organization_id', isEqualTo: organizationId);
    
    if (pendingOnly) {
      query = query.where(
        'status',
        isEqualTo: InviteStatus.pending.toString().split('.').last,
      );
    }
    
    final querySnapshot = await query.get();
    
    return querySnapshot.docs
        .map((doc) => InviteModel.fromFirestore(doc))
        .toList();
  }
  
  // Update invite status
  Future<void> updateInviteStatus(
    String inviteId,
    InviteStatus status,
    String updatedBy,
  ) async {
    await _collection.doc(inviteId).update({
      'status': status.toString().split('.').last,
      'updated_at': Timestamp.now(),
      'updated_by': updatedBy,
    });
  }
  
  // Accept invite
  Future<void> acceptInvite(String inviteId, String userId) async {
    await updateInviteStatus(inviteId, InviteStatus.accepted, userId);
  }
  
  // Reject invite
  Future<void> rejectInvite(String inviteId, String userId) async {
    await updateInviteStatus(inviteId, InviteStatus.rejected, userId);
  }
  
  // Cancel invite (by organization admin)
  Future<void> cancelInvite(String inviteId, String adminId) async {
    await _collection.doc(inviteId).delete();
  }
  
  // Delete expired invites
  Future<void> cleanupExpiredInvites() async {
    final now = DateTime.now();
    
    // Get expired invites with pending status
    final querySnapshot = await _collection
        .where('status', isEqualTo: InviteStatus.pending.toString().split('.').last)
        .where('expiry_date', isLessThan: Timestamp.fromDate(now))
        .get();
    
    // Update their status to expired in a batch
    final batch = FirebaseFirestore.instance.batch();
    
    for (final doc in querySnapshot.docs) {
      batch.update(doc.reference, {
        'status': InviteStatus.expired.toString().split('.').last,
        'updated_at': Timestamp.fromDate(now),
      });
    }
    
    await batch.commit();
  }
  
  // Stream pending invites for a user's email
  Stream<List<InviteModel>> streamPendingInvitesForEmail(String email) {
    final standardizedEmail = email.toLowerCase().trim();
    
    return _collection
        .where('email', isEqualTo: standardizedEmail)
        .where('status', isEqualTo: InviteStatus.pending.toString().split('.').last)
        .where('expiry_date', isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => InviteModel.fromFirestore(doc))
            .toList());
  }
  
  // Stream invites for an organization
  Stream<List<InviteModel>> streamOrganizationInvites(
    String organizationId, {
    bool pendingOnly = true,
  }) {
    Query query = _collection.where('organization_id', isEqualTo: organizationId);
    
    if (pendingOnly) {
      query = query.where(
        'status',
        isEqualTo: InviteStatus.pending.toString().split('.').last,
      );
    }
    
    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => InviteModel.fromFirestore(doc))
        .toList());
  }
  
  // Check if email is already invited to an organization
  Future<bool> isEmailInvitedToOrganization(
    String email,
    String organizationId,
  ) async {
    final standardizedEmail = email.toLowerCase().trim();
    
    final querySnapshot = await _collection
        .where('email', isEqualTo: standardizedEmail)
        .where('organization_id', isEqualTo: organizationId)
        .where('status', isEqualTo: InviteStatus.pending.toString().split('.').last)
        .where('expiry_date', isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .limit(1)
        .get();
    
    return querySnapshot.docs.isNotEmpty;
  }
}