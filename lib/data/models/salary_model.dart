import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:architecto/data/models/base_model.dart';
import 'package:architecto/data/models/enums.dart';

class SalaryModel extends BaseModel {
  final String organizationId;
  final String laborId;
  final int month;
  final int year;
  final double amount;
  final int workingDays;
  final PaymentStatus status;
  final DateTime? paymentDate;
  final String? notes;

  SalaryModel({
    required String id,
    required this.organizationId,
    required this.laborId,
    required this.month,
    required this.year,
    required this.amount,
    required this.workingDays,
    required this.status,
    this.paymentDate,
    this.notes,
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
      'month': month,
      'year': year,
      'amount': amount,
      'working_days': workingDays,
      'status': status.toString().split('.').last,
      'payment_date': paymentDate != null ? Timestamp.fromDate(paymentDate!.toUtc()) : null,
      'notes': notes,
    };
  }

  factory SalaryModel.fromJson(Map<String, dynamic> json) {
    final baseData = BaseModel.fromBaseJson(json);
    return SalaryModel(
      id: baseData['id'],
      organizationId: json['organization_id'],
      laborId: json['labor_id'],
      month: json['month'],
      year: json['year'],
      amount: json['amount'].toDouble(),
      workingDays: json['working_days'],
      status: PaymentStatus.values.firstWhere(
        (status) => status.toString().split('.').last == json['status'],
        orElse: () => PaymentStatus.pending,
      ),
      paymentDate: json['payment_date'] != null
          ? (json['payment_date'] as Timestamp).toDate().toUtc()
          : null,
      notes: json['notes'],
      createdAt: baseData['createdAt'],
      createdBy: baseData['createdBy'],
      updatedAt: baseData['updatedAt'],
      updatedBy: baseData['updatedBy'],
    );
  }

  factory SalaryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return SalaryModel.fromJson(data);
  }

  SalaryModel copyWith({
    String? id,
    String? organizationId,
    String? laborId,
    int? month,
    int? year,
    double? amount,
    int? workingDays,
    PaymentStatus? status,
    DateTime? paymentDate,
    String? notes,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
  }) {
    return SalaryModel(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      laborId: laborId ?? this.laborId,
      month: month ?? this.month,
      year: year ?? this.year,
      amount: amount ?? this.amount,
      workingDays: workingDays ?? this.workingDays,
      status: status ?? this.status,
      paymentDate: paymentDate ?? this.paymentDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}