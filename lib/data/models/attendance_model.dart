import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:architecto/data/models/base_model.dart';
import 'package:architecto/data/models/enums.dart';

class AttendanceModel extends BaseModel {
  final String organizationId;
  final String laborId;
  final DateTime date;
  final AttendanceStatus status;
  final double? hours;
  final String? notes;
  final String markedById;

  AttendanceModel({
    required String id,
    required this.organizationId,
    required this.laborId,
    required this.date,
    required this.status,
    this.hours,
    this.notes,
    required this.markedById,
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
      'labor_id': laborId,
      'date': Timestamp.fromDate(date.toUtc()),
      'status': status.toString().split('.').last,
      'hours': hours,
      'notes': notes,
      'marked_by_id': markedById,
    };
  }

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    final baseData = BaseModel.fromBaseJson(json);
    return AttendanceModel(
      id: baseData['id'],
      organizationId: json['organization_id'],
      laborId: json['labor_id'],
      date: (json['date'] as Timestamp).toDate().toUtc(),
      status: AttendanceStatus.values.firstWhere(
        (status) => status.toString().split('.').last == json['status'],
        orElse: () => AttendanceStatus.absent,
      ),
      hours: json['hours']?.toDouble(),
      notes: json['notes'],
      markedById: json['marked_by_id'],
      createdAt: baseData['createdAt'],
      createdBy: baseData['createdBy'],
      updatedAt: baseData['updatedAt'],
      updatedBy: baseData['updatedBy'],
    );
  }

  factory AttendanceModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return AttendanceModel.fromJson(data);
  }

  AttendanceModel copyWith({
    String? id,
    String? organizationId,
    String? laborId,
    DateTime? date,
    AttendanceStatus? status,
    double? hours,
    String? notes,
    String? markedById,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      laborId: laborId ?? this.laborId,
      date: date ?? this.date,
      status: status ?? this.status,
      hours: hours ?? this.hours,
      notes: notes ?? this.notes,
      markedById: markedById ?? this.markedById,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}