class DatabaseConstants {
  static const String databaseName = 'property_master.db';
  static const int databaseVersion = 1;

  // Users table columns
  static const String userId = 'id';
  static const String userEmail = 'email';
  static const String userPassword = 'password';
  static const String userFirstName = 'first_name';
  static const String userLastName = 'last_name';
  static const String userPhone = 'phone';
  static const String userCreatedAt = 'created_at';
  static const String userUpdatedAt = 'updated_at';

  // Properties table columns
  static const String propertyId = 'id';
  static const String propertyName = 'name';
  static const String propertyAddress = 'address';
  static const String propertyCity = 'city';
  static const String propertyState = 'state';
  static const String propertyZipCode = 'zip_code';
  static const String propertyType = 'type';
  static const String propertyBedrooms = 'bedrooms';
  static const String propertyBathrooms = 'bathrooms';
  static const String propertySquareFeet = 'square_feet';
  static const String propertyMonthlyRent = 'monthly_rent';
  static const String propertySecurityDeposit = 'security_deposit';
  static const String propertyAmenities = 'amenities';
  static const String propertyDescription = 'description';
  static const String propertyImageUrls = 'image_urls';
  static const String propertyCreatedAt = 'created_at';
  static const String propertyUpdatedAt = 'updated_at';
  static const String propertyStatus = 'status';
  static const String propertyOwnerId = 'owner_id';

  // Tenants table columns
  static const String tenantId = 'id';
  static const String tenantFirstName = 'first_name';
  static const String tenantLastName = 'last_name';
  static const String tenantEmail = 'email';
  static const String tenantPhone = 'phone';
  static const String tenantEmergencyContact = 'emergency_contact';
  static const String tenantEmergencyPhone = 'emergency_phone';
  static const String tenantCreatedAt = 'created_at';
  static const String tenantUpdatedAt = 'updated_at';
  static const String tenantOwnerId = 'owner_id';

  // Leases table columns
  static const String leaseId = 'id';
  static const String leasePropertyId = 'property_id';
  static const String leaseTenantId = 'tenant_id';
  static const String leaseStartDate = 'start_date';
  static const String leaseEndDate = 'end_date';
  static const String leaseMonthlyRent = 'monthly_rent';
  static const String leaseSecurityDeposit = 'security_deposit';
  static const String leaseStatus = 'status';
  static const String leaseTerms = 'terms';
  static const String leaseCreatedAt = 'created_at';
  static const String leaseUpdatedAt = 'updated_at';
  static const String leaseOwnerId = 'owner_id';

  // Payments table columns
  static const String paymentId = 'id';
  static const String paymentLeaseId = 'lease_id';
  static const String paymentAmount = 'amount';
  static const String paymentDate = 'payment_date';
  static const String paymentDueDate = 'due_date';
  static const String paymentType = 'type';
  static const String paymentStatus = 'status';
  static const String paymentMethod = 'payment_method';
  static const String paymentNotes = 'notes';
  static const String paymentCreatedAt = 'created_at';
  static const String paymentUpdatedAt = 'updated_at';
  static const String paymentOwnerId = 'owner_id';

  // Table Names
  static const String usersTable = 'users';
  static const String propertiesTable = 'properties';
  static const String tenantsTable = 'tenants';
  static const String leasesTable = 'leases';
  static const String paymentsTable = 'payments';
  static const String maintenanceTable = 'maintenance_requests';
  static const String notificationsTable = 'notifications';
  static const String documentsTable = 'documents';

  // Users Table
  static const String userIdColumn = 'id';
  static const String userNameColumn = 'name';
  static const String userEmailColumn = 'email';
  static const String userPhoneColumn = 'phone';
  static const String userPasswordColumn = 'password';
  static const String userCreatedAtColumn = 'created_at';
  static const String userUpdatedAtColumn = 'updated_at';

  // Properties Table
  static const String propertyIdColumn = 'id';
  static const String propertyNameColumn = 'name';
  static const String propertyAddressColumn = 'address';
  static const String propertyCityColumn = 'city';
  static const String propertyStateColumn = 'state';
  static const String propertyPinCodeColumn = 'pin_code';
  static const String propertyTypeColumn = 'type';
  static const String propertyBedroomsColumn = 'bedrooms';
  static const String propertyBathroomsColumn = 'bathrooms';
  static const String propertyAreaColumn = 'area';
  static const String propertyRentAmountColumn = 'rent_amount';
  static const String propertySecurityDepositColumn = 'security_deposit';
  static const String propertyDescriptionColumn = 'description';
  static const String propertyImagesColumn = 'images';
  static const String propertyIsAvailableColumn = 'is_available';
  static const String propertyOwnerIdColumn = 'owner_id';
  static const String propertyCreatedAtColumn = 'created_at';
  static const String propertyUpdatedAtColumn = 'updated_at';

