// // lib/features/payments/presentation/bloc/payment_bloc.dart
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:property_manager/features/payments/data/models/payment_model.dart';
// import 'package:property_manager/features/payments/domain/entities/payment.dart';
// import 'package:property_manager/features/payments/presentation/bloc/payment_event.dart';
// import 'package:property_manager/features/payments/presentation/bloc/payment_state.dart';
// import 'package:property_manager/features/properties/domain/entities/property.dart';
// import 'package:property_manager/features/tenants/domain/entities/tenant.dart';
// import '../../domain/usecases/record_payment.dart';
// import '../../domain/usecases/get_payments.dart';
// import '../../domain/usecases/update_payment.dart';
// import '../../domain/usecases/generate_payment_report.dart';
// import '../../data/services/payment_reminder_service.dart';
// import '../../data/services/payment_receipt_generator.dart';
//
// class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
//   final RecordPayment recordPaymentUseCase;
//   final GetPayments getPaymentsUseCase;
//   final UpdatePayment updatePaymentUseCase;
//   final DeletePayment deletePaymentUseCase;
//   final GeneratePaymentReport generateReportUseCase;
//   final PaymentReminderService reminderService;
//   final PaymentReceiptGenerator receiptGenerator;
//
//   PaymentBloc({
//     required this.recordPaymentUseCase,
//     required this.getPaymentsUseCase,
//     required this.updatePaymentUseCase,
//     required this.deletePaymentUseCase,
//     required this.generateReportUseCase,
//     required this.reminderService,
//     required this.receiptGenerator,
//   }) : super(PaymentInitial()) {
//     on<LoadPaymentsEvent>(_onLoadPayments);
//     on<LoadPaymentHistoryEvent>(_onLoadPaymentHistory);
//     on<LoadMorePaymentsEvent>(_onLoadMorePayments);
//     on<RecordPaymentEvent>(_onRecordPayment);
//     on<UpdatePaymentEvent>(_onUpdatePayment);
//     on<DeletePaymentEvent>(_onDeletePayment);
//     on<GenerateReceiptEvent>(_onGenerateReceipt);
//     on<ExportPaymentsEvent>(_onExportPayments);
//     on<SchedulePaymentReminderEvent>(_onScheduleReminder);
//     on<LoadOverduePaymentsEvent>(_onLoadOverduePayments);
//     on<MarkPaymentAsPaidEvent>(_onMarkPaymentAsPaid);
//     on<SearchPaymentsEvent>(_onSearchPayments);
//     on<LoadPaymentStatisticsEvent>(_onLoadStatistics);
//   }
//
//   Future<void> _onLoadPayments(
//     LoadPaymentsEvent event,
//     Emitter<PaymentState> emit,
//   ) async {
//     try {
//       emit(PaymentLoading());
//       final result = await getPaymentsUseCase();
//       result.fold(
//         (failure) => emit(PaymentError(failure.message)),
//         (payments) => emit(PaymentLoaded(payments)),
//       );
//     } catch (e) {
//       emit(PaymentError('Failed to load payments: ${e.toString()}'));
//     }
//   }
//
//   Future<void> _onLoadPaymentHistory(
//     LoadPaymentHistoryEvent event,
//     Emitter<PaymentState> emit,
//   ) async {
//     try {
//       emit(PaymentLoading());
//
//       final result = await getPaymentsUseCase.getPaymentHistory(
//         searchQuery: event.searchQuery,
//         filter: event.filter,
//         sortOption: event.sortOption,
//         page: 1,
//         pageSize: 20,
//       );
//
//       result.fold((failure) => emit(PaymentError(failure.message)), (data) {
//         final summary = _calculateSummary(data.payments);
//         emit(
//           PaymentHistoryLoaded(
//             payments: data.payments,
//             summary: summary,
//             hasMore: data.hasMore,
//             currentPage: 1,
//           ),
//         );
//       });
//     } catch (e) {
//       emit(PaymentError('Failed to load payment history: ${e.toString()}'));
//     }
//   }
//
//   Future<void> _onLoadMorePayments(
//     LoadMorePaymentsEvent event,
//     Emitter<PaymentState> emit,
//   ) async {
//     if (state is! PaymentHistoryLoaded) return;
//
//     final currentState = state as PaymentHistoryLoaded;
//     if (!currentState.hasMore) return;
//
//     try {
//       final result = await getPaymentsUseCase.getPaymentHistory(
//         page: currentState.currentPage + 1,
//         pageSize: 20,
//       );
//
//       result.fold((failure) => emit(PaymentError(failure.message)), (data) {
//         final allPayments = [...currentState.payments, ...data.payments];
//         final summary = _calculateSummary(allPayments);
//
//         emit(
//           currentState.copyWith(
//             payments: allPayments,
//             summary: summary,
//             hasMore: data.hasMore,
//             currentPage: currentState.currentPage + 1,
//           ),
//         );
//       });
//     } catch (e) {
//       emit(PaymentError('Failed to load more payments: ${e.toString()}'));
//     }
//   }
//
//   Future<void> _onRecordPayment(
//     RecordPaymentEvent event,
//     Emitter<PaymentState> emit,
//   ) async {
//     try {
//       final result = await recordPaymentUseCase(event.payment);
//       result.fold((failure) => emit(PaymentError(failure.message)), (
//         payment,
//       ) async {
//         // Schedule automatic reminders
//         await reminderService.createAutomaticReminders(payment);
//
//         emit(
//           PaymentOperationSuccess(
//             message: 'Payment recorded successfully',
//             payment: payment,
//           ),
//         );
//       });
//     } catch (e) {
//       emit(PaymentError('Failed to record payment: ${e.toString()}'));
//     }
//   }
//
//   Future<void> _onGenerateReceipt(
//     GenerateReceiptEvent event,
//     Emitter<PaymentState> emit,
//   ) async {
//     try {
//       // Get payment details
//       final paymentResult = await getPaymentsUseCase.getPaymentById(
//         event.paymentId,
//       );
//
//       paymentResult.fold((failure) => emit(PaymentError(failure.message)), (
//         payment,
//       ) async {
//         try {
//           // Get additional data needed for receipt
//           final propertyResult = await _getProperty(payment.propertyId);
//           final tenantResult = await _getTenant(payment.tenantId);
//
//           if (propertyResult != null && tenantResult != null) {
//             final receiptPath = await receiptGenerator.generateReceipt(
//               payment: payment,
//               property: propertyResult,
//               tenant: tenantResult,
//             );
//
//             emit(
//               PaymentReceiptGenerated(
//                 receiptPath: receiptPath,
//                 payment: payment,
//               ),
//             );
//           } else {
//             emit(PaymentError('Failed to get required data for receipt'));
//           }
//         } catch (e) {
//           emit(PaymentError('Failed to generate receipt: ${e.toString()}'));
//         }
//       });
//     } catch (e) {
//       emit(PaymentError('Failed to generate receipt: ${e.toString()}'));
//     }
//   }
//
//   Future<void> _onScheduleReminder(
//     SchedulePaymentReminderEvent event,
//     Emitter<PaymentState> emit,
//   ) async {
//     try {
//       await reminderService.schedulePaymentReminder(
//         paymentId: event.paymentId,
//         reminderDate: event.reminderDate,
//         type: event.type,
//         customMessage: event.message,
//       );
//
//       emit(PaymentReminderScheduled('Reminder scheduled successfully'));
//     } catch (e) {
//       emit(PaymentError('Failed to schedule reminder: ${e.toString()}'));
//     }
//   }
//
//   Future<void> _onLoadOverduePayments(
//     LoadOverduePaymentsEvent event,
//     Emitter<PaymentState> emit,
//   ) async {
//     try {
//       final result = await getPaymentsUseCase.getOverduePayments();
//       result.fold((failure) => emit(PaymentError(failure.message)), (
//         overduePayments,
//       ) {
//         final totalAmount = overduePayments.fold<double>(
//           0.0,
//           (sum, payment) => sum + payment.totalAmount,
//         );
//
//         emit(
//           OverduePaymentsLoaded(
//             overduePayments: overduePayments,
//             totalOverdueAmount: totalAmount,
//           ),
//         );
//       });
//     } catch (e) {
//       emit(PaymentError('Failed to load overdue payments: ${e.toString()}'));
//     }
//   }
//
//   Future<void> _onMarkPaymentAsPaid(
//     MarkPaymentAsPaidEvent event,
//     Emitter<PaymentState> emit,
//   ) async {
//     try {
//       final result = await updatePaymentUseCase.markAsPaid(
//         paymentId: event.paymentId,
//         paidDate: event.paidDate,
//         method: event.method,
//         transactionId: event.transactionId,
//       );
//
//       result.fold(
//         (failure) => emit(PaymentError(failure.message)),
//         (payment) => emit(
//           PaymentOperationSuccess(
//             message: 'Payment marked as paid',
//             payment: payment,
//           ),
//         ),
//       );
//     } catch (e) {
//       emit(PaymentError('Failed to update payment: ${e.toString()}'));
//     }
//   }
//
//   Future<void> _onExportPayments(
//     ExportPaymentsEvent event,
//     Emitter<PaymentState> emit,
//   ) async {
//     try {
//       final result = await generateReportUseCase.exportPayments(
//         searchQuery: event.searchQuery,
//         filter: event.filter,
//         format: event.format,
//       );
//
//       result.fold(
//         (failure) => emit(PaymentError(failure.message)),
//         (filePath) => emit(
//           PaymentExportCompleted(filePath: filePath, format: event.format),
//         ),
//       );
//     } catch (e) {
//       emit(PaymentError('Failed to export payments: ${e.toString()}'));
//     }
//   }
//
//   Future<void> _onLoadStatistics(
//     LoadPaymentStatisticsEvent event,
//     Emitter<PaymentState> emit,
//   ) async {
//     try {
//       final result = await generateReportUseCase.getPaymentStatistics(
//         startDate: event.startDate,
//         endDate: event.endDate,
//       );
//
//       result.fold(
//         (failure) => emit(PaymentError(failure.message)),
//         (statistics) => emit(PaymentStatisticsLoaded(statistics)),
//       );
//     } catch (e) {
//       emit(PaymentError('Failed to load statistics: ${e.toString()}'));
//     }
//   }
//
//   Future<void> _onSearchPayments(
//     SearchPaymentsEvent event,
//     Emitter<PaymentState> emit,
//   ) async {
//     try {
//       final result = await getPaymentsUseCase.searchPayments(event.criteria);
//       result.fold((failure) => emit(PaymentError(failure.message)), (payments) {
//         final summary = _calculateSummary(payments);
//         emit(
//           PaymentHistoryLoaded(
//             payments: payments,
//             summary: summary,
//             hasMore: false,
//             currentPage: 1,
//           ),
//         );
//       });
//     } catch (e) {
//       emit(PaymentError('Failed to search payments: ${e.toString()}'));
//     }
//   }
//
//   PaymentSummary _calculateSummary(List<PaymentModel> payments) {
//     double totalAmount = 0;
//     double paidAmount = 0;
//     double overdueAmount = 0;
//     double pendingAmount = 0;
//
//     for (final payment in payments) {
//       totalAmount += payment.totalAmount;
//
//       switch (payment.status) {
//         case PaymentStatus.paid:
//           paidAmount += payment.totalAmount;
//           break;
//         case PaymentStatus.overdue:
//           overdueAmount += payment.totalAmount;
//           break;
//         case PaymentStatus.pending:
//           pendingAmount += payment.totalAmount;
//           break;
//         case PaymentStatus.partial:
//           // Handle partial payments based on your business logic
//           pendingAmount += payment.totalAmount;
//           break;
//         case PaymentStatus.cancelled:
//           break;
//       }
//     }
//
//     return PaymentSummary(
//       totalAmount: totalAmount,
//       paidAmount: paidAmount,
//       overdueAmount: overdueAmount,
//       pendingAmount: pendingAmount,
//     );
//   }
//
//   // Helper methods (you'll need to implement these based on your architecture)
//   Future<Property?> _getProperty(String propertyId) async {
//     // Implementation to get property details
//     return null;
//   }
//
//   Future<Tenant?> _getTenant(String tenantId) async {
//     // Implementation to get tenant details
//     return null;
//   }
// }
//
// // Supporting classes
// class PaymentSummary {
//   final double totalAmount;
//   final double paidAmount;
//   final double overdueAmount;
//   final double pendingAmount;
//
//   const PaymentSummary({
//     required this.totalAmount,
//     required this.paidAmount,
//     required this.overdueAmount,
//     required this.pendingAmount,
//   });
// }
//
// class PaymentStatistics {
//   final double totalRevenue;
//   final double averagePayment;
//   final int totalPayments;
//   final int onTimePayments;
//   final int latePayments;
//   final double collectionRate;
//   final Map<PaymentType, double> paymentsByType;
//   final Map<String, double> monthlyTrends;
//
//   const PaymentStatistics({
//     required this.totalRevenue,
//     required this.averagePayment,
//     required this.totalPayments,
//     required this.onTimePayments,
//     required this.latePayments,
//     required this.collectionRate,
//     required this.paymentsByType,
//     required this.monthlyTrends,
//   });
// }
//
// class PaymentHistoryResult {
//   final List<PaymentModel> payments;
//   final bool hasMore;
//   final int totalCount;
//
//   const PaymentHistoryResult({
//     required this.payments,
//     required this.hasMore,
//     required this.totalCount,
//   });
// }
//
//
