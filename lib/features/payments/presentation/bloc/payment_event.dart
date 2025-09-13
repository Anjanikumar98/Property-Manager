// // lib/features/payments/presentation/bloc/payment_event.dart
// abstract class PaymentEvent {}
//
// class LoadPaymentsEvent extends PaymentEvent {}
//
// class LoadPaymentHistoryEvent extends PaymentEvent {
//   final String searchQuery;
//   final PaymentFilter filter;
//   final PaymentSortOption sortOption;
//
//   LoadPaymentHistoryEvent({
//     this.searchQuery = '',
//     required this.filter,
//     this.sortOption = PaymentSortOption.dueDateDesc,
//   });
// }
//
// class LoadMorePaymentsEvent extends PaymentEvent {}
//
// class RecordPaymentEvent extends PaymentEvent {
//   final PaymentModel payment;
//
//   RecordPaymentEvent(this.payment);
// }
//
// class UpdatePaymentEvent extends PaymentEvent {
//   final PaymentModel payment;
//
//   UpdatePaymentEvent(this.payment);
// }
//
// class DeletePaymentEvent extends PaymentEvent {
//   final String paymentId;
//
//   DeletePaymentEvent(this.paymentId);
// }
//
// class GenerateReceiptEvent extends PaymentEvent {
//   final String paymentId;
//
//   GenerateReceiptEvent(this.paymentId);
// }
//
// class ExportPaymentsEvent extends PaymentEvent {
//   final String searchQuery;
//   final PaymentFilter filter;
//   final String format; // 'pdf', 'excel', 'csv'
//
//   ExportPaymentsEvent({
//     this.searchQuery = '',
//     required this.filter,
//     this.format = 'pdf',
//   });
// }
//
// class SchedulePaymentReminderEvent extends PaymentEvent {
//   final String paymentId;
//   final DateTime reminderDate;
//   final PaymentReminderType type;
//   final String? message;
//
//   SchedulePaymentReminderEvent({
//     required this.paymentId,
//     required this.reminderDate,
//     required this.type,
//     this.message,
//   });
// }
//
// class LoadOverduePaymentsEvent extends PaymentEvent {}
//
// class MarkPaymentAsPaidEvent extends PaymentEvent {
//   final String paymentId;
//   final DateTime paidDate;
//   final PaymentMethod method;
//   final String? transactionId;
//
//   MarkPaymentAsPaidEvent({
//     required this.paymentId,
//     required this.paidDate,
//     required this.method,
//     this.transactionId,
//   });
// }
//
// class SearchPaymentsEvent extends PaymentEvent {
//   final AdvancedSearchCriteria criteria;
//
//   SearchPaymentsEvent(this.criteria);
// }
//
// class LoadPaymentStatisticsEvent extends PaymentEvent {
//   final DateTime startDate;
//   final DateTime endDate;
//
//   LoadPaymentStatisticsEvent({
//     required this.startDate,
//     required this.endDate,
//   });
// }