  // Tenants Table
  static const String tenantIdColumn = 'id';
  static const String tenantNameColumn = 'name';
  static const String tenantEmailColumn = 'email';
  static const String tenantPhoneColumn = 'phone';
  static const String tenantDateOfBirthColumn = 'date_of_birth';
  static const String tenantOccupationColumn = 'occupation';
  static const String tenantEmergencyContactColumn = 'emergency_contact';
  static const String tenantDocumentsColumn = 'documents';
  static const String tenantCreatedAtColumn = 'created_at';
  static const String tenantUpdatedAtColumn = 'updated_at';

  // Leases Table
  static const String leaseIdColumn = 'id';
  static const String leasePropertyIdColumn = 'property_id';
  static const String leaseTenantIdColumn = 'tenant_id';
  static const String leaseStartDateColumn = 'start_date';
  static const String leaseEndDateColumn = 'end_date';
  static const String leaseRentAmountColumn = 'rent_amount';
  static const String leaseSecurityDepositColumn = 'security_deposit';
  static const String leaseRentDueDayColumn = 'rent_due_day';
  static const String leaseStatusColumn = 'status';
  static const String leaseTermsColumn = 'terms';
  static const String leaseCreatedAtColumn = 'created_at';
  static const String leaseUpdatedAtColumn = 'updated_at';

  // Payments Table
  static const String paymentIdColumn = 'id';
  static const String paymentLeaseIdColumn = 'lease_id';
  static const String paymentAmountColumn = 'amount';
  static const String paymentTypeColumn = 'type';
  static const String paymentDateColumn = 'payment_date';
  static const String paymentDueDateColumn = 'due_date';
  static const String paymentStatusColumn = 'status';
  static const String paymentMethodColumn = 'payment_method';
  static const String paymentNotesColumn = 'notes';
  static const String paymentReceiptColumn = 'receipt';
  static const String paymentCreatedAtColumn = 'created_at';
  static const String paymentUpdatedAtColumn = 'updated_at';

  // Maintenance Table
  static const String maintenanceIdColumn = 'id';
  static const String maintenancePropertyIdColumn = 'property_id';
  static const String maintenanceTenantIdColumn = 'tenant_id';
  static const String maintenanceTitleColumn = 'title';
  static const String maintenanceDescriptionColumn = 'description';
  static const String maintenancePriorityColumn = 'priority';
  static const String maintenanceStatusColumn = 'status';
  static const String maintenanceCostColumn = 'cost';
  static const String maintenanceImagesColumn = 'images';
  static const String maintenanceCreatedAtColumn = 'created_at';
  static const String maintenanceUpdatedAtColumn = 'updated_at';

  // Notifications Table
  static const String notificationIdColumn = 'id';
  static const String notificationTitleColumn = 'title';
  static const String notificationBodyColumn = 'body';
  static const String notificationTypeColumn = 'type';
  static const String notificationIsReadColumn = 'is_read';
  static const String notificationDataColumn = 'data';
  static const String notificationCreatedAtColumn = 'created_at';

  // Documents Table
  static const String documentIdColumn = 'id';
  static const String documentNameColumn = 'name';
  static const String documentPathColumn = 'path';
  static const String documentTypeColumn = 'type';
  static const String documentEntityTypeColumn = 'entity_type';
  static const String documentEntityIdColumn = 'entity_id';
  static const String documentCreatedAtColumn = 'created_at';

  // Create Table Queries
  static const String createUsersTable = '''
    CREATE TABLE $usersTable (
      $userIdColumn TEXT PRIMARY KEY,
      $userNameColumn TEXT NOT NULL,
      $userEmailColumn TEXT UNIQUE NOT NULL,
      $userPhoneColumn TEXT,
      $userPasswordColumn TEXT NOT NULL,
      $userCreatedAtColumn TEXT NOT NULL,
      $userUpdatedAtColumn TEXT NOT NULL
    )
  ''';

  static const String createPropertiesTable = '''
    CREATE TABLE $propertiesTable (
      $propertyIdColumn TEXT PRIMARY KEY,
      $propertyNameColumn TEXT NOT NULL,
      $propertyAddressColumn TEXT NOT NULL,
      $propertyCityColumn TEXT NOT NULL,
      $propertyStateColumn TEXT NOT NULL,
      $propertyPinCodeColumn TEXT NOT NULL,
      $propertyTypeColumn TEXT NOT NULL,
      $propertyBedroomsColumn INTEGER,
      $propertyBathroomsColumn INTEGER,
      $propertyAreaColumn REAL,
      $propertyRentAmountColumn REAL NOT NULL,
      $propertySecurityDepositColumn REAL,
      $propertyDescriptionColumn TEXT,
      $propertyImagesColumn TEXT,
      $propertyIsAvailableColumn INTEGER DEFAULT 1,
      $propertyOwnerIdColumn TEXT NOT NULL,
      $propertyCreatedAtColumn TEXT NOT NULL,
      $propertyUpdatedAtColumn TEXT NOT NULL,
      FOREIGN KEY ($propertyOwnerIdColumn) REFERENCES $usersTable ($userIdColumn)
    )
  ''';

