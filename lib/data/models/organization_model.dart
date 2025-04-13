import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:architecto/data/models/base_model.dart';
import 'package:architecto/data/models/enums.dart';

class OrganizationMember {
  final String userId;
  final UserRole role;
  
  OrganizationMember({
    required this.userId,
    required this.role,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'role': role.toString().split('.').last,
    };
  }
  
  factory OrganizationMember.fromJson(Map<String, dynamic> json) {
    return OrganizationMember(
      userId: json['user_id'],
      role: UserRole.values.firstWhere(
        (role) => role.toString().split('.').last == json['role'],
        orElse: () => UserRole.member,
      ),
    );
  }
}

class OrganizationModel extends BaseModel {
  final String name;
  final String ownerId;
  final List<OrganizationMember> members;

  OrganizationModel({
    required String id,
    required this.name,
    required this.ownerId,
    required this.members,
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
      'name': name,
      'owner_id': ownerId,
      'members': members.map((member) => member.toJson()).toList(),
    };
  }

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    final baseData = BaseModel.fromBaseJson(json);
    return OrganizationModel(
      id: baseData['id'],
      name: json['name'],
      ownerId: json['owner_id'],
      members: (json['members'] as List?)
          ?.map((member) => OrganizationMember.fromJson(member))
          .toList() ?? [],
      createdAt: baseData['createdAt'],
      createdBy: baseData['createdBy'],
      updatedAt: baseData['updatedAt'],
      updatedBy: baseData['updatedBy'],
    );
  }

  factory OrganizationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return OrganizationModel.fromJson(data);
  }

  OrganizationModel copyWith({
    String? id,
    String? name,
    String? ownerId,
    List<OrganizationMember>? members,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
  }) {
    return OrganizationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}