// lib/features/tenants/data/datasources/tenant_local_datasource.dart
import 'package:property_manager/core/errors/failures.dart';
import 'package:property_manager/features/tenants/data/models/tenant_model.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/database_service.dart';

abstract class TenantLocalDatasource {
  Future<List<TenantModel>> getTenants();
  Future<TenantModel> getTenantById(String id);
  Future<List<TenantModel>> getTenantsByProperty(String propertyId);
  Future<List<TenantModel>> searchTenants(String query);
  Future<TenantModel> addTenant(TenantModel tenant);
  Future<TenantModel> updateTenant(TenantModel tenant);
  Future<void> deleteTenant(String id);
  Future<void> deactivateTenant(String id);
  Future<void> activateTenant(String id);
}

class TenantLocalDatasourceImpl implements TenantLocalDatasource {
  final DatabaseService databaseService;
  static const String _tableName = 'tenants';

  TenantLocalDatasourceImpl({required this.databaseService});

  @override
  Future<List<TenantModel>> getTenants() async {
    try {
      final db = await DatabaseService.database;
      final maps = await db.query(
        _tableName,
        orderBy: 'firstName ASC, lastName ASC',
      );
      return maps.map((map) => TenantModel.fromJson(map)).toList();
    } catch (e) {
      throw CacheException('Failed to fetch tenants: $e');
    }
  }

  @override
  Future<TenantModel> getTenantById(String id) async {
    try {
      final db = await DatabaseService.database;
      final maps = await db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isEmpty) {
        throw CacheException('Tenant with id $id not found');
      }

      return TenantModel.fromJson(maps.first);
    } catch (e) {
      throw CacheException('Failed to fetch tenant: $e');
    }
  }

  @override
  Future<List<TenantModel>> getTenantsByProperty(String propertyId) async {
    try {
      final db = await DatabaseService.database;
      final maps = await db.query(
        _tableName,
        where: 'propertyIds LIKE ?',
        whereArgs: ['%$propertyId%'],
        orderBy: 'firstName ASC, lastName ASC',
      );
      return maps.map((map) => TenantModel.fromJson(map)).toList();
    } catch (e) {
      throw CacheException('Failed to fetch tenants by property: $e');
    }
  }

  @override
  Future<List<TenantModel>> searchTenants(String query) async {
    try {
      final db = await DatabaseService.database;
      final lowerQuery = query.toLowerCase();
      final maps = await db.query(
        _tableName,
        where: '''
          LOWER(firstName) LIKE ? OR 
          LOWER(lastName) LIKE ? OR 
          LOWER(email) LIKE ? OR 
          phone LIKE ?
        ''',
        whereArgs: [
          '%$lowerQuery%',
          '%$lowerQuery%',
          '%$lowerQuery%',
          '%$query%',
        ],
        orderBy: 'firstName ASC, lastName ASC',
      );
      return maps.map((map) => TenantModel.fromJson(map)).toList();
    } catch (e) {
      throw CacheException('Failed to search tenants: $e');
    }
  }

  @override
  Future<TenantModel> addTenant(TenantModel tenant) async {
    try {
      final db = await DatabaseService.database;
      final tenantData = tenant.toJson();
      tenantData.remove('id'); // Remove ID for auto-increment

      final id = await db.insert(_tableName, tenantData);
      return tenant.copyWith(id: id.toString());
    } catch (e) {
      throw CacheException('Failed to add tenant: $e');
    }
  }

  @override
  Future<TenantModel> updateTenant(TenantModel tenant) async {
    try {
      final db = await DatabaseService.database;
      final updatedTenant = tenant.copyWith(updatedAt: DateTime.now());

      await db.update(
        _tableName,
        updatedTenant.toJson(),
        where: 'id = ?',
        whereArgs: [tenant.id],
      );

      return updatedTenant;
    } catch (e) {
      throw CacheException('Failed to update tenant: $e');
    }
  }

  @override
  Future<void> deleteTenant(String id) async {
    try {
      final db = await DatabaseService.database;
      await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw CacheException('Failed to delete tenant: $e');
    }
  }

  @override
  Future<void> deactivateTenant(String id) async {
    try {
      final db = await DatabaseService.database;
      await db.update(
        _tableName,
        {'isActive': 0, 'updatedAt': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw CacheException('Failed to deactivate tenant: $e');
    }
  }

  @override
  Future<void> activateTenant(String id) async {
    try {
      final db = await DatabaseService.database;
      await db.update(
        _tableName,
        {'isActive': 1, 'updatedAt': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw CacheException('Failed to activate tenant: $e');
    }
  }
}
