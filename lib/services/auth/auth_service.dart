import 'package:firebase_auth/firebase_auth.dart';
import 'package:architecto/data/repositories/user_repository.dart';
import 'package:architecto/data/models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();
  
  static UserModel? _currentUser;
  static UserModel? get user => _currentUser;
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository _userRepository = UserRepository();
  
  // Get current user
  User? get currentUser => _auth.currentUser;
  
  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;
  
  // Check if user is logged in
  bool get isLoggedIn => _auth.currentUser != null;
  
  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Fetch user data from server
  Future<void> fetchUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      _currentUser = await _userRepository.getUserById(user.uid);
      await updateLastActive();
    }
  }
  
  // Update user's last active timestamp
  Future<void> updateLastActive() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _userRepository.updateLastActive(user.uid);
    }
  }
  
  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      // Update last active timestamp
      if (userCredential.user != null) {
        await _userRepository.updateLastActive(userCredential.user!.uid);
        await fetchUser();
      }
      
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }
  
  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
    String email, 
    String password, 
    String name, 
    String? phone
  ) async {
    try {
      // Create the user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      // Create the user profile in Firestore
      if (userCredential.user != null) {
        await _userRepository.createUser(
          userCredential.user!.uid,
          email,
          name,
          phone,
        );
        
        // Set initial last active timestamp
        await _userRepository.updateLastActive(userCredential.user!.uid);
        await fetchUser();
      }
      
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    _currentUser = null;
    await _auth.signOut();
  }
  
  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }
  
  // Change password
  Future<void> changePassword(String currentPassword, String newPassword) async {
    final user = _auth.currentUser;
    if (user != null && user.email != null) {
      // Re-authenticate the user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      
      await user.reauthenticateWithCredential(credential);
      
      // Change password
      await user.updatePassword(newPassword);
    }
  }
  
  // Delete account
  Future<void> deleteAccount(String password) async {
    final user = _auth.currentUser;
    if (user != null && user.email != null) {
      // Re-authenticate the user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      
      await user.reauthenticateWithCredential(credential);
      
      // Delete user from Firestore
      await _userRepository.deleteUser(user.uid);
      
      // Delete user from Firebase Auth
      await user.delete();
      
      // Clear local data
      _currentUser = null;
    }
  }
}