  static const String createTenantsTable = '''
    CREATE TABLE $tenantsTable (
      $tenantIdColumn TEXT PRIMARY KEY,
      $tenantNameColumn TEXT NOT NULL,
      $tenantEmailColumn TEXT,
      $tenantPhoneColumn TEXT NOT NULL,
      $tenantDateOfBirthColumn TEXT,
      $tenantOccupationColumn TEXT,
      $tenantEmergencyContactColumn TEXT,
      $tenantDocumentsColumn TEXT,
      $tenantCreatedAtColumn TEXT NOT NULL,
      $tenantUpdatedAtColumn TEXT NOT NULL
    )
  ''';

  static const String createLeasesTable = '''
    CREATE TABLE $leasesTable (
      $leaseIdColumn TEXT PRIMARY KEY,
      $leasePropertyIdColumn TEXT NOT NULL,
      $leaseTenantIdColumn TEXT NOT NULL,
      $leaseStartDateColumn TEXT NOT NULL,
      $leaseEndDateColumn TEXT NOT NULL,
      $leaseRentAmountColumn REAL NOT NULL,
      $leaseSecurityDepositColumn REAL,
      $leaseRentDueDayColumn INTEGER DEFAULT 1,
      $leaseStatusColumn TEXT DEFAULT 'Pending',
      $leaseTermsColumn TEXT,
      $leaseCreatedAtColumn TEXT NOT NULL,
      $leaseUpdatedAtColumn TEXT NOT NULL,
      FOREIGN KEY ($leasePropertyIdColumn) REFERENCES $propertiesTable ($propertyIdColumn),
      FOREIGN KEY ($leaseTenantIdColumn) REFERENCES $tenantsTable ($tenantIdColumn)
    )
  ''';

  static const String createPaymentsTable = '''
    CREATE TABLE $paymentsTable (
      $paymentIdColumn TEXT PRIMARY KEY,
      $paymentLeaseIdColumn TEXT NOT NULL,
      $paymentAmountColumn REAL NOT NULL,
      $paymentTypeColumn TEXT NOT NULL,
      $paymentDateColumn TEXT,
      $paymentDueDateColumn TEXT NOT NULL,
      $paymentStatusColumn TEXT DEFAULT 'Pending',
      $paymentMethodColumn TEXT,
      $paymentNotesColumn TEXT,
      $paymentReceiptColumn TEXT,
      $paymentCreatedAtColumn TEXT NOT NULL,
      $paymentUpdatedAtColumn TEXT NOT NULL,
      FOREIGN KEY ($paymentLeaseIdColumn) REFERENCES $leasesTable ($leaseIdColumn)
    )
  ''';

  static const String createMaintenanceTable = '''
    CREATE TABLE $maintenanceTable (
      $maintenanceIdColumn TEXT PRIMARY KEY,
      $maintenancePropertyIdColumn TEXT NOT NULL,
      $maintenanceTenantIdColumn TEXT,
      $maintenanceTitleColumn TEXT NOT NULL,
      $maintenanceDescriptionColumn TEXT,
      $maintenancePriorityColumn TEXT DEFAULT 'Medium',
      $maintenanceStatusColumn TEXT DEFAULT 'Open',
      $maintenanceCostColumn REAL,
      $maintenanceImagesColumn TEXT,
      $maintenanceCreatedAtColumn TEXT NOT NULL,
      $maintenanceUpdatedAtColumn TEXT NOT NULL,
      FOREIGN KEY ($maintenancePropertyIdColumn) REFERENCES $propertiesTable ($propertyIdColumn),
      FOREIGN KEY ($maintenanceTenantIdColumn) REFERENCES $tenantsTable ($tenantIdColumn)
    )
  ''';

  static const String createNotificationsTable = '''
    CREATE TABLE $notificationsTable (
      $notificationIdColumn TEXT PRIMARY KEY,
      $notificationTitleColumn TEXT NOT NULL,
      $notificationBodyColumn TEXT NOT NULL,
      $notificationTypeColumn TEXT NOT NULL,
      $notificationIsReadColumn INTEGER DEFAULT 0,
      $notificationDataColumn TEXT,
      $notificationCreatedAtColumn TEXT NOT NULL
    )
  ''';

  static const String createDocumentsTable = '''
    CREATE TABLE $documentsTable (
      $documentIdColumn TEXT PRIMARY KEY,
      $documentNameColumn TEXT NOT NULL,
      $documentPathColumn TEXT NOT NULL,
      $documentTypeColumn TEXT NOT NULL,
      $documentEntityTypeColumn TEXT NOT NULL,
      $documentEntityIdColumn TEXT NOT NULL,
      $documentCreatedAtColumn TEXT NOT NULL
    )
  ''';
}
