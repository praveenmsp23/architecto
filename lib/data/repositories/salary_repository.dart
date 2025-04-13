import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:architecto/data/models/models.dart';
import 'package:architecto/constants/db_constants.dart';

class SalaryRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection(DBConstants.salary);
  
  // Create a new salary record
  Future<String> createSalary(
    String organizationId,
    String laborId,
    int month,
    int year,
    double amount,
    int workingDays,
    PaymentStatus status,
    DateTime? paymentDate,
    String? notes,
    String createdById,
  ) async {
    // Create salary data
    final salary = SalaryModel(
      id: '', // Will be replaced with auto-generated ID
      organizationId: organizationId,
      laborId: laborId,
      month: month,
      year: year,
      amount: amount,
      workingDays: workingDays,
      status: status,
      paymentDate: paymentDate,
      notes: notes,
      createdAt: DateTime.now().toUtc(),
      createdBy: createdById,
    );
    
    // Add to Firestore with auto-generated ID
    final docRef = await _collection.add(salary.toJson());
    
    // Update the salary with its ID
    await docRef.update({'id': docRef.id});
    
    return docRef.id;
  }
  
  // Get salary by ID
  Future<SalaryModel?> getSalaryById(String salaryId) async {
    final doc = await _collection.doc(salaryId).get();
    if (doc.exists) {
      return SalaryModel.fromFirestore(doc);
    }
    return null;
  }
  
  // Get salary for a labor in a specific month and year
  Future<SalaryModel?> getSalaryByLaborAndMonth(
    String laborId,
    int month,
    int year,
  ) async {
    final querySnapshot = await _collection
        .where('labor_id', isEqualTo: laborId)
        .where('month', isEqualTo: month)
        .where('year', isEqualTo: year)
        .limit(1)
        .get();
    
    if (querySnapshot.docs.isNotEmpty) {
      return SalaryModel.fromFirestore(querySnapshot.docs.first);
    }
    return null;
  }
  
  // Get all salaries for an organization in a specific month and year
  Future<List<SalaryModel>> getOrganizationSalariesByMonth(
    String organizationId,
    int month,
    int year,
  ) async {
    final querySnapshot = await _collection
        .where('organization_id', isEqualTo: organizationId)
        .where('month', isEqualTo: month)
        .where('year', isEqualTo: year)
        .get();
    
    return querySnapshot.docs
        .map((doc) => SalaryModel.fromFirestore(doc))
        .toList();
  }
  
  // Get salaries for a labor in a date range (for reports)
  Future<List<SalaryModel>> getLaborSalariesInRange(
    String laborId,
    int startMonth,
    int startYear,
    int endMonth,
    int endYear,
  ) async {
    // Calculate start and end timestamps for the query
    // This assumes we can order by a composite of year and month
    final startKey = startYear * 100 + startMonth; // e.g., 202301
    final endKey = endYear * 100 + endMonth; // e.g., 202312
    
    final salaries = <SalaryModel>[];
    
    // We need to query all and then filter because Firestore has limited support for compound queries
    final querySnapshot = await _collection
        .where('labor_id', isEqualTo: laborId)
        .get();
    
    for (final doc in querySnapshot.docs) {
      final salary = SalaryModel.fromFirestore(doc);
      final salaryKey = salary.year * 100 + salary.month;
      
      if (salaryKey >= startKey && salaryKey <= endKey) {
        salaries.add(salary);
      }
    }
    
    // Sort by year and month
    salaries.sort((a, b) {
      final aKey = a.year * 100 + a.month;
      final bKey = b.year * 100 + b.month;
      return aKey.compareTo(bKey);
    });
    
    return salaries;
  }
  
  // Update salary
  Future<void> updateSalary(
    String salaryId, {
    double? amount,
    int? workingDays,
    PaymentStatus? status,
    DateTime? paymentDate,
    String? notes,
    String? updatedBy,
  }) async {
    final Map<String, dynamic> data = {};
    
    if (amount != null) data['amount'] = amount;
    if (workingDays != null) data['working_days'] = workingDays;
    if (status != null) data['status'] = status.toString().split('.').last;
    if (paymentDate != null) data['payment_date'] = Timestamp.fromDate(paymentDate.toUtc());
    if (notes != null) data['notes'] = notes;
    
    data['updated_at'] = Timestamp.fromDate(DateTime.now().toUtc());
    if (updatedBy != null) data['updated_by'] = updatedBy;
    
    await _collection.doc(salaryId).update(data);
  }
  
  // Mark salary as paid
  Future<void> markSalaryAsPaid(
    String salaryId,
    DateTime paymentDate,
    String updatedBy,
  ) async {
    await _collection.doc(salaryId).update({
      'status': PaymentStatus.paid.toString().split('.').last,
      'payment_date': Timestamp.fromDate(paymentDate.toUtc()),
      'updated_at': Timestamp.fromDate(DateTime.now().toUtc()),
      'updated_by': updatedBy,
    });
  }
  
  // Delete salary
  Future<void> deleteSalary(String salaryId) async {
    await _collection.doc(salaryId).delete();
  }
  
  // Stream salary data
  Stream<SalaryModel?> streamSalary(String salaryId) {
    return _collection.doc(salaryId).snapshots().map((doc) {
      if (doc.exists) {
        return SalaryModel.fromFirestore(doc);
      }
      return null;
    });
  }
  
  // Stream all salaries for an organization in a specific month and year
  Stream<List<SalaryModel>> streamOrganizationSalariesByMonth(
    String organizationId,
    int month,
    int year,
  ) {
    return _collection
        .where('organization_id', isEqualTo: organizationId)
        .where('month', isEqualTo: month)
        .where('year', isEqualTo: year)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SalaryModel.fromFirestore(doc))
            .toList());
  }
  
  // Get total salaries paid/pending for an organization in a month
  Future<Map<String, double>> getSalaryStatsByMonth(
    String organizationId,
    int month,
    int year,
  ) async {
    final querySnapshot = await _collection
        .where('organization_id', isEqualTo: organizationId)
        .where('month', isEqualTo: month)
        .where('year', isEqualTo: year)
        .get();
    
    final salaries = querySnapshot.docs
        .map((doc) => SalaryModel.fromFirestore(doc))
        .toList();
    
    double totalAmount = 0;
    double paidAmount = 0;
    double pendingAmount = 0;
    
    for (final salary in salaries) {
      totalAmount += salary.amount;
      
      if (salary.status == PaymentStatus.paid) {
        paidAmount += salary.amount;
      } else if (salary.status == PaymentStatus.pending) {
        pendingAmount += salary.amount;
      } else if (salary.status == PaymentStatus.partiallyPaid) {
        // For partially paid, we'd need to track actual amounts paid
        // This is simplified - you might want to add a 'paidAmount' field to your model
        paidAmount += salary.amount / 2; // Simplified assumption
        pendingAmount += salary.amount / 2;
      }
    }
    
    return {
      'total': totalAmount,
      'paid': paidAmount,
      'pending': pendingAmount,
    };
  }
}