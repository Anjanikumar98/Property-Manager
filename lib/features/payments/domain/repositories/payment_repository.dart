// lib/features/payments/domain/repositories/payment_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/payment.dart';

abstract class PaymentRepository {
  Future<Either<Failure, List<Payment>>> getPayments({
    String? leaseId,
    String? tenantId,
    String? propertyId,
    PaymentStatus? status,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Either<Failure, Payment>> getPaymentById(String id);

  Future<Either<Failure, Payment>> recordPayment(Payment payment);

  Future<Either<Failure, Payment>> updatePayment(Payment payment);

  Future<Either<Failure, void>> deletePayment(String id);

  Future<Either<Failure, List<Payment>>> getOverduePayments({
    String? tenantId,
    String? propertyId,
  });

  Future<Either<Failure, Map<String, double>>> getPaymentSummary({
    String? leaseId,
    String? tenantId,
    String? propertyId,
    DateTime? startDate,
    DateTime? endDate,
  });
}
