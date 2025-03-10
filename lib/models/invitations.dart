import 'package:architecto/models/audit.dart';
import 'package:architecto/models/member.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Invitations {
  final String email;
  final MemberRole role;
  final String invitedBy;
  final Audit audit;

  const Invitations({
    required this.email,
    required this.role,
    required this.invitedBy,
    required this.audit,
  });

  factory Invitations.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return Invitations(
      email: data['email'] as String? ?? '',
      role: MemberRole.fromString(data['role'] as String? ?? ''),
      invitedBy: data['invitedBy'] as String? ?? '',
      audit: Audit.fromFirestore(data),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'email': email,
        'role': role.value,
        'invitedBy': invitedBy,
        ...audit.toFirestore(),
      };

  @override
  String toString() =>
      'Invitations(email: $email, role: ${role.value}, invitedBy: $invitedBy)';
}
