import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:architecto/data/models/models.dart';
import 'package:architecto/constants/db_constants.dart';

class LaborRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection(DBConstants.labors);
  
  // Create a new labor
  Future<String> createLabor(
    String organizationId,
    String name,
    String? phone,
    String? address,
    LaborType type,
    double dailyRate,
    List<ConstructionRole> roles,
    String createdBy,
  ) async {
    // Create labor data
    final labor = LaborModel(
      id: '', // Will be replaced with auto-generated ID
      organizationId: organizationId,
      name: name,
      phone: phone,
      address: address,
      type: type,
      dailyRate: dailyRate,
      joinDate: DateTime.now(),
      roles: roles,
      isActive: true,
      createdAt: DateTime.now(),
      createdBy: createdBy,
    );
    
    // Add to Firestore with auto-generated ID
    final docRef = await _collection.add(labor.toJson());
    
    // Update the labor with its ID
    await docRef.update({'id': docRef.id});
    
    return docRef.id;
  }
  
  // Get labor by ID
  Future<LaborModel?> getLaborById(String laborId) async {
    final doc = await _collection.doc(laborId).get();
    if (doc.exists) {
      return LaborModel.fromFirestore(doc);
    }
    return null;
  }
  
  // Get all labors for an organization
  Future<List<LaborModel>> getLaborsForOrganization(
    String organizationId, {
    bool activeOnly = true,
  }) async {
    Query query = _collection.where('organization_id', isEqualTo: organizationId);
    
    if (activeOnly) {
      query = query.where('is_active', isEqualTo: true);
    }
    
    final querySnapshot = await query.get();
    
    return querySnapshot.docs
        .map((doc) => LaborModel.fromFirestore(doc))
        .toList();
  }
  
  // Get labors by role
  Future<List<LaborModel>> getLaborsByRole(
    String organizationId,
    ConstructionRole role, {
    bool activeOnly = true,
  }) async {
    Query query = _collection
        .where('organization_id', isEqualTo: organizationId)
        .where('roles', arrayContains: role.value);
    
    if (activeOnly) {
      query = query.where('is_active', isEqualTo: true);
    }
    
    final querySnapshot = await query.get();
    
    return querySnapshot.docs
        .map((doc) => LaborModel.fromFirestore(doc))
        .toList();
  }
  
  // Update labor information
  Future<void> updateLabor(
    String laborId, {
    String? name,
    String? phone,
    String? address,
    LaborType? type,
    double? dailyRate,
    List<ConstructionRole>? roles,
    String? updatedBy,
  }) async {
    final Map<String, dynamic> data = {};
    
    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (address != null) data['address'] = address;
    if (type != null) data['type'] = type.toString().split('.').last;
    if (dailyRate != null) data['daily_rate'] = dailyRate;
    if (roles != null) data['roles'] = roles.map((role) => role.value).toList();
    
    data['updated_at'] = Timestamp.now();
    if (updatedBy != null) data['updated_by'] = updatedBy;
    
    await _collection.doc(laborId).update(data);
  }
  
  // Set labor active/inactive status
  Future<void> setLaborActiveStatus(
    String laborId,
    bool isActive,
    String updatedBy,
  ) async {
    await _collection.doc(laborId).update({
      'is_active': isActive,
      'updated_at': Timestamp.now(),
      'updated_by': updatedBy,
    });
  }
  
  // Delete labor
  Future<void> deleteLabor(String laborId) async {
    await _collection.doc(laborId).delete();
  }
  
  // Stream labor data
  Stream<LaborModel?> streamLabor(String laborId) {
    return _collection.doc(laborId).snapshots().map((doc) {
      if (doc.exists) {
        return LaborModel.fromFirestore(doc);
      }
      return null;
    });
  }
  
  // Stream all labors for an organization
  Stream<List<LaborModel>> streamOrganizationLabors(
    String organizationId, {
    bool activeOnly = true,
  }) {
    Query query = _collection.where('organization_id', isEqualTo: organizationId);
    
    if (activeOnly) {
      query = query.where('is_active', isEqualTo: true);
    }
    
    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => LaborModel.fromFirestore(doc)).toList());
  }
}