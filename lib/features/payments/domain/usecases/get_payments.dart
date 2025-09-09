// lib/features/payments/domain/usecases/get_payments.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:property_manager/features/auth/domain/usecases/login_user.dart';
import '../../../../core/errors/failures.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class GetPayments implements UseCase<List<Payment>, GetPaymentsParams> {
  final PaymentRepository repository;

  GetPayments(this.repository);

  @override
  Future<Either<Failure, List<Payment>>> call(GetPaymentsParams params) async {
    return await repository.getPayments(
      leaseId: params.leaseId,
      tenantId: params.tenantId,
      propertyId: params.propertyId,
      status: params.status,
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}

class GetPaymentsParams extends Equatable {
  final String? leaseId;
  final String? tenantId;
  final String? propertyId;
  final PaymentStatus? status;
  final DateTime? startDate;
  final DateTime? endDate;

  const GetPaymentsParams({
    this.leaseId,
    this.tenantId,
    this.propertyId,
    this.status,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
    leaseId,
    tenantId,
    propertyId,
    status,
    startDate,
    endDate,
  ];
}
