class AppConstants {
  // App Info
  static const String appName = 'Property Master';
  static const String appVersion = '1.0.0';

  // API Constants
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userInfoKey = 'user_info';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String firstLaunchKey = 'first_launch';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> allowedDocTypes = ['pdf', 'doc', 'docx'];

  // Date Formats
  static const String defaultDateFormat = 'dd/MM/yyyy';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String apiDateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  // Currency
  static const String defaultCurrency = 'INR';
  static const String currencySymbol = '₹';

  // Property Types
  static const List<String> propertyTypes = [
    'Apartment',
    'House',
    'Villa',
    'Commercial',
    'Office Space',
    'Warehouse',
    'Shop',
    'Land',
  ];

  // Lease Status
  static const String leaseStatusActive = 'Active';
  static const String leaseStatusExpired = 'Expired';
  static const String leaseStatusTerminated = 'Terminated';
  static const String leaseStatusPending = 'Pending';

  // Payment Status
  static const String paymentStatusPaid = 'Paid';
  static const String paymentStatusPending = 'Pending';
  static const String paymentStatusOverdue = 'Overdue';
  static const String paymentStatusPartial = 'Partial';

  // Payment Types
  static const List<String> paymentTypes = [
    'Rent',
    'Security Deposit',
    'Maintenance',
    'Utility Bills',
    'Late Fee',
    'Other',
  ];

  // Notification Types
  static const String notificationRentDue = 'rent_due';
  static const String notificationLeaseExpiry = 'lease_expiry';
  static const String notificationMaintenance = 'maintenance';
  static const String notificationPaymentReceived = 'payment_received';

  // Regex Patterns
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phonePattern = r'^[+]?[0-9]{10,15}$';
  static const String passwordPattern =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$';

  // Error Messages
  static const String networkError = 'Please check your internet connection';
  static const String serverError =
      'Server error occurred. Please try again later';
  static const String unknownError = 'An unknown error occurred';
  static const String cacheError = 'Failed to load cached data';

  // Success Messages
  static const String loginSuccess = 'Logged in successfully';
  static const String registrationSuccess = 'Account created successfully';
  static const String updateSuccess = 'Updated successfully';
  static const String deleteSuccess = 'Deleted successfully';
  static const String saveSuccess = 'Saved successfully';

  // Validation Messages
  static const String requiredField = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String invalidPhone = 'Please enter a valid phone number';
  static const String weakPassword =
      'Password must be at least 8 characters with uppercase, lowercase, and number';
  static const String passwordMismatch = 'Passwords do not match';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;
  static const double iconSize = 24.0;

  static const List<String> reportTypes = [
    'Monthly Income',
    'Annual Income',
    'Property Wise Income',
    'Tenant Payment History',
    'Occupancy Report',
    'Maintenance Report',
    'Tax Report',
    'Expense Report',
  ];

  static const Duration dashboardRefreshInterval = Duration(minutes: 5);
  static const Duration notificationCheckInterval = Duration(minutes: 15);
}
