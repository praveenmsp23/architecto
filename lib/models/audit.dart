import 'package:cloud_firestore/cloud_firestore.dart';

class Audit {
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String createdBy;
  final String updatedBy;

  const Audit({
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
  });

  factory Audit.defaultAudit(String userId) {
    return Audit(
      createdAt: Timestamp.now(),
      updatedAt: Timestamp(0, 0),
      createdBy: userId,
      updatedBy: "",
    );
  }

  factory Audit.fromFirestore(Map<String, dynamic> data) => Audit(
        createdAt: data['createdAt'] as Timestamp? ?? Timestamp.now(),
        updatedAt: data['updatedAt'] as Timestamp? ?? Timestamp(0, 0),
        createdBy: data['createdBy'] as String? ?? '',
        updatedBy: data['updatedBy'] as String? ?? '',
      );

  Map<String, dynamic> toFirestore() => {
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'createdBy': createdBy,
        'updatedBy': updatedBy,
      };
}
