import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:architecto/data/models/user_model.dart';
import 'package:architecto/constants/db_constants.dart';

class UserRepository {
  final CollectionReference _collection = 
      FirebaseFirestore.instance.collection(DBConstants.users);
  
  // Create a new user
  Future<void> createUser(
    String id, 
    String email, 
    String name, 
    String? phone,
  ) async {
    final userModel = UserModel(
      id: id,
      email: email,
      name: name,
      phone: phone,
      createdAt: DateTime.now().toUtc(),
    );
    
    await _collection.doc(id).set(userModel.toJson());
  }
  
  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    final doc = await _collection.doc(userId).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = userId;
      return UserModel.fromJson(data);
    }
    return null;
  }
  
  // Get user by email
  Future<UserModel?> getUserByEmail(String email) async {
    final querySnapshot = await _collection
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    
    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return UserModel.fromJson(data);
    }
    return null;
  }
  
  // Update user profile (name, phone)
  Future<void> updateUserProfile(String userId, String name, String? phone) async {
    await _collection.doc(userId).update({
      'name': name,
      'phone': phone,
      'updated_at': Timestamp.fromDate(DateTime.now().toUtc()),
    });
  }
  
  // Update user's last active timestamp (internal method for AuthService)
  Future<void> updateLastActive(String userId) async {
    await _collection.doc(userId).update({
      'last_active_at': Timestamp.fromDate(DateTime.now().toUtc()),
    });
  }
  
  // Delete user
  Future<void> deleteUser(String userId) async {
    await _collection.doc(userId).delete();
  }
  
  // Stream user data
  Stream<UserModel?> streamUser(String userId) {
    return _collection.doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return UserModel.fromJson(data);
      }
      return null;
    });
  }
  
  // Check if user exists
  Future<bool> userExists(String userId) async {
    final doc = await _collection.doc(userId).get();
    return doc.exists;
  }
  
  // Check if email exists
  Future<bool> emailExists(String email) async {
    final user = await getUserByEmail(email);
    return user != null;
  }
}