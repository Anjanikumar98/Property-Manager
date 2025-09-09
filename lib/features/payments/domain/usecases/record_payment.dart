// lib/features/payments/domain/usecases/record_payment.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:property_manager/features/auth/domain/usecases/login_user.dart';
import '../../../../core/errors/failures.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class RecordPaymentUseCase implements UseCase<Payment, RecordPaymentParams> {
  final PaymentRepository repository;

  RecordPaymentUseCase(this.repository);

  @override
  Future<Either<Failure, Payment>> call(RecordPaymentParams params) async {
    return await repository.recordPayment(params.payment);
  }
}

class RecordPaymentParams extends Equatable {
  final Payment payment;

  const RecordPaymentParams({required this.payment});

  @override
  List<Object> get props => [payment];
}
