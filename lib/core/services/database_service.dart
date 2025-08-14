import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/database_constants.dart';
import 'package:property_manager/core/errors/exceptions.dart' as app_errors;

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    try {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, DatabaseConstants.databaseName);

      return await openDatabase(
        path,
        version: DatabaseConstants.databaseVersion,
        onCreate: _createTables,
        onUpgrade: _upgradeDatabase,
      );
    } catch (e) {
      throw app_errors.DatabaseException('Failed to insert data: $e');
    }
  }

  Future<void> _createTables(Database db, int version) async {
    final batch = db.batch();

    // Create all tables
    batch.execute(DatabaseConstants.createUsersTable);
    batch.execute(DatabaseConstants.createPropertiesTable);
    batch.execute(DatabaseConstants.createTenantsTable);
    batch.execute(DatabaseConstants.createLeasesTable);
    batch.execute(DatabaseConstants.createPaymentsTable);
    batch.execute(DatabaseConstants.createMaintenanceTable);
    batch.execute(DatabaseConstants.createNotificationsTable);
    batch.execute(DatabaseConstants.createDocumentsTable);

    // Create indexes for better performance
    batch.execute(_createIndexes());

    await batch.commit();
  }

  String _createIndexes() {
    return '''
      CREATE INDEX idx_properties_owner ON ${DatabaseConstants.propertiesTable}(${DatabaseConstants.propertyOwnerIdColumn});
      CREATE INDEX idx_leases_property ON ${DatabaseConstants.leasesTable}(${DatabaseConstants.leasePropertyIdColumn});
      CREATE INDEX idx_leases_tenant ON ${DatabaseConstants.leasesTable}(${DatabaseConstants.leaseTenantIdColumn});
      CREATE INDEX idx_payments_lease ON ${DatabaseConstants.paymentsTable}(${DatabaseConstants.paymentLeaseIdColumn});
      CREATE INDEX idx_payments_date ON ${DatabaseConstants.paymentsTable}(${DatabaseConstants.paymentDateColumn});
      CREATE INDEX idx_maintenance_property ON ${DatabaseConstants.maintenanceTable}(${DatabaseConstants.maintenancePropertyIdColumn});
      CREATE INDEX idx_documents_entity ON ${DatabaseConstants.documentsTable}(${DatabaseConstants.documentEntityTypeColumn}, ${DatabaseConstants.documentEntityIdColumn});
    ''';
  }

  Future<void> _upgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // Handle database upgrades here
    if (oldVersion < 2) {
      // Add upgrade logic for version 2
    }
  }

  // Generic CRUD Operations
  Future<int> insert(String table, Map<String, dynamic> data) async {
    try {
      final db = await database;
      return await db.insert(
        table,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw app_errors.DatabaseException('Failed to insert data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    try {
      final db = await database;
      return await db.query(
        table,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );
    } catch (e) {
      throw app_errors.DatabaseException('Failed to query data: $e');
    }
  }

  Future<Map<String, dynamic>?> queryById(
    String table,
    String id, [
    String idColumn = 'id',
  ]) async {
    try {
      final results = await query(
        table,
        where: '$idColumn = ?',
        whereArgs: [id],
        limit: 1,
      );
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw app_errors.DatabaseException('Failed to query by ID: $e');
    }
  }

  Future<int> update(
    String table,
    Map<String, dynamic> data,
    String where,
    List<dynamic> whereArgs,
  ) async {
    try {
      final db = await database;
      return await db.update(table, data, where: where, whereArgs: whereArgs);
    } catch (e) {
      throw app_errors.DatabaseException('Failed to update data: $e');
    }
  }

  Future<int> updateById(
    String table,
    String id,
    Map<String, dynamic> data, [
    String idColumn = 'id',
  ]) async {
    try {
      return await update(table, data, '$idColumn = ?', [id]);
    } catch (e) {
      throw app_errors.DatabaseException('Failed to update by ID: $e');
    }
  }

  Future<int> delete(
    String table,
    String where,
    List<dynamic> whereArgs,
  ) async {
    try {
      final db = await database;
      return await db.delete(table, where: where, whereArgs: whereArgs);
    } catch (e) {
      throw app_errors.DatabaseException('Failed to delete data: $e');
    }
  }

  Future<int> deleteById(
    String table,
    String id, [
    String idColumn = 'id',
  ]) async {
    try {
      return await delete(table, '$idColumn = ?', [id]);
    } catch (e) {
      throw app_errors.DatabaseException('Failed to delete by ID: $e');
    }
  }

  Future<int> count(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    try {
      final db = await database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $table${where != null ? ' WHERE $where' : ''}',
        whereArgs,
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw app_errors.DatabaseException('Failed to count records: $e');
    }
  }

  Future<bool> exists(
    String table,
    String where,
    List<dynamic> whereArgs,
  ) async {
    try {
      final count = await this.count(table, where: where, whereArgs: whereArgs);
      return count > 0;
    } catch (e) {
      throw app_errors.DatabaseException('Failed to check existence: $e');
    }
  }

  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<dynamic>? arguments,
  ]) async {
    try {
      final db = await database;
      return await db.rawQuery(sql, arguments);
    } catch (e) {
      throw app_errors.DatabaseException('Failed to execute raw query: $e');
    }
  }

  Future<void> transaction(
    Future<void> Function(Transaction txn) action,
  ) async {
    try {
      final db = await database;
      await db.transaction(action);
    } catch (e) {
      throw app_errors.DatabaseException('Transaction failed: $e');
    }
  }

  Future<void> clearAllTables() async {
    try {
      final db = await database;
      final batch = db.batch();

      // Clear all tables in correct order (considering foreign keys)
      batch.delete(DatabaseConstants.documentsTable);
      batch.delete(DatabaseConstants.notificationsTable);
      batch.delete(DatabaseConstants.maintenanceTable);
      batch.delete(DatabaseConstants.paymentsTable);
      batch.delete(DatabaseConstants.leasesTable);
      batch.delete(DatabaseConstants.tenantsTable);
      batch.delete(DatabaseConstants.propertiesTable);
      batch.delete(DatabaseConstants.usersTable);

      await batch.commit();
    } catch (e) {
      throw app_errors.DatabaseException('Failed to clear tables: $e');
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
