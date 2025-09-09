// lib/features/payments/data/repositories/payment_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:property_manager/features/payments/data/datasources/payment_local_datasource.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentLocalDatasource localDatasource;

  PaymentRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, List<Payment>>> getPayments({
    String? leaseId,
    String? tenantId,
    String? propertyId,
    PaymentStatus? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final payments = await localDatasource.getPayments(
        leaseId: leaseId,
        tenantId: tenantId,
        propertyId: propertyId,
        status: status,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(payments);
    } on DatabaseException {
      return const Left(DatabaseFailure('Failed to get payments'));
    }
  }

  @override
  Future<Either<Failure, Payment>> getPaymentById(String id) async {
    try {
      final payment = await localDatasource.getPaymentById(id);
      return Right(payment);
    } on DatabaseException {
      return const Left(DatabaseFailure('Failed to get payment'));
    }
  }

  @override
  Future<Either<Failure, Payment>> recordPayment(Payment payment) async {
    try {
      final recordedPayment = await localDatasource.insertPayment(payment);
      return Right(recordedPayment);
    } on DatabaseException {
      return const Left(DatabaseFailure('Failed to record payment'));
    }
  }

  @override
  Future<Either<Failure, Payment>> updatePayment(Payment payment) async {
    try {
      final updatedPayment = await localDatasource.updatePayment(payment);
      return Right(updatedPayment);
    } on DatabaseException {
      return const Left(DatabaseFailure('Failed to update payment'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePayment(String id) async {
    try {
      await localDatasource.deletePayment(id);
      return const Right(null);
    } on DatabaseException {
      return const Left(DatabaseFailure('Failed to delete payment'));
    }
  }

  @override
  Future<Either<Failure, List<Payment>>> getOverduePayments({
    String? tenantId,
    String? propertyId,
  }) async {
    try {
      final overduePayments = await localDatasource.getOverduePayments(
        tenantId: tenantId,
        propertyId: propertyId,
      );
      return Right(overduePayments);
    } on DatabaseException {
      return const Left(DatabaseFailure('Failed to get overdue payments'));
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> getPaymentSummary({
    String? leaseId,
    String? tenantId,
    String? propertyId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final summary = await localDatasource.getPaymentSummary(
        leaseId: leaseId,
        tenantId: tenantId,
        propertyId: propertyId,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(summary);
    } on DatabaseException {
      return const Left(DatabaseFailure('Failed to get payment summary'));
    }
  }
}
