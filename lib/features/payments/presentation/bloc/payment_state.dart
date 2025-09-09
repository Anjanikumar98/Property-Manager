// lib/features/payments/presentation/bloc/payment_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:property_manager/features/payments/domain/entities/payment.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentLoaded extends PaymentState {
  final List<Payment> payments;
  final double totalAmount;
  final double totalPaid;
  final double totalOverdue;
  final int overdueCount;

  const PaymentLoaded({
    required this.payments,
    required this.totalAmount,
    required this.totalPaid,
    required this.totalOverdue,
    required this.overdueCount,
  });

  @override
  List<Object> get props => [
    payments,
    totalAmount,
    totalPaid,
    totalOverdue,
    overdueCount,
  ];
}

class PaymentRecorded extends PaymentState {
  final Payment payment;

  const PaymentRecorded(this.payment);

  @override
  List<Object> get props => [payment];
}

class PaymentUpdated extends PaymentState {
  final Payment payment;

  const PaymentUpdated(this.payment);

  @override
  List<Object> get props => [payment];
}

class PaymentDeleted extends PaymentState {
  final String paymentId;

  const PaymentDeleted(this.paymentId);

  @override
  List<Object> get props => [paymentId];
}

class RecurringPaymentsGenerated extends PaymentState {
  final List<Payment> generatedPayments;

  const RecurringPaymentsGenerated(this.generatedPayments);

  @override
  List<Object> get props => [generatedPayments];
}

class LateFeesCalculated extends PaymentState {
  final List<Payment> updatedPayments;
  final double totalLateFeesAdded;

  const LateFeesCalculated({
    required this.updatedPayments,
    required this.totalLateFeesAdded,
  });

  @override
  List<Object> get props => [updatedPayments, totalLateFeesAdded];
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError(this.message);

  @override
  List<Object> get props => [message];
}
