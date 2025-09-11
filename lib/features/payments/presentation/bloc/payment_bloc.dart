// lib/features/payments/presentation/bloc/payment_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:property_manager/features/payments/presentation/bloc/payment_event.dart'
    as record_payment_usecase;
import '../../domain/entities/payment.dart';
import '../../domain/usecases/get_payments.dart';
import '../../domain/usecases/generate_payment_report.dart';
import '../../data/models/payment_model.dart';
import '../../domain/usecases/record_payment.dart' as record_payment_usecase;
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final record_payment_usecase.RecordPayment _recordPaymentUseCase;
  final GetPayments _getPayments;
  final GeneratePaymentReport _generatePaymentReport;

  PaymentBloc({
    required record_payment_usecase.RecordPayment recordPayment,
    required GetPayments getPayments,
    required GeneratePaymentReport generatePaymentReport,
  }) : _recordPaymentUseCase = recordPayment,
       _getPayments = getPayments,
       _generatePaymentReport = generatePaymentReport,
       super(PaymentInitial()) {
    on<LoadPayments>(_onLoadPayments);
    on<RecordPayment>(_onRecordPayment);
    on<UpdatePayment>(_onUpdatePayment);
    on<RecordPartialPayment>(_onRecordPartialPayment);
    on<CalculateLateFees>(_onCalculateLateFees);
    on<DeletePayment>(_onDeletePayment);
    on<GenerateRecurringPayments>(_onGenerateRecurringPayments);
  }

  Future<void> _onLoadPayments(
    LoadPayments event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    try {
      final result = await _getPayments(
        GetPaymentsParams(
          leaseId: event.leaseId,
          tenantId: event.tenantId,
          propertyId: event.propertyId,
          status: event.status,
        ),
      );

      result.fold((failure) => emit(PaymentError(failure.toString())), (
        payments,
      ) {
        final stats = _calculatePaymentStatistics(payments);
        emit(
          PaymentLoaded(
            payments: payments,
            totalAmount: stats['totalAmount']!,
            totalPaid: stats['totalPaid']!,
            totalOverdue: stats['totalOverdue']!,
            overdueCount: stats['overdueCount']!.toInt(),
          ),
        );
      });
    } catch (e) {
      emit(PaymentError('Failed to load payments: $e'));
    }
  }

  Future<void> _onRecordPayment(
    RecordPayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    // try {
    //   final result = await _recordPaymentUseCase(
    //     record_payment_usecase.RecordPaymentParams(payment: event.payment),
    //   );
    //
    //   result.fold(
    //         (failure) => emit(PaymentError(failure.toString())),
    //         (payment) => emit(PaymentRecorded(payment)),
    //   );
    // } catch (e) {
    //   emit(PaymentError('Failed to record payment: $e'));
    // }
  }

  Future<void> _onUpdatePayment(
    UpdatePayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    // try {
    //   // Update payment with recalculated status and late fees
    //   final updatedPayment = _recalculatePayment(event.payment);
    //
    //   final result = await _recordPaymentUseCase(
    //     record_payment_usecase.RecordPaymentParams(payment: updatedPayment),
    //   );
    //
    //   result.fold(
    //         (failure) => emit(PaymentError(failure.toString())),
    //         (payment) => emit(PaymentUpdated(payment)),
    //   );
    // } catch (e) {
    //   emit(PaymentError('Failed to update payment: $e'));
    // }
  }

  Future<void> _onRecordPartialPayment(
    RecordPartialPayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    // try {
    //   // First get the current payment
    //   final paymentsResult = await _getPayments(const GetPaymentsParams());
    //
    //   paymentsResult.fold((failure) => emit(PaymentError(failure.toString())), (
    //       payments,
    //       ) async {
    //     final currentPayment = payments.firstWhere(
    //           (p) => p.id == event.paymentId,
    //       orElse: () => throw Exception('Payment not found'),
    //     );
    //
    //     // Calculate new paid amount
    //     final newPaidAmount = currentPayment.paidAmount + event.amount;
    //     final paymentDate = event.paymentDate ?? DateTime.now();
    //
    //     // Update payment with new amount and status
    //     final updatedPayment = currentPayment.copyWith(
    //       paidAmount: newPaidAmount,
    //       paidDate:
    //       newPaidAmount >= currentPayment.totalAmountDue
    //           ? paymentDate
    //           : currentPayment.paidDate,
    //       paymentMethod: event.paymentMethod ?? currentPayment.paymentMethod,
    //       reference: event.reference ?? currentPayment.reference,
    //       updatedAt: DateTime.now(),
    //     );
    //
    //     final finalPayment = _recalculatePayment(updatedPayment);
    //
    //     final result = await _recordPaymentUseCase(
    //       record_payment_usecase.RecordPaymentParams(payment: finalPayment),
    //     );
    //
    //     result.fold(
    //           (failure) => emit(PaymentError(failure.toString())),
    //           (payment) => emit(PaymentUpdated(payment)),
    //     );
    //   });
    // } catch (e) {
    //   emit(PaymentError('Failed to record partial payment: $e'));
    // }
  }

  Future<void> _onCalculateLateFees(
    CalculateLateFees event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    // try {
    //   final paymentsResult = await _getPayments(const GetPaymentsParams());
    //
    //   paymentsResult.fold((failure) => emit(PaymentError(failure.toString())), (
    //       payments,
    //       ) async {
    //     final paymentsToUpdate =
    //     event.paymentIds != null
    //         ? payments
    //         .where((p) => event.paymentIds!.contains(p.id))
    //         .toList()
    //         : payments.where((p) => p.isOverdue && !p.isFullyPaid).toList();
    //
    //     final updatedPayments = <Payment>[];
    //     double totalLateFeesAdded = 0.0;
    //
    //     for (final payment in paymentsToUpdate) {
    //       final oldLateFee = payment.lateFee;
    //       final newLateFee = payment.calculateLateFee(
    //         lateFeePercentage: PaymentBusinessRules.defaultLateFeePercentage,
    //         maximumLateFee: PaymentBusinessRules.defaultMaximumLateFee,
    //       );
    //
    //       if (newLateFee > oldLateFee) {
    //         final updatedPayment = payment.copyWith(
    //           lateFee: newLateFee,
    //           updatedAt: DateTime.now(),
    //         );
    //
    //         final finalPayment = _recalculatePayment(updatedPayment);
    //
    //         final result = await _recordPaymentUseCase(
    //           record_payment_usecase.RecordPaymentParams(payment: finalPayment),
    //         );
    //
    //         result.fold((failure) => throw Exception(failure.toString()), (
    //             savedPayment,
    //             ) {
    //           updatedPayments.add(savedPayment);
    //           totalLateFeesAdded += (newLateFee - oldLateFee);
    //         });
    //       }
    //     }
    //
    //     emit(
    //       LateFeesCalculated(
    //         updatedPayments: updatedPayments,
    //         totalLateFeesAdded: totalLateFeesAdded,
    //       ),
    //     );
    //   });
    // } catch (e) {
    //   emit(PaymentError('Failed to calculate late fees: $e'));
    // }
  }

  Future<void> _onDeletePayment(
    DeletePayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    try {
      // Implementation depends on your repository interface
      // For now, we'll emit a success state
      emit(PaymentDeleted(event.paymentId));
    } catch (e) {
      emit(PaymentError('Failed to delete payment: $e'));
    }
  }

  Future<void> _onGenerateRecurringPayments(
    GenerateRecurringPayments event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    // try {
    //   final generatedPayments = _generateMonthlyPayments(
    //     leaseId: event.leaseId,
    //     startDate: event.startDate,
    //     endDate: event.endDate,
    //   );
    //
    //   final savedPayments = <Payment>[];
    //
    //   for (final payment in generatedPayments) {
    //     final result = await _recordPaymentUseCase(
    //       record_payment_usecase.RecordPaymentParams(payment: payment),
    //     );
    //
    //     result.fold(
    //           (failure) => throw Exception(failure.toString()),
    //           (savedPayment) => savedPayments.add(savedPayment),
    //     );
    //   }
    //
    //   emit(RecurringPaymentsGenerated(savedPayments));
    // } catch (e) {
    //   emit(PaymentError('Failed to generate recurring payments: $e'));
    // }
  }

  // Helper methods
  Map<String, double> _calculatePaymentStatistics(List<Payment> payments) {
    double totalAmount = 0.0;
    double totalPaid = 0.0;
    double totalOverdue = 0.0;
    int overdueCount = 0;

    for (final payment in payments) {
      totalAmount += payment.totalAmountDue;
      totalPaid += payment.paidAmount;

      if (payment.isOverdue) {
        totalOverdue += payment.totalRemainingAmount;
        overdueCount++;
      }
    }

    return {
      'totalAmount': totalAmount,
      'totalPaid': totalPaid,
      'totalOverdue': totalOverdue,
      'overdueCount': overdueCount.toDouble(),
    };
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

  List<Payment> _generateMonthlyPayments({
    required String leaseId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    // This would typically get lease details from repository
    // For now, we'll create a basic implementation
    final payments = <Payment>[];
    var currentDate = DateTime(startDate.year, startDate.month, startDate.day);

    while (currentDate.isBefore(endDate)) {
      final payment = PaymentModel(
        id:
            DateTime.now().millisecondsSinceEpoch.toString() +
            payments.length.toString(),
        leaseId: leaseId,
        tenantId: '', // Would be fetched from lease
        propertyId: '', // Would be fetched from lease
        type: PaymentType.rent,
        status: PaymentStatus.pending,
        amount: 1000.0, // Would be fetched from lease
        paidAmount: 0.0,
        lateFee: 0.0,
        dueDate: DateTime(currentDate.year, currentDate.month, 1),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        description:
            'Monthly rent for ${_getMonthName(currentDate.month)} ${currentDate.year}',
        reference: PaymentBusinessRules.generatePaymentReference(
          propertyId: '', // Would be fetched from lease
          type: PaymentType.rent,
        ),
      );

      payments.add(payment);

      // Move to next month
      if (currentDate.month == 12) {
        currentDate = DateTime(currentDate.year + 1, 1, currentDate.day);
      } else {
        currentDate = DateTime(
          currentDate.year,
          currentDate.month + 1,
          currentDate.day,
        );
      }
    }

    return payments;
  }

  String _getMonthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month];
  }
}


