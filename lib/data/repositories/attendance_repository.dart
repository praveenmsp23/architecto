import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:architecto/data/models/models.dart';
import 'package:architecto/constants/db_constants.dart';

class AttendanceRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection(DBConstants.attendance);
  
  // Create a new attendance record
  Future<String> createAttendance(
    String organizationId,
    String laborId,
    DateTime date,
    AttendanceStatus status,
    double? hours,
    String? notes,
    String markedById,
  ) async {
    // Create attendance data
    final attendance = AttendanceModel(
      id: '', // Will be replaced with auto-generated ID
      organizationId: organizationId,
      laborId: laborId,
      date: date,
      status: status,
      hours: hours,
      notes: notes,
      markedById: markedById,
      createdAt: DateTime.now().toUtc(),
      createdBy: markedById,
    );
    
    // Add to Firestore with auto-generated ID
    final docRef = await _collection.add(attendance.toJson());
    
    // Update the attendance with its ID
    await docRef.update({'id': docRef.id});
    
    return docRef.id;
  }
  
  // Get attendance by ID
  Future<AttendanceModel?> getAttendanceById(String attendanceId) async {
    final doc = await _collection.doc(attendanceId).get();
    if (doc.exists) {
      return AttendanceModel.fromFirestore(doc);
    }
    return null;
  }
  
  // Get attendance for a labor on a specific date
  Future<AttendanceModel?> getAttendanceByLaborAndDate(
    String laborId,
    DateTime date,
  ) async {
    // Convert DateTime to start and end of the day
    final startDate = DateTime(date.year, date.month, date.day).toUtc();
    final endDate = DateTime(date.year, date.month, date.day, 23, 59, 59).toUtc();
    
    final querySnapshot = await _collection
        .where('labor_id', isEqualTo: laborId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .limit(1)
        .get();
    
    if (querySnapshot.docs.isNotEmpty) {
      return AttendanceModel.fromFirestore(querySnapshot.docs.first);
    }
    return null;
  }
  
  // Get attendance for an organization on a specific date
  Future<List<AttendanceModel>> getOrganizationAttendanceByDate(
    String organizationId,
    DateTime date,
  ) async {
    // Convert DateTime to start and end of the day
    final startDate = DateTime(date.year, date.month, date.day).toUtc();
    final endDate = DateTime(date.year, date.month, date.day, 23, 59, 59).toUtc();
    
    final querySnapshot = await _collection
        .where('organization_id', isEqualTo: organizationId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();
    
    return querySnapshot.docs
        .map((doc) => AttendanceModel.fromFirestore(doc))
        .toList();
  }
  
  // Get attendance for a labor in a date range
  Future<List<AttendanceModel>> getLaborAttendanceInRange(
    String laborId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final querySnapshot = await _collection
        .where('labor_id', isEqualTo: laborId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate.toUtc()))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate.toUtc()))
        .orderBy('date')
        .get();
    
    return querySnapshot.docs
        .map((doc) => AttendanceModel.fromFirestore(doc))
        .toList();
  }
  
  // Update attendance
  Future<void> updateAttendance(
    String attendanceId, {
    AttendanceStatus? status,
    double? hours,
    String? notes,
    String? updatedBy,
  }) async {
    final Map<String, dynamic> data = {};
    
    if (status != null) data['status'] = status.toString().split('.').last;
    if (hours != null) data['hours'] = hours;
    if (notes != null) data['notes'] = notes;
    
    data['updated_at'] = Timestamp.fromDate(DateTime.now().toUtc());
    if (updatedBy != null) data['updated_by'] = updatedBy;
    
    await _collection.doc(attendanceId).update(data);
  }
  
  // Delete attendance
  Future<void> deleteAttendance(String attendanceId) async {
    await _collection.doc(attendanceId).delete();
  }
  
  // Stream attendance for a labor on a specific date
  Stream<AttendanceModel?> streamLaborAttendanceByDate(
    String laborId,
    DateTime date,
  ) {
    // Convert DateTime to start and end of the day
    final startDate = DateTime(date.year, date.month, date.day).toUtc();
    final endDate = DateTime(date.year, date.month, date.day, 23, 59, 59).toUtc();
    
    return _collection
        .where('labor_id', isEqualTo: laborId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            return AttendanceModel.fromFirestore(snapshot.docs.first);
          }
          return null;
        });
  }
  
  // Stream organization attendance by date
  Stream<List<AttendanceModel>> streamOrganizationAttendanceByDate(
    String organizationId,
    DateTime date,
  ) {
    // Convert DateTime to start and end of the day
    final startDate = DateTime(date.year, date.month, date.day).toUtc();
    final endDate = DateTime(date.year, date.month, date.day, 23, 59, 59).toUtc();
    
    return _collection
        .where('organization_id', isEqualTo: organizationId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AttendanceModel.fromFirestore(doc))
            .toList());
  }
  
  // Get attendance count by status in a date range for an organization
  Future<Map<AttendanceStatus, int>> getAttendanceStatsByStatus(
    String organizationId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final querySnapshot = await _collection
        .where('organization_id', isEqualTo: organizationId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate.toUtc()))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate.toUtc()))
        .get();
    
    final attendanceList = querySnapshot.docs
        .map((doc) => AttendanceModel.fromFirestore(doc))
        .toList();
    
    final Map<AttendanceStatus, int> stats = {};
    
    for (final status in AttendanceStatus.values) {
      stats[status] = attendanceList.where((a) => a.status == status).length;
    }
    
    return stats;
  }
}