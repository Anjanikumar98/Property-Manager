// lib/features/payments/presentation/bloc/payment_state.dart
import 'package:equatable/equatable.dart';
import 'package:property_manager/features/payments/data/models/payment_model.dart';
import 'package:property_manager/features/payments/domain/entities/payment.dart';
import 'package:property_manager/features/payments/presentation/bloc/payment_bloc.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentLoaded extends PaymentState {
  final List<Payment> payments;
  final double totalAmount;
  final double totalPaid;
  final double totalOverdue;
  final int overdueCount;

  PaymentLoaded({
    required this.payments,
    required this.totalAmount,
    required this.totalPaid,
    required this.totalOverdue,
    required this.overdueCount,
  });

  PaymentLoaded copyWith({
    List<Payment>? payments,
    double? totalAmount,
    double? totalPaid,
    double? totalOverdue,
    int? overdueCount,
  }) {
    return PaymentLoaded(
      payments: payments ?? this.payments,
      totalAmount: totalAmount ?? this.totalAmount,
      totalPaid: totalPaid ?? this.totalPaid,
      totalOverdue: totalOverdue ?? this.totalOverdue,
      overdueCount: overdueCount ?? this.overdueCount,
    );
  }
}

class PaymentHistoryLoaded extends PaymentState {
  final List<PaymentModel> payments;
  final PaymentSummary summary;
  final bool hasMore;
  final int currentPage;

  PaymentHistoryLoaded({
    required this.payments,
    required this.summary,
    required this.hasMore,
    required this.currentPage,
  });

  PaymentHistoryLoaded copyWith({
    List<PaymentModel>? payments,
    PaymentSummary? summary,
    bool? hasMore,
    int? currentPage,
  }) {
    return PaymentHistoryLoaded(
      payments: payments ?? this.payments,
      summary: summary ?? this.summary,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class PaymentOperationSuccess extends PaymentState {
  final String message;
  final PaymentModel? payment;

  PaymentOperationSuccess({required this.message, this.payment});
}

class PaymentRecorded extends PaymentState {
  final PaymentModel payment;

  PaymentRecorded(this.payment);
}

class PaymentUpdated extends PaymentState {
  final PaymentModel payment;

  PaymentUpdated(this.payment);
}

class PaymentDeleted extends PaymentState {
  final String paymentId;

  PaymentDeleted(this.paymentId);
}

class PaymentReceiptGenerated extends PaymentState {
  final String receiptPath;
  final PaymentModel payment;

  PaymentReceiptGenerated({required this.receiptPath, required this.payment});
}

class PaymentExportCompleted extends PaymentState {
  final String filePath;
  final String format;

  PaymentExportCompleted({required this.filePath, required this.format});
}

class PaymentStatisticsLoaded extends PaymentState {
  final PaymentStatistics statistics;

  PaymentStatisticsLoaded(this.statistics);
}

class OverduePaymentsLoaded extends PaymentState {
  final List<PaymentModel> overduePayments;
  final double totalOverdueAmount;

  OverduePaymentsLoaded({
    required this.overduePayments,
    required this.totalOverdueAmount,
  });
}

class PaymentReminderScheduled extends PaymentState {
  final String message;

  PaymentReminderScheduled(this.message);
}

class LateFeesCalculated extends PaymentState {
  final List<Payment> updatedPayments;
  final double totalLateFeesAdded;

  LateFeesCalculated({
    required this.updatedPayments,
    required this.totalLateFeesAdded,
  });
}

class PaymentError extends PaymentState {
  final String message;

  PaymentError(this.message);
}
