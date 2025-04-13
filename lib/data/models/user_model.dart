import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:architecto/data/models/base_model.dart';

class UserModel extends BaseModel {
  final String email;
  final String name;
  final String? phone;
  final DateTime? lastActiveAt;

  UserModel({
    required String id,
    required this.email,
    required this.name,
    this.phone,
    this.lastActiveAt,
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
      'email': email,
      'name': name,
      'phone': phone,
      'last_active_at': lastActiveAt != null ? Timestamp.fromDate(lastActiveAt!.toUtc()) : null,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final baseData = BaseModel.fromBaseJson(json);
    return UserModel(
      id: baseData['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      lastActiveAt: json['last_active_at'] != null 
          ? (json['last_active_at'] as Timestamp).toDate().toUtc() 
          : null,
      createdAt: baseData['createdAt'],
      createdBy: baseData['createdBy'],
      updatedAt: baseData['updatedAt'],
      updatedBy: baseData['updatedBy'],
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return UserModel.fromJson(data);
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    DateTime? lastActiveAt,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}