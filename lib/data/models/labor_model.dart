import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:architecto/data/models/base_model.dart';
import 'package:architecto/data/models/enums.dart';

class LaborModel extends BaseModel {
  final String organizationId;
  final String name;
  final String? phone;
  final String? address;
  final LaborType type;
  final double dailyRate;
  final DateTime joinDate;
  final List<ConstructionRole> roles;
  final bool isActive;

  LaborModel({
    required String id,
    required this.organizationId,
    required this.name,
    this.phone,
    this.address,
    required this.type,
    required this.dailyRate,
    required this.joinDate,
    required this.roles,
    this.isActive = true,
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
      'name': name,
      'phone': phone,
      'address': address,
      'type': type.toString().split('.').last,
      'daily_rate': dailyRate,
      'join_date': Timestamp.fromDate(joinDate),
      'roles': roles.map((role) => role.value).toList(),
      'is_active': isActive,
    };
  }

  factory LaborModel.fromJson(Map<String, dynamic> json) {
    final baseData = BaseModel.fromBaseJson(json);
    return LaborModel(
      id: baseData['id'],
      organizationId: json['organization_id'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      type: LaborType.values.firstWhere(
        (type) => type.toString().split('.').last == json['type'],
        orElse: () => LaborType.permanent,
      ),
      dailyRate: json['daily_rate'].toDouble(),
      joinDate: (json['join_date'] as Timestamp).toDate(),
      roles: (json['roles'] as List<dynamic>?)
          ?.map((role) => ConstructionRoleExtension.fromString(role))
          .toList() ?? [ConstructionRole.helper],
      isActive: json['is_active'] ?? true,
      createdAt: baseData['createdAt'],
      createdBy: baseData['createdBy'],
      updatedAt: baseData['updatedAt'],
      updatedBy: baseData['updatedBy'],
    );
  }

  factory LaborModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return LaborModel.fromJson(data);
  }

  LaborModel copyWith({
    String? id,
    String? organizationId,
    String? name,
    String? phone,
    String? address,
    LaborType? type,
    double? dailyRate,
    DateTime? joinDate,
    List<ConstructionRole>? roles,
    bool? isActive,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
  }) {
    return LaborModel(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      type: type ?? this.type,
      dailyRate: dailyRate ?? this.dailyRate,
      joinDate: joinDate ?? this.joinDate,
      roles: roles ?? this.roles,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}