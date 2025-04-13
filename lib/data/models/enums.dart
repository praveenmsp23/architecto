enum UserRole {
  owner,
  admin,
  member
}

enum InviteStatus {
  pending,
  accepted,
  rejected,
  expired
}

enum AttendanceStatus {
  present,
  absent,
  halfDay,
  leave,
  holiday
}

enum PaymentStatus {
  pending,
  paid,
  partiallyPaid,
  cancelled
}

enum LaborType {
  permanent,
  temporary,
  contract
}

enum ConstructionRole {
  mason,
  carpenter,
  electrician,
  plumber,
  painter,
  helper,
  operator,
  supervisor,
  welder,
  other
}

extension ConstructionRoleExtension on ConstructionRole {
  String get value {
    return toString().split('.').last;
  }

  static ConstructionRole fromString(String value) {
    return ConstructionRole.values.firstWhere(
      (role) => role.toString().split('.').last == value,
      orElse: () => ConstructionRole.other,
    );
  }
}