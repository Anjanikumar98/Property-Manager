// lib/features/payments/domain/usecases/update_payment.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:property_manager/features/auth/domain/usecases/login_user.dart';
import '../../../../core/errors/failures.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';
import '../../data/models/payment_model.dart';

class UpdatePayment implements UseCase<Payment, UpdatePaymentParams> {
  final PaymentRepository repository;

  UpdatePayment(this.repository);

  @override
  Future<Either<Failure, Payment>> call(UpdatePaymentParams params) async {
    try {
      // Recalculate payment with latest business rules
      final updatedPayment = _recalculatePayment(params.payment);
      return await repository.updatePayment(updatedPayment);
    } catch (e) {
      return Left(DatabaseFailure('Failed to update payment: $e'));
    }
  }

  Payment _recalculatePayment(Payment payment) {
    // Recalculate late fee if overdue
    final newLateFee = payment.calculateLateFee(
      lateFeePercentage: PaymentBusinessRules.defaultLateFeePercentage,
      maximumLateFee: PaymentBusinessRules.defaultMaximumLateFee,
    );

    // Recalculate status
    final newStatus = PaymentBusinessRules.updatePaymentStatus(
      amount: payment.amount,
      paidAmount: payment.paidAmount,
      lateFee: newLateFee,
      dueDate: payment.dueDate,
    );

    return payment.copyWith(
      lateFee: newLateFee,
      status: newStatus,
      updatedAt: DateTime.now(),
    );
  }
}

class UpdatePaymentParams extends Equatable {
  final Payment payment;

  const UpdatePaymentParams({required this.payment});

  @override
  List<Object> get props => [payment];
}
