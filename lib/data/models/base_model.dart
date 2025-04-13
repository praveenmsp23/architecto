import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseModel {
  final String id;
  final DateTime createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;

  BaseModel({
    required this.id,
    required this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  Map<String, dynamic> toBaseJson() {
    return {
      'id': id,
      'created_at': Timestamp.fromDate(createdAt.toUtc()),
      'created_by': createdBy,
      'updated_at': updatedAt != null ? Timestamp.fromDate(updatedAt!.toUtc()) : null,
      'updated_by': updatedBy,
    };
  }

  // Abstract method that should be implemented by subclasses
  Map<String, dynamic> toJson();

  static Map<String, dynamic> fromBaseJson(Map<String, dynamic> json) {
    return {
      'id': json['id'],
      'createdAt': (json['created_at'] as Timestamp).toDate().toUtc(),
      'createdBy': json['created_by'],
      'updatedAt': json['updated_at'] != null 
          ? (json['updated_at'] as Timestamp).toDate().toUtc() 
          : null,
      'updatedBy': json['updated_by'],
    };
  }
}