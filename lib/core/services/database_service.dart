// lib/core/services/database_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/database_constants.dart';
import '../../features/leases/data/models/lease_model.dart';
import '../../features/leases/domain/entities/lease.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static Database? _database;
  static const String _databaseName = 'property_master.db';
  static const int _databaseVersion = 1;

  DatabaseService._internal();

  factory DatabaseService() {
    _instance ??= DatabaseService._internal();
    return _instance!;
  }

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.usersTable} (
        ${DatabaseConstants.userId} TEXT PRIMARY KEY,
        ${DatabaseConstants.userEmail} TEXT UNIQUE NOT NULL,
        ${DatabaseConstants.userPassword} TEXT NOT NULL,
        ${DatabaseConstants.userFirstName} TEXT NOT NULL,
        ${DatabaseConstants.userLastName} TEXT NOT NULL,
        ${DatabaseConstants.userPhone} TEXT,
        ${DatabaseConstants.userCreatedAt} TEXT NOT NULL,
        ${DatabaseConstants.userUpdatedAt} TEXT
      )
    ''');

    // Create properties table
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.propertiesTable} (
        ${DatabaseConstants.propertyId} TEXT PRIMARY KEY,
        ${DatabaseConstants.propertyName} TEXT NOT NULL,
        ${DatabaseConstants.propertyAddress} TEXT NOT NULL,
        ${DatabaseConstants.propertyCity} TEXT NOT NULL,
        ${DatabaseConstants.propertyState} TEXT NOT NULL,
        ${DatabaseConstants.propertyZipCode} TEXT NOT NULL,
        ${DatabaseConstants.propertyType} INTEGER NOT NULL,
        ${DatabaseConstants.propertyBedrooms} INTEGER NOT NULL,
        ${DatabaseConstants.propertyBathrooms} INTEGER NOT NULL,
        ${DatabaseConstants.propertySquareFeet} REAL NOT NULL,
        ${DatabaseConstants.propertyMonthlyRent} REAL NOT NULL,
        ${DatabaseConstants.propertySecurityDeposit} REAL NOT NULL,
        ${DatabaseConstants.propertyAmenities} TEXT,
        ${DatabaseConstants.propertyDescription} TEXT,
        ${DatabaseConstants.propertyImageUrls} TEXT,
        ${DatabaseConstants.propertyCreatedAt} TEXT NOT NULL,
        ${DatabaseConstants.propertyUpdatedAt} TEXT,
        ${DatabaseConstants.propertyStatus} INTEGER NOT NULL,
        ${DatabaseConstants.propertyOwnerId} TEXT NOT NULL,
        FOREIGN KEY (${DatabaseConstants.propertyOwnerId}) 
          REFERENCES ${DatabaseConstants.usersTable} (${DatabaseConstants.userId})
          ON DELETE CASCADE
      )
    ''');

    // Create tenants table
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tenantsTable} (
        ${DatabaseConstants.tenantId} TEXT PRIMARY KEY,
        ${DatabaseConstants.tenantFirstName} TEXT NOT NULL,
        ${DatabaseConstants.tenantLastName} TEXT NOT NULL,
        ${DatabaseConstants.tenantEmail} TEXT,
        ${DatabaseConstants.tenantPhone} TEXT NOT NULL,
        ${DatabaseConstants.tenantEmergencyContact} TEXT,
        ${DatabaseConstants.tenantEmergencyPhone} TEXT,
        ${DatabaseConstants.tenantCreatedAt} TEXT NOT NULL,
        ${DatabaseConstants.tenantUpdatedAt} TEXT,
        ${DatabaseConstants.tenantOwnerId} TEXT NOT NULL,
        FOREIGN KEY (${DatabaseConstants.tenantOwnerId}) 
          REFERENCES ${DatabaseConstants.usersTable} (${DatabaseConstants.userId})
          ON DELETE CASCADE
      )
    ''');

    // Create leases table
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.leasesTable} (
        ${DatabaseConstants.leaseId} TEXT PRIMARY KEY,
        ${DatabaseConstants.leasePropertyId} TEXT NOT NULL,
        ${DatabaseConstants.leaseTenantId} TEXT NOT NULL,
        ${DatabaseConstants.leaseStartDate} TEXT NOT NULL,
        ${DatabaseConstants.leaseEndDate} TEXT NOT NULL,
        ${DatabaseConstants.leaseMonthlyRent} REAL NOT NULL,
        ${DatabaseConstants.leaseSecurityDeposit} REAL NOT NULL,
        ${DatabaseConstants.leaseStatus} INTEGER NOT NULL,
        ${DatabaseConstants.leaseTerms} TEXT,
        ${DatabaseConstants.leaseCreatedAt} TEXT NOT NULL,
        ${DatabaseConstants.leaseUpdatedAt} TEXT,
        ${DatabaseConstants.leaseOwnerId} TEXT NOT NULL,
        FOREIGN KEY (${DatabaseConstants.leasePropertyId}) 
          REFERENCES ${DatabaseConstants.propertiesTable} (${DatabaseConstants.propertyId})
          ON DELETE CASCADE,
        FOREIGN KEY (${DatabaseConstants.leaseTenantId}) 
          REFERENCES ${DatabaseConstants.tenantsTable} (${DatabaseConstants.tenantId})
          ON DELETE CASCADE,
        FOREIGN KEY (${DatabaseConstants.leaseOwnerId}) 
          REFERENCES ${DatabaseConstants.usersTable} (${DatabaseConstants.userId})
          ON DELETE CASCADE
      )
    ''');

    // Create payments table
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.paymentsTable} (
        ${DatabaseConstants.paymentId} TEXT PRIMARY KEY,
        ${DatabaseConstants.paymentLeaseId} TEXT NOT NULL,
        ${DatabaseConstants.paymentAmount} REAL NOT NULL,
        ${DatabaseConstants.paymentDate} TEXT NOT NULL,
        ${DatabaseConstants.paymentDueDate} TEXT NOT NULL,
        ${DatabaseConstants.paymentType} INTEGER NOT NULL,
        ${DatabaseConstants.paymentStatus} INTEGER NOT NULL,
        ${DatabaseConstants.paymentMethod} TEXT,
        ${DatabaseConstants.paymentNotes} TEXT,
        ${DatabaseConstants.paymentCreatedAt} TEXT NOT NULL,
        ${DatabaseConstants.paymentUpdatedAt} TEXT,
        ${DatabaseConstants.paymentOwnerId} TEXT NOT NULL,
        FOREIGN KEY (${DatabaseConstants.paymentLeaseId}) 
          REFERENCES ${DatabaseConstants.leasesTable} (${DatabaseConstants.leaseId})
          ON DELETE CASCADE,
        FOREIGN KEY (${DatabaseConstants.paymentOwnerId}) 
          REFERENCES ${DatabaseConstants.usersTable} (${DatabaseConstants.userId})
          ON DELETE CASCADE
      )
    ''');

    // Create indexes for better performance
    await db.execute('''
      CREATE INDEX idx_properties_owner_id 
      ON ${DatabaseConstants.propertiesTable} (${DatabaseConstants.propertyOwnerId})
    ''');

    await db.execute('''
      CREATE INDEX idx_properties_status 
      ON ${DatabaseConstants.propertiesTable} (${DatabaseConstants.propertyStatus})
    ''');

    await db.execute('''
      CREATE INDEX idx_tenants_owner_id 
      ON ${DatabaseConstants.tenantsTable} (${DatabaseConstants.tenantOwnerId})
    ''');

    await db.execute('''
      CREATE INDEX idx_leases_property_id 
      ON ${DatabaseConstants.leasesTable} (${DatabaseConstants.leasePropertyId})
    ''');

    await db.execute('''
      CREATE INDEX idx_leases_tenant_id 
      ON ${DatabaseConstants.leasesTable} (${DatabaseConstants.leaseTenantId})
    ''');

    await db.execute('''
      CREATE INDEX idx_leases_owner_id 
      ON ${DatabaseConstants.leasesTable} (${DatabaseConstants.leaseOwnerId})
    ''');

    await db.execute('''
      CREATE INDEX idx_payments_lease_id 
      ON ${DatabaseConstants.paymentsTable} (${DatabaseConstants.paymentLeaseId})
    ''');

    await db.execute('''
      CREATE INDEX idx_payments_owner_id 
      ON ${DatabaseConstants.paymentsTable} (${DatabaseConstants.paymentOwnerId})
    ''');

    await db.execute('''
      CREATE INDEX idx_payments_due_date 
      ON ${DatabaseConstants.paymentsTable} (${DatabaseConstants.paymentDueDate})
    ''');
  }

  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // Handle database upgrades here
    if (oldVersion < 2) {
      // Add new columns or tables for version 2
    }
  }

  // Lease-related methods
  Future<List<Lease>> getLeases() async {
    final db = await database;
    final maps = await db.query(DatabaseConstants.leasesTable);
    return maps.map((map) => LeaseModel.fromMap(map).toEntity()).toList();
  }

  Future<Lease?> getLeaseById(String id) async {
    final db = await database;
    final maps = await db.query(
      DatabaseConstants.leasesTable,
      where: '${DatabaseConstants.leaseId} = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return LeaseModel.fromMap(maps.first).toEntity();
  }

  Future<List<Lease>> getLeasesByProperty(String propertyId) async {
    final db = await database;
    final maps = await db.query(
      DatabaseConstants.leasesTable,
      where: '${DatabaseConstants.leasePropertyId} = ?',
      whereArgs: [propertyId],
    );
    return maps.map((map) => LeaseModel.fromMap(map).toEntity()).toList();
  }

  Future<List<Lease>> getLeasesByTenant(String tenantId) async {
    final db = await database;
    final maps = await db.query(
      DatabaseConstants.leasesTable,
      where: '${DatabaseConstants.leaseTenantId} = ?',
      whereArgs: [tenantId],
    );
    return maps.map((map) => LeaseModel.fromMap(map).toEntity()).toList();
  }

  Future<List<Lease>> getActiveLeases() async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    final maps = await db.query(
      DatabaseConstants.leasesTable,
      where:
          '${DatabaseConstants.leaseStatus} = ? AND ${DatabaseConstants.leaseEndDate} > ?',
      whereArgs: [LeaseStatus.active.index, now],
    );
    return maps.map((map) => LeaseModel.fromMap(map).toEntity()).toList();
  }

  Future<List<Lease>> getExpiringLeases() async {
    final db = await database;
    final now = DateTime.now();
    final thirtyDaysFromNow =
        now.add(const Duration(days: 30)).toIso8601String();
    final maps = await db.query(
      DatabaseConstants.leasesTable,
      where:
          '${DatabaseConstants.leaseEndDate} <= ? AND ${DatabaseConstants.leaseStatus} = ?',
      whereArgs: [thirtyDaysFromNow, LeaseStatus.active.index],
    );
    return maps.map((map) => LeaseModel.fromMap(map).toEntity()).toList();
  }

  Future<Lease> insertLease(LeaseModel lease) async {
    final db = await database;
    await db.insert(
      DatabaseConstants.leasesTable,
      lease.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return lease.toEntity();
  }

  Future<Lease> updateLease(LeaseModel lease) async {
    final db = await database;
    await db.update(
      DatabaseConstants.leasesTable,
      lease.toMap(),
      where: '${DatabaseConstants.leaseId} = ?',
      whereArgs: [lease.id],
    );
    return lease.toEntity();
  }

  Future<void> deleteLease(String id) async {
    final db = await database;
    await db.delete(
      DatabaseConstants.leasesTable,
      where: '${DatabaseConstants.leaseId} = ?',
      whereArgs: [id],
    );
  }

  static Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  static Future<void> deleteDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
