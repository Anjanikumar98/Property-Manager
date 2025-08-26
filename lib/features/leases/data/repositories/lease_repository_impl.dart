import 'package:flutter/material.dart';
import 'package:property_manager/features/leases/data/models/lease_model.dart';
import 'package:property_manager/features/leases/domain/entities/lease.dart';
import 'package:property_manager/features/leases/domain/repositories/lease_repository.dart';
import '../../../../core/services/database_service.dart';

class LeaseRepositoryImpl implements LeaseRepository {
  //  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  Future<List<Lease>> getLeases() async {
    final db = await DatabaseService.database;
    final maps = await db.query('leases', orderBy: 'created_at DESC');

    return maps.map((map) => LeaseModel.fromJson(map)).toList();
  }

  @override
  Future<Lease?> getLeaseById(String id) async {
    final db = await DatabaseService.database;
    final maps = await db.query('leases', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return LeaseModel.fromJson(maps.first);
    }
    return null;
  }

  @override
  Future<List<Lease>> getLeasesByPropertyId(String propertyId) async {
    final db = await DatabaseService.database;
    final maps = await db.query(
      'leases',
      where: 'property_id = ?',
      whereArgs: [propertyId],
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => LeaseModel.fromJson(map)).toList();
  }

  @override
  Future<List<Lease>> getLeasesByTenantId(String tenantId) async {
    final db = await DatabaseService.database;
    final maps = await db.query(
      'leases',
      where: 'tenant_id = ?',
      whereArgs: [tenantId],
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => LeaseModel.fromJson(map)).toList();
  }

  @override
  Future<List<Lease>> getActiveLeases() async {
    final db = await DatabaseService.database;
    final maps = await db.query(
      'leases',
      where: 'status = ?',
      whereArgs: ['active'],
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => LeaseModel.fromJson(map)).toList();
  }

  @override
  Future<String> createLease(Lease lease) async {
    final db = await DatabaseService.database;
    final leaseModel = LeaseModel.fromEntity(lease);

    await db.insert('leases', leaseModel.toJson());
    return lease.id;
  }

  @override
  Future<void> updateLease(Lease lease) async {
    final db = await DatabaseService.database;
    final leaseModel = LeaseModel.fromEntity(lease);

    await db.update(
      'leases',
      leaseModel.toJson(),
      where: 'id = ?',
      whereArgs: [lease.id],
    );
  }

  @override
  Future<void> terminateLease(String id, DateTime terminationDate) async {
    final db = await DatabaseService.database;

    await db.update(
      'leases',
      {
        'status': 'terminated',
        'end_date': terminationDate.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> deleteLease(String id) async {
    final db = await DatabaseService.database;
    await db.delete('leases', where: 'id = ?', whereArgs: [id]);
  }
}

