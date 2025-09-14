// lib/features/payments/domain/usecases/generate_payment_report.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:property_manager/features/auth/domain/usecases/login_user.dart';
import 'package:property_manager/features/payments/presentation/pages/payment_history_page.dart';
import '../../../../core/errors/failures.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class GeneratePaymentReport
    implements UseCase<PaymentReport, GeneratePaymentReportParams> {
  final PaymentRepository repository;

  GeneratePaymentReport(this.repository);

  @override
  Future<Either<Failure, PaymentReport>> call(
    GeneratePaymentReportParams params,
  ) async {
    try {
      // Get payments for the specified period
      final paymentsResult = await repository.getPayments(
        leaseId: params.leaseId,
        tenantId: params.tenantId,
        propertyId: params.propertyId,
        startDate: params.startDate,
        endDate: params.endDate,
      );

      return paymentsResult.fold((failure) => Left(failure), (payments) async {
        // Get summary statistics
        final summaryResult = await repository.getPaymentSummary(
          leaseId: params.leaseId,
          tenantId: params.tenantId,
          propertyId: params.propertyId,
          startDate: params.startDate,
          endDate: params.endDate,
        );

        return summaryResult.fold(
          (failure) => Left(failure),
          (summary) => Right(
            PaymentReport(
              payments: payments,
              totalDue: summary['totalDue'] ?? 0.0,
              totalPaid: summary['totalPaid'] ?? 0.0,
              totalOverdue: summary['totalOverdue'] ?? 0.0,
              overdueCount: (summary['overdueCount'] ?? 0.0).toInt(),
              totalPayments: (summary['totalPayments'] ?? 0.0).toInt(),
              startDate: params.startDate,
              endDate: params.endDate,
              generatedAt: DateTime.now(),
            ),
          ),
        );
      });
    } catch (e) {
      return Left(DatabaseFailure('Failed to generate payment report: $e'));
    }
  }

  getPaymentStatistics({required DateTime startDate, required DateTime endDate}) {}

  exportPayments({required String searchQuery, required PaymentFilter filter, required String format}) {}
}

class GeneratePaymentReportParams extends Equatable {
  final String? leaseId;
  final String? tenantId;
  final String? propertyId;
  final DateTime? startDate;
  final DateTime? endDate;

  const GeneratePaymentReportParams({
    this.leaseId,
    this.tenantId,
    this.propertyId,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
    leaseId,
    tenantId,
    propertyId,
    startDate,
    endDate,
  ];
}

class PaymentReport extends Equatable {
  final List<Payment> payments;
  final double totalDue;
  final double totalPaid;
  final double totalOverdue;
  final int overdueCount;
  final int totalPayments;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime generatedAt;

  const PaymentReport({
    required this.payments,
    required this.totalDue,
    required this.totalPaid,
    required this.totalOverdue,
    required this.overdueCount,
    required this.totalPayments,
    this.startDate,
    this.endDate,
    required this.generatedAt,
  });

  double get collectionRate {
    if (totalDue == 0) return 100.0;
    return (totalPaid / totalDue) * 100;
  }

  double get overdueRate {
    if (totalPayments == 0) return 0.0;
    return (overdueCount / totalPayments) * 100;
  }

  Map<PaymentStatus, int> get paymentStatusBreakdown {
    final breakdown = <PaymentStatus, int>{};
    for (final status in PaymentStatus.values) {
      breakdown[status] = 0;
    }

    for (final payment in payments) {
      breakdown[payment.status] = (breakdown[payment.status] ?? 0) + 1;
    }

    return breakdown;
  }

  Map<PaymentType, double> get paymentTypeBreakdown {
    final breakdown = <PaymentType, double>{};
    for (final type in PaymentType.values) {
      breakdown[type] = 0.0;
    }

    for (final payment in payments) {
      breakdown[payment.type] =
          (breakdown[payment.type] ?? 0.0) + payment.amount;
    }

    return breakdown;
  }

  @override
  List<Object?> get props => [
    payments,
    totalDue,
    totalPaid,
    totalOverdue,
    overdueCount,
    totalPayments,
    startDate,
    endDate,
    generatedAt,
  ];
}

enum PaymentStatusType { pending, paid, overdue, partial }
