// lib/features/payments/domain/repositories/payment_repository.dart
import 'package:property_manager/features/payments/domain/entities/payment.dart';

abstract class PaymentRepository {
  Future<List<Payment>> getPayments();
  Future<Payment?> getPaymentById(String id);
  Future<List<Payment>> getPaymentsByLeaseId(String leaseId);
  Future<List<Payment>> getPaymentsByPropertyId(String propertyId);
  Future<List<Payment>> getPaymentsByTenantId(String tenantId);
  Future<List<Payment>> getPaymentsByStatus(String status);
  Future<List<Payment>> getPaymentsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<List<Payment>> getOverduePayments();
  Future<String> recordPayment(Payment payment);
  Future<void> updatePayment(Payment payment);
  Future<void> deletePayment(String id);
  Future<double> getTotalRevenue();
  Future<double> getMonthlyRevenue(DateTime month);
}

