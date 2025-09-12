// lib/features/payments/domain/entities/payment.dart
import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final String id;
  final String leaseId;
  final String tenantId;
  final String propertyId;
  final PaymentType type;
  final PaymentStatus status;
  final double amount;
  final double paidAmount;
  final double lateFee;
  final DateTime dueDate;
  final DateTime? paidDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? description;
  final String? reference;
  final String? paymentMethod;

  const Payment({
    required this.id,
    required this.leaseId,
    required this.tenantId,
    required this.propertyId,
    required this.type,
    required this.status,
    required this.amount,
    required this.paidAmount,
    required this.lateFee,
    required this.dueDate,
    this.paidDate,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.reference,
    this.paymentMethod,
  });

  // Financial calculation methods
  double get remainingAmount => amount - paidAmount;

  double get totalAmountDue => amount + lateFee;

  double get totalRemainingAmount => totalAmountDue - paidAmount;

  bool get isFullyPaid => paidAmount >= totalAmountDue;

  bool get isPartiallyPaid => paidAmount > 0 && paidAmount < totalAmountDue;

  bool get isOverdue {
    if (isFullyPaid) return false;
    return DateTime.now().isAfter(dueDate);
  }

  int get daysOverdue {
    if (!isOverdue) return 0;
    return DateTime.now().difference(dueDate).inDays;
  }

  double calculateLateFee({
    required double lateFeePercentage,
    required double maximumLateFee,
    int gracePeriodDays = 5,
  }) {
    if (!isOverdue || daysOverdue <= gracePeriodDays) return 0.0;

    final calculatedFee = amount * (lateFeePercentage / 100);
    return calculatedFee > maximumLateFee ? maximumLateFee : calculatedFee;
  }

  PaymentStatus getUpdatedStatus() {
    if (isFullyPaid) return PaymentStatus.completed;
    if (isPartiallyPaid && !isOverdue) return PaymentStatus.partiallyPaid;
    if (isOverdue) return PaymentStatus.overdue;
    return PaymentStatus.pending;
  }

  Payment copyWith({
    String? id,
    String? leaseId,
    String? tenantId,
    String? propertyId,
    PaymentType? type,
    PaymentStatus? status,
    double? amount,
    double? paidAmount,
    double? lateFee,
    DateTime? dueDate,
    DateTime? paidDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? description,
    String? reference,
    String? paymentMethod,
  }) {
    return Payment(
      id: id ?? this.id,
      leaseId: leaseId ?? this.leaseId,
      tenantId: tenantId ?? this.tenantId,
      propertyId: propertyId ?? this.propertyId,
      type: type ?? this.type,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      paidAmount: paidAmount ?? this.paidAmount,
      lateFee: lateFee ?? this.lateFee,
      dueDate: dueDate ?? this.dueDate,
      paidDate: paidDate ?? this.paidDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      description: description ?? this.description,
      reference: reference ?? this.reference,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  @override
  List<Object?> get props => [
    id,
    leaseId,
    tenantId,
    propertyId,
    type,
    status,
    amount,
    paidAmount,
    lateFee,
    dueDate,
    paidDate,
    createdAt,
    updatedAt,
    description,
    reference,
    paymentMethod,
  ];
}

// Extension for payment calculations
extension PaymentCalculations on Payment {
  /// Calculate the payment completion percentage
  double get completionPercentage {
    if (totalAmountDue == 0) return 100.0;
    return (paidAmount / totalAmountDue) * 100;
  }

  /// Get the payment status color for UI
  String get statusColor {
    switch (status) {
      case PaymentStatus.completed:
        return '#4CAF50'; // Green
      case PaymentStatus.pending:
        return '#FF9800'; // Orange
      case PaymentStatus.overdue:
        return '#F44336'; // Red
      case PaymentStatus.partiallyPaid:
        return '#2196F3'; // Blue
      case PaymentStatus.cancelled:
        return '#9E9E9E'; // Grey
      case PaymentStatus.paid:
        // TODO: Handle this case.
        throw UnimplementedError();
      case PaymentStatus.partial:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  /// Get human-readable status text
  String get statusText {
    switch (status) {
      case PaymentStatus.completed:
        return 'Paid';
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.overdue:
        return 'Overdue';
      case PaymentStatus.partiallyPaid:
        return 'Partially Paid';
      case PaymentStatus.cancelled:
        return 'Cancelled';
      case PaymentStatus.paid:
        // TODO: Handle this case.
        throw UnimplementedError();
      case PaymentStatus.partial:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  /// Get payment type display text
  String get typeText {
    switch (type) {
      case PaymentType.rent:
        return 'Rent';
      case PaymentType.deposit:
        return 'Security Deposit';
      case PaymentType.utilities:
        return 'Utilities';
      case PaymentType.maintenance:
        return 'Maintenance';
      case PaymentType.lateFee:
        return 'Late Fee';
      case PaymentType.other:
        return 'Other';
      case PaymentType.utility:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}

enum PaymentStatus {
  pending,
  completed,
  overdue,
  partiallyPaid,
  cancelled,
  paid,
  partial,
}

enum PaymentType {
  rent,
  deposit,
  utilities,
  maintenance,
  lateFee,
  other,
  utility,
}


