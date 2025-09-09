// lib/features/payments/presentation/bloc/payment_event.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/payment.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class LoadPayments extends PaymentEvent {
  final String? leaseId;
  final String? tenantId;
  final String? propertyId;
  final PaymentStatus? status;

  const LoadPayments({
    this.leaseId,
    this.tenantId,
    this.propertyId,
    this.status,
  });

  @override
  List<Object?> get props => [leaseId, tenantId, propertyId, status];
}

class RecordPayment extends PaymentEvent {
  final Payment payment;

  const RecordPayment(this.payment);

  @override
  List<Object> get props => [payment];
}

class UpdatePayment extends PaymentEvent {
  final Payment payment;

  const UpdatePayment(this.payment);

  @override
  List<Object> get props => [payment];
}

class RecordPartialPayment extends PaymentEvent {
  final String paymentId;
  final double amount;
  final String? paymentMethod;
  final String? reference;
  final DateTime? paymentDate;

  const RecordPartialPayment({
    required this.paymentId,
    required this.amount,
    this.paymentMethod,
    this.reference,
    this.paymentDate,
  });

  @override
  List<Object?> get props => [paymentId, amount, paymentMethod, reference, paymentDate];
}

class CalculateLateFees extends PaymentEvent {
  final List<String>? paymentIds;

  const CalculateLateFees({this.paymentIds});

  @override
  List<Object?> get props => [paymentIds];
}

class DeletePayment extends PaymentEvent {
  final String paymentId;

  const DeletePayment(this.paymentId);

  @override
  List<Object> get props => [paymentId];
}

class GenerateRecurringPayments extends PaymentEvent {
  final String leaseId;
  final DateTime startDate;
  final DateTime endDate;

  const GenerateRecurringPayments({
    required this.leaseId,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [leaseId, startDate, endDate];
}

