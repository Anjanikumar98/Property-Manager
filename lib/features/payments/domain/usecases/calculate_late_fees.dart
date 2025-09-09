// lib/features/payments/domain/usecases/calculate_late_fees.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:property_manager/features/auth/domain/usecases/login_user.dart';
import '../../../../core/errors/failures.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';
import '../../data/models/payment_model.dart';

class CalculateLateFees
    implements UseCase<List<Payment>, CalculateLateFeeParams> {
  final PaymentRepository repository;

  CalculateLateFees(this.repository);

  @override
  Future<Either<Failure, List<Payment>>> call(
    CalculateLateFeeParams params,
  ) async {
    try {
      // Get overdue payments
      final overduePaymentsResult = await repository.getOverduePayments(
        tenantId: params.tenantId,
        propertyId: params.propertyId,
      );

      return overduePaymentsResult.fold((failure) => Left(failure), (
        overduePayments,
      ) async {
        final updatedPayments = <Payment>[];

        for (final payment in overduePayments) {
          if (params.paymentIds != null &&
              !params.paymentIds!.contains(payment.id)) {
            continue;
          }

          final oldLateFee = payment.lateFee;
          final newLateFee = payment.calculateLateFee(
            lateFeePercentage:
                params.lateFeePercentage ??
                PaymentBusinessRules.defaultLateFeePercentage,
            maximumLateFee:
                params.maximumLateFee ??
                PaymentBusinessRules.defaultMaximumLateFee,
            gracePeriodDays:
                params.gracePeriodDays ??
                PaymentBusinessRules.defaultGracePeriodDays,
          );

          if (newLateFee > oldLateFee) {
            final updatedPayment = payment.copyWith(
              lateFee: newLateFee,
              status: PaymentBusinessRules.updatePaymentStatus(
                amount: payment.amount,
                paidAmount: payment.paidAmount,
                lateFee: newLateFee,
                dueDate: payment.dueDate,
              ),
              updatedAt: DateTime.now(),
            );

            final updateResult = await repository.updatePayment(updatedPayment);
            updateResult.fold(
              (failure) => throw Exception(failure.toString()),
              (savedPayment) => updatedPayments.add(savedPayment),
            );
          }
        }

        return Right(updatedPayments);
      });
    } catch (e) {
      return Left(DatabaseFailure('Failed to calculate late fees: $e'));
    }
  }
}

class CalculateLateFeeParams extends Equatable {
  final String? tenantId;
  final String? propertyId;
  final List<String>? paymentIds;
  final double? lateFeePercentage;
  final double? maximumLateFee;
  final int? gracePeriodDays;

  const CalculateLateFeeParams({
    this.tenantId,
    this.propertyId,
    this.paymentIds,
    this.lateFeePercentage,
    this.maximumLateFee,
    this.gracePeriodDays,
  });

  @override
  List<Object?> get props => [
    tenantId,
    propertyId,
    paymentIds,
    lateFeePercentage,
    maximumLateFee,
    gracePeriodDays,
  ];
}


