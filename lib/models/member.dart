import 'package:architecto/models/audit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum MemberRole {
  owner,
  admin,
  viewer;

  String get value => name;

  static MemberRole fromString(String value) {
    return MemberRole.values.firstWhere(
      (role) => role.name == value,
      orElse: () => MemberRole.viewer,
    );
  }
}

class Member {
  final String user;
  final String email;
  final MemberRole role;
  final Audit audit;

  const Member({
    required this.user,
    required this.email,
    required this.role,
    required this.audit,
  });

  factory Member.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return Member(
      user: data['user'] as String? ?? '',
      email: data['email'] as String? ?? '',
      role: MemberRole.fromString(data['role'] as String? ?? ''),
      audit: Audit.fromFirestore(data),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'user': user,
        'email': email,
        'role': role.value,
        ...audit.toFirestore(),
      };

  @override
  String toString() =>
      'Member(user: $user, email: $email, role: ${role.value})';
}
