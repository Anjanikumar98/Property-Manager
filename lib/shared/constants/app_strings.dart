class AppStrings {
  // App
  static const String appName = 'Property Master';
  static const String appTagline = 'Manage your properties with ease';

  // Common
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String add = 'Add';
  static const String update = 'Update';
  static const String search = 'Search';
  static const String filter = 'Filter';
  static const String sort = 'Sort';
  static const String refresh = 'Refresh';
  static const String loading = 'Loading...';
  static const String noDataFound = 'No data found';
  static const String tryAgain = 'Try Again';
  static const String comingSoon = 'Coming Soon';

  // Auth
  static const String login = 'Login';
  static const String logout = 'Logout';
  static const String register = 'Register';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String dontHaveAccount = "Don't have an account?";
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String signUp = 'Sign Up';
  static const String signIn = 'Sign In';
  static const String fullName = 'Full Name';
  static const String phoneNumber = 'Phone Number';

  // Dashboard
  static const String dashboard = 'Dashboard';
  static const String totalProperties = 'Total Properties';
  static const String occupiedProperties = 'Occupied';
  static const String vacantProperties = 'Vacant';
  static const String totalTenants = 'Total Tenants';
  static const String monthlyIncome = 'Monthly Income';
  static const String pendingPayments = 'Pending Payments';
  static const String overduePayments = 'Overdue Payments';
  static const String recentActivities = 'Recent Activities';
  static const String quickActions = 'Quick Actions';

  // Properties
  static const String properties = 'Properties';
  static const String property = 'Property';
  static const String addProperty = 'Add Property';
  static const String editProperty = 'Edit Property';
  static const String propertyName = 'Property Name';
  static const String propertyType = 'Property Type';
  static const String address = 'Address';
  static const String city = 'City';
  static const String state = 'State';
  static const String pinCode = 'Pin Code';
  static const String bedrooms = 'Bedrooms';
  static const String bathrooms = 'Bathrooms';
  static const String area = 'Area (sq ft)';
  static const String rentAmount = 'Rent Amount';
  static const String securityDeposit = 'Security Deposit';
  static const String description = 'Description';
  static const String propertyImages = 'Property Images';
  static const String available = 'Available';
  static const String occupied = 'Occupied';
  static const String propertyDetails = 'Property Details';

  // Tenants
  static const String tenants = 'Tenants';
  static const String tenant = 'Tenant';
  static const String addTenant = 'Add Tenant';
  static const String editTenant = 'Edit Tenant';
  static const String tenantName = 'Tenant Name';
  static const String tenantEmail = 'Email Address';
  static const String tenantPhone = 'Phone Number';
  static const String dateOfBirth = 'Date of Birth';
  static const String occupation = 'Occupation';
  static const String emergencyContact = 'Emergency Contact';
  static const String tenantDocuments = 'Documents';
  static const String tenantDetails = 'Tenant Details';

  // Leases
  static const String leases = 'Leases';
  static const String lease = 'Lease';
  static const String createLease = 'Create Lease';
  static const String editLease = 'Edit Lease';
  static const String selectProperty = 'Select Property';
  static const String selectTenant = 'Select Tenant';
  static const String startDate = 'Start Date';
  static const String endDate = 'End Date';
  static const String rentDueDay = 'Rent Due Day';
  static const String leaseTerms = 'Lease Terms';
  static const String leaseStatus = 'Status';
  static const String activeLease = 'Active';
  static const String expiredLease = 'Expired';
  static const String terminatedLease = 'Terminated';
  static const String pendingLease = 'Pending';
  static const String terminateLease = 'Terminate Lease';
  static const String leaseDetails = 'Lease Details';

  // Payments
  static const String payments = 'Payments';
  static const String payment = 'Payment';
  static const String recordPayment = 'Record Payment';
  static const String editPayment = 'Edit Payment';
  static const String paymentAmount = 'Amount';
  static const String paymentType = 'Payment Type';
  static const String paymentDate = 'Payment Date';
  static const String dueDate = 'Due Date';
  static const String paymentStatus = 'Status';
  static const String paymentMethod = 'Payment Method';
  static const String paymentNotes = 'Notes';
  static const String receipt = 'Receipt';
  static const String paidPayment = 'Paid';
  static const String pendingPayment = 'Pending';
  static const String overduePayment = 'Overdue';
  static const String partialPayment = 'Partial';
  static const String paymentHistory = 'Payment History';
  static const String paymentDetails = 'Payment Details';

  // Payment Types
  static const String rent = 'Rent';
  static const String maintenance = 'Maintenance';
  static const String utilityBills = 'Utility Bills';
  static const String lateFee = 'Late Fee';
  static const String other = 'Other';

  // Payment Methods
  static const String cash = 'Cash';
  static const String bankTransfer = 'Bank Transfer';
  static const String upi = 'UPI';
  static const String cheque = 'Cheque';
  static const String creditCard = 'Credit Card';
  static const String debitCard = 'Debit Card';

  // Reports
  static const String reports = 'Reports';
  static const String generateReport = 'Generate Report';
  static const String reportType = 'Report Type';
  static const String dateRange = 'Date Range';
  static const String fromDate = 'From Date';
  static const String toDate = 'To Date';
  static const String incomeReport = 'Income Report';
  static const String expenseReport = 'Expense Report';
  static const String occupancyReport = 'Occupancy Report';
  static const String tenantReport = 'Tenant Report';
  static const String exportPdf = 'Export PDF';
  static const String exportExcel = 'Export Excel';

  // Settings
  static const String settings = 'Settings';
  static const String profile = 'Profile';
  static const String notifications = 'Notifications';
  static const String security = 'Security';
  static const String backup = 'Backup';
  static const String about = 'About';
  static const String help = 'Help';
  static const String contactSupport = 'Contact Support';

  // Validation Messages
  static const String requiredField = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String invalidPhone = 'Please enter a valid phone number';
  static const String passwordTooShort =
      'Password must be at least 8 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String invalidAmount = 'Please enter a valid amount';
  static const String invalidDate = 'Please select a valid date';
  static const String startDateAfterEndDate =
      'Start date cannot be after end date';

  // Success Messages
  static const String loginSuccessful = 'Login successful';
  static const String registrationSuccessful = 'Registration successful';
  static const String propertySaved = 'Property saved successfully';
  static const String tenantSaved = 'Tenant saved successfully';
  static const String leaseSaved = 'Lease saved successfully';
  static const String paymentRecorded = 'Payment recorded successfully';
  static const String dataUpdated = 'Data updated successfully';
  static const String dataDeleted = 'Data deleted successfully';

  // Error Messages
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError = 'Please check your internet connection';
  static const String serverError = 'Server error. Please try again later.';
  static const String notFound = 'Data not found';
  static const String unauthorized =
      'You are not authorized to perform this action';
  static const String validationError = 'Please check the entered information';

  // Dialogs
  static const String confirmDelete = 'Confirm Delete';
  static const String deleteMessage =
      'Are you sure you want to delete this item?';
  static const String confirmLogout = 'Confirm Logout';
  static const String logoutMessage = 'Are you sure you want to logout?';
  static const String unsavedChanges = 'Unsaved Changes';
  static const String unsavedChangesMessage =
      'You have unsaved changes. Do you want to save them?';

  // Navigation
  static const String home = 'Home';
  static const String back = 'Back';
  static const String next = 'Next';
  static const String previous = 'Previous';
  static const String finish = 'Finish';
  static const String skip = 'Skip';

  // File Operations
  static const String selectImage = 'Select Image';
  static const String takePhoto = 'Take Photo';
  static const String chooseFromGallery = 'Choose from Gallery';
  static const String uploadDocument = 'Upload Document';
  static const String removeImage = 'Remove Image';
  static const String viewDocument = 'View Document';

  // Maintenance
  static const String maintenanceRequest = 'Maintenance Request';
  static const String createRequest = 'Create Request';
  static const String requestTitle = 'Title';
  static const String requestDescription = 'Description';
  static const String priority = 'Priority';
  static const String highPriority = 'High';
  static const String mediumPriority = 'Medium';
  static const String lowPriority = 'Low';
  static const String requestStatus = 'Status';
  static const String openStatus = 'Open';
  static const String inProgressStatus = 'In Progress';
  static const String completedStatus = 'Completed';
  static const String estimatedCost = 'Estimated Cost';
}
