import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:architecto/data/models/base_model.dart';
import 'package:architecto/data/models/enums.dart';

class InviteModel extends BaseModel {
  final String organizationId;
  final String organizationName;
  final String email;
  final UserRole role;
  final InviteStatus status;
  final DateTime expiryDate;
  final String invitedById;

  InviteModel({
    required String id,
    required this.organizationId,
    required this.organizationName,
    required this.email,
    required this.role,
    required this.status,
    required this.expiryDate,
    required this.invitedById,
    required DateTime createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
  }) : super(
          id: id,
          createdAt: createdAt,
          createdBy: createdBy,
          updatedAt: updatedAt,
          updatedBy: updatedBy,
        );

  @override
  Map<String, dynamic> toJson() {
    final baseJson = toBaseJson();
    return {
      ...baseJson,
      'organization_id': organizationId,
      'organization_name': organizationName,
      'email': email,
      'role': role.toString().split('.').last,
      'status': status.toString().split('.').last,
      'expiry_date': Timestamp.fromDate(expiryDate),
      'invited_by_id': invitedById,
    };
  }

  factory InviteModel.fromJson(Map<String, dynamic> json) {
    final baseData = BaseModel.fromBaseJson(json);
    return InviteModel(
      id: baseData['id'],
      organizationId: json['organization_id'],
      organizationName: json['organization_name'],
      email: json['email'],
      role: UserRole.values.firstWhere(
        (role) => role.toString().split('.').last == json['role'],
        orElse: () => UserRole.member,
      ),
      status: InviteStatus.values.firstWhere(
        (status) => status.toString().split('.').last == json['status'],
        orElse: () => InviteStatus.pending,
      ),
      expiryDate: (json['expiry_date'] as Timestamp).toDate(),
      invitedById: json['invited_by_id'],
      createdAt: baseData['createdAt'],
      createdBy: baseData['createdBy'],
      updatedAt: baseData['updatedAt'],
      updatedBy: baseData['updatedBy'],
    );
  }

  factory InviteModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return InviteModel.fromJson(data);
  }

  bool get isExpired => DateTime.now().isAfter(expiryDate);

  InviteModel copyWith({
    String? id,
    String? organizationId,
    String? organizationName,
    String? email,
    UserRole? role,
    InviteStatus? status,
    DateTime? expiryDate,
    String? invitedById,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
  }) {
    return InviteModel(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      organizationName: organizationName ?? this.organizationName,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      expiryDate: expiryDate ?? this.expiryDate,
      invitedById: invitedById ?? this.invitedById,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}