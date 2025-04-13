class AppConstants {
  // Auth related
  static const int minPasswordLength = 8;
  static const int maxLoginAttempts = 5;
  static const int otpExpiryMinutes = 5;
  
  // Organization related
  static const int maxMembersInOrganization = 50;
  static const int inviteExpiryDays = 7;
  
  // Labor related
  static const int defaultWorkingHoursPerDay = 8;
  static const int maxLaborsPerOrganization = 100;
  
  // UI related
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
  static const double defaultSpacing = 8.0;
  static const double defaultButtonHeight = 44.0;
  static const double defaultIconSize = 24.0;
}