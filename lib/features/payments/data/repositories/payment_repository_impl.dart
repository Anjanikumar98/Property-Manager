// // lib/features/payments/data/repositories/payment_repository_impl.dart
// import 'package:property_manager/features/payments/data/models/payment_model.dart';
// import 'package:property_manager/features/payments/domain/entities/payment.dart';
// import '../../domain/repositories/payment_repository.dart';
// import '../../../../core/services/database_service.dart';
//
// class PaymentRepositoryImpl implements PaymentRepository {
//   // final DatabaseService _databaseService = DatabaseService.instance;
//
//   @override
//   Future<List<Payment>> getPayments() async {
//     final db = await DatabaseService.database;
//     final maps = await db.query('payments', orderBy: 'payment_date DESC');
//
//     return maps.map((map) => PaymentModel.fromJson(map)).toList();
//   }
//
//   @override
//   Future<Payment?> getPaymentById(String id) async {
//     final db = await DatabaseService.database;
//     final maps = await db.query('payments', where: 'id = ?', whereArgs: [id]);
//
//     if (maps.isNotEmpty) {
//       return PaymentModel.fromJson(maps.first);
//     }
//     return null;
//   }
//
//   @override
//   Future<List<Payment>> getPaymentsByLeaseId(String leaseId) async {
//     final db = await DatabaseService.database;
//     final maps = await db.query(
//       'payments',
//       where: 'lease_id = ?',
//       whereArgs: [leaseId],
//       orderBy: 'payment_date DESC',
//     );
//
//     return maps.map((map) => PaymentModel.fromJson(map)).toList();
//   }
//
//   @override
//   Future<List<Payment>> getPaymentsByPropertyId(String propertyId) async {
//     final db = await DatabaseService.database;
//     final maps = await db.query(
//       'payments',
//       where: 'property_id = ?',
//       whereArgs: [propertyId],
//       orderBy: 'payment_date DESC',
//     );
//
//     return maps.map((map) => PaymentModel.fromJson(map)).toList();
//   }
//
//   @override
//   Future<List<Payment>> getPaymentsByTenantId(String tenantId) async {
//     final db = await DatabaseService.database;
//     final maps = await db.query(
//       'payments',
//       where: 'tenant_id = ?',
//       whereArgs: [tenantId],
//       orderBy: 'payment_date DESC',
//     );
//
//     return maps.map((map) => PaymentModel.fromJson(map)).toList();
//   }
//
//   @override
//   Future<List<Payment>> getPaymentsByStatus(String status) async {
//     final db = await DatabaseService.database;
//     final maps = await db.query(
//       'payments',
//       where: 'status = ?',
//       whereArgs: [status],
//       orderBy: 'payment_date DESC',
//     );
//
//     return maps.map((map) => PaymentModel.fromJson(map)).toList();
//   }
//
//   @override
//   Future<List<Payment>> getPaymentsByDateRange(
//     DateTime startDate,
//     DateTime endDate,
//   ) async {
//     final db = await DatabaseService.database;
//     final maps = await db.query(
//       'payments',
//       where: 'payment_date BETWEEN ? AND ?',
//       whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
//       orderBy: 'payment_date DESC',
//     );
//
//     return maps.map((map) => PaymentModel.fromJson(map)).toList();
//   }
//
//   @override
//   Future<List<Payment>> getOverduePayments() async {
//     final db = await DatabaseService.database;
//     final now = DateTime.now().toIso8601String();
//     final maps = await db.query(
//       'payments',
//       where: '(status = ? OR status = ?) AND due_date < ?',
//       whereArgs: ['pending', 'partial', now],
//       orderBy: 'due_date ASC',
//     );
//
//     return maps.map((map) => PaymentModel.fromJson(map)).toList();
//   }
//
//   @override
//   Future<String> recordPayment(Payment payment) async {
//     final db = await DatabaseService.database;
//     final paymentModel = PaymentModel.fromEntity(payment);
//
//     await db.insert('payments', paymentModel.toJson());
//     return payment.id;
//   }
//
//   @override
//   Future<void> updatePayment(Payment payment) async {
//     final db = await DatabaseService.database;
//     final paymentModel = PaymentModel.fromEntity(payment);
//
//     await db.update(
//       'payments',
//       paymentModel.toJson(),
//       where: 'id = ?',
//       whereArgs: [payment.id],
//     );
//   }
//
//   @override
//   Future<void> deletePayment(String id) async {
//     final db = await DatabaseService.database;
//     await db.delete('payments', where: 'id = ?', whereArgs: [id]);
//   }
//
//   @override
//   Future<double> getTotalRevenue() async {
//     final db = await DatabaseService.database;
//     final result = await db.rawQuery(
//       'SELECT SUM(amount) as total FROM payments WHERE status = ?',
//       ['paid'],
//     );
//
//     return (result.first['total'] as num?)?.toDouble() ?? 0.0;
//   }
//
//   @override
//   Future<double> getMonthlyRevenue(DateTime month) async {
//     final db = await DatabaseService.database;
//     final startOfMonth = DateTime(month.year, month.month, 1);
//     final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
//
//     final result = await db.rawQuery(
//       '''
//       SELECT SUM(amount) as total
//       FROM payments
//       WHERE status = ? AND payment_date BETWEEN ? AND ?
//       ''',
//       ['paid', startOfMonth.toIso8601String(), endOfMonth.toIso8601String()],
//     );
//
//     return (result.first['total'] as num?)?.toDouble() ?? 0.0;
//   }
// }
