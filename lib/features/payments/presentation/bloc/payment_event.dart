// lib/features/payments/presentation/bloc/payment_event.dart
import 'package:property_manager/features/payments/data/models/payment_model.dart';
import 'package:property_manager/features/payments/domain/entities/payment.dart';
import 'package:property_manager/features/tenants/domain/entities/tenant.dart';
import '../pages/payment_history_page.dart';
import '../widgets/payment_search_widget.dart';

// Base event class
abstract class PaymentEvent {}

// Load events
class LoadPaymentsEvent extends PaymentEvent {
  final String? leaseId;
  final String? tenantId;
  final String? propertyId;
  final PaymentStatus? status;

  LoadPaymentsEvent({
    this.leaseId,
    this.tenantId,
    this.propertyId,
    this.status,
  });
}

class LoadPayments extends PaymentEvent {
  final String? leaseId;
  final String? tenantId;
  final String? propertyId;
  final PaymentStatus? status;

  LoadPayments({this.leaseId, this.tenantId, this.propertyId, this.status});
}

class LoadPaymentHistoryEvent extends PaymentEvent {
  final String searchQuery;
  final PaymentFilter filter;
  final PaymentSortOption sortOption;

  LoadPaymentHistoryEvent({
    this.searchQuery = '',
    required this.filter,
    this.sortOption = PaymentSortOption.dueDateDesc,
  });
}

class LoadMorePaymentsEvent extends PaymentEvent {}

// CRUD events
class RecordPaymentEvent extends PaymentEvent {
  final PaymentModel payment;

  RecordPaymentEvent(this.payment);
}

class RecordPayment extends PaymentEvent {
  final PaymentModel payment;

  RecordPayment(this.payment);
}

class UpdatePaymentEvent extends PaymentEvent {
  final PaymentModel payment;

  UpdatePaymentEvent(this.payment);
}

class UpdatePayment extends PaymentEvent {
  final PaymentModel payment;

  UpdatePayment(this.payment);

  markAsPaid({required String paymentId, required DateTime paidDate, required PaymentMethod method, String? transactionId}) {}

  recordPartialPayment({required String paymentId, required double amount, String? paymentMethod, String? reference}) {}
}

class DeletePaymentEvent extends PaymentEvent {
  final String paymentId;

  DeletePaymentEvent(this.paymentId);
}

class DeletePayment extends PaymentEvent {
  final String paymentId;

  DeletePayment(this.paymentId);
}

// Partial payment event
class RecordPartialPayment extends PaymentEvent {
  final String paymentId;
  final double amount;
  final String? paymentMethod;
  final String? reference;

  RecordPartialPayment({
    required this.paymentId,
    required this.amount,
    this.paymentMethod,
    this.reference,
  });
}

// Receipt generation
class GenerateReceiptEvent extends PaymentEvent {
  final String paymentId;

  GenerateReceiptEvent(this.paymentId);
}

// Export events
class ExportPaymentsEvent extends PaymentEvent {
  final String searchQuery;
  final PaymentFilter filter;
  final String format; // 'pdf', 'excel', 'csv'

  ExportPaymentsEvent({
    this.searchQuery = '',
    required this.filter,
    this.format = 'pdf',
  });
}

// Reminder events
class SchedulePaymentReminderEvent extends PaymentEvent {
  final String paymentId;
  final DateTime reminderDate;
  final PaymentReminderType type;
  final String? message;

  SchedulePaymentReminderEvent({
    required this.paymentId,
    required this.reminderDate,
    required this.type,
    this.message,
  });
}

// Status events
class LoadOverduePaymentsEvent extends PaymentEvent {}

class MarkPaymentAsPaidEvent extends PaymentEvent {
  final String paymentId;
  final DateTime paidDate;
  final PaymentMethod method;
  final String? transactionId;

  MarkPaymentAsPaidEvent({
    required this.paymentId,
    required this.paidDate,
    required this.method,
    this.transactionId,
  });
}

// Search events
class SearchPaymentsEvent extends PaymentEvent {
  final AdvancedSearchCriteria criteria;

  SearchPaymentsEvent(this.criteria);
}

// Statistics events
class LoadPaymentStatisticsEvent extends PaymentEvent {
  final DateTime startDate;
  final DateTime endDate;

  LoadPaymentStatisticsEvent({required this.startDate, required this.endDate});
}

// Late fee events
class CalculateLateFees extends PaymentEvent {
  CalculateLateFees();
}

// Payment reminder types
enum PaymentReminderType { dueSoon, overdue, custom }
