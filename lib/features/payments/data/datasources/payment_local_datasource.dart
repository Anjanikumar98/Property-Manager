// lib/features/payments/data/datasources/payment_local_datasource.dart
import 'package:sqflite/sqflite.dart';
import '../../../../core/services/database_service.dart';
import '../../domain/entities/payment.dart';
import '../models/payment_model.dart';

abstract class PaymentLocalDatasource {
  Future<List<PaymentModel>> getPayments({
    String? leaseId,
    String? tenantId,
    String? propertyId,
    PaymentStatus? status,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<PaymentModel> getPaymentById(String id);
  Future<PaymentModel> insertPayment(Payment payment);
  Future<PaymentModel> updatePayment(Payment payment);
  Future<void> deletePayment(String id);
  Future<List<PaymentModel>> getOverduePayments({
    String? tenantId,
    String? propertyId,
  });
  Future<Map<String, double>> getPaymentSummary({
    String? leaseId,
    String? tenantId,
    String? propertyId,
    DateTime? startDate,
    DateTime? endDate,
  });
}

class PaymentLocalDatasourceImpl implements PaymentLocalDatasource {
  final DatabaseService databaseService;

  PaymentLocalDatasourceImpl({required this.databaseService});

  @override
  Future<List<PaymentModel>> getPayments({
    String? leaseId,
    String? tenantId,
    String? propertyId,
    PaymentStatus? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await DatabaseService.database;

    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (leaseId != null) {
      whereClause += 'leaseId = ?';
      whereArgs.add(leaseId);
    }

    if (tenantId != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'tenantId = ?';
      whereArgs.add(tenantId);
    }

    if (propertyId != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'propertyId = ?';
      whereArgs.add(propertyId);
    }

    if (status != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'status = ?';
      whereArgs.add(status.name);
    }

    if (startDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'dueDate >= ?';
      whereArgs.add(startDate.toIso8601String());
    }

    if (endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'dueDate <= ?';
      whereArgs.add(endDate.toIso8601String());
    }

    final List<Map<String, dynamic>> maps = await db.query(
      PaymentModel.tableName,
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: 'dueDate DESC',
    );

    return List.generate(maps.length, (i) => PaymentModel.fromMap(maps[i]));
  }

  @override
  Future<PaymentModel> getPaymentById(String id) async {
    final db = await DatabaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      PaymentModel.tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PaymentModel.fromMap(maps.first);
    } else {
      throw Exception('Payment with id $id not found');
    }
  }

  @override
  Future<PaymentModel> insertPayment(Payment payment) async {
    final db = await DatabaseService.database;
    final paymentModel = PaymentModel.fromEntity(payment);

    await db.insert(
      PaymentModel.tableName,
      paymentModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return paymentModel;
  }

  @override
  Future<PaymentModel> updatePayment(Payment payment) async {
    final db = await DatabaseService.database;
    final paymentModel = PaymentModel.fromEntity(payment);

    await db.update(
      PaymentModel.tableName,
      paymentModel.toMap(),
      where: 'id = ?',
      whereArgs: [payment.id],
    );

    return paymentModel;
  }

  @override
  Future<void> deletePayment(String id) async {
    final db = await DatabaseService.database;
    await db.delete(PaymentModel.tableName, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<PaymentModel>> getOverduePayments({
    String? tenantId,
    String? propertyId,
  }) async {
    final db = await DatabaseService.database;
    final now = DateTime.now().toIso8601String();

    String whereClause = 'dueDate < ? AND status != ?';
    List<dynamic> whereArgs = [now, PaymentStatus.completed.name];

    if (tenantId != null) {
      whereClause += ' AND tenantId = ?';
      whereArgs.add(tenantId);
    }

    if (propertyId != null) {
      whereClause += ' AND propertyId = ?';
      whereArgs.add(propertyId);
    }

    final List<Map<String, dynamic>> maps = await db.query(
      PaymentModel.tableName,
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'dueDate ASC',
    );

    return List.generate(maps.length, (i) => PaymentModel.fromMap(maps[i]));
  }

  @override
  Future<Map<String, double>> getPaymentSummary({
    String? leaseId,
    String? tenantId,
    String? propertyId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await DatabaseService.database;

    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (leaseId != null) {
      whereClause += 'leaseId = ?';
      whereArgs.add(leaseId);
    }

    if (tenantId != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'tenantId = ?';
      whereArgs.add(tenantId);
    }

    if (propertyId != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'propertyId = ?';
      whereArgs.add(propertyId);
    }

    if (startDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'dueDate >= ?';
      whereArgs.add(startDate.toIso8601String());
    }

    if (endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'dueDate <= ?';
      whereArgs.add(endDate.toIso8601String());
    }

    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT 
        SUM(amount + lateFee) as totalDue,
        SUM(paidAmount) as totalPaid,
        SUM(CASE WHEN status = 'overdue' THEN (amount + lateFee - paidAmount) ELSE 0 END) as totalOverdue,
        COUNT(CASE WHEN status = 'overdue' THEN 1 END) as overdueCount,
        COUNT(*) as totalPayments
      FROM ${PaymentModel.tableName}
      ${whereClause.isEmpty ? '' : 'WHERE $whereClause'}
      ''', whereArgs.isEmpty ? null : whereArgs);

    if (result.isNotEmpty && result.first.isNotEmpty) {
      final data = result.first;
      return {
        'totalDue': (data['totalDue'] ?? 0.0).toDouble(),
        'totalPaid': (data['totalPaid'] ?? 0.0).toDouble(),
        'totalOverdue': (data['totalOverdue'] ?? 0.0).toDouble(),
        'overdueCount': (data['overdueCount'] ?? 0.0).toDouble(),
        'totalPayments': (data['totalPayments'] ?? 0.0).toDouble(),
      };
    }

    return {
      'totalDue': 0.0,
      'totalPaid': 0.0,
      'totalOverdue': 0.0,
      'overdueCount': 0.0,
      'totalPayments': 0.0,
    };
  }
}

