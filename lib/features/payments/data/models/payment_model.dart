// lib/features/payments/data/models/payment_model.dart
import 'dart:convert';
import '../../domain/entities/payment.dart';

class PaymentModel extends Payment {
  const PaymentModel({
    required super.id,
    required super.leaseId,
    required super.tenantId,
    required super.propertyId,
    required super.type,
    required super.status,
    required super.amount,
    required super.paidAmount,
    required super.lateFee,
    required super.dueDate,
    super.paidDate,
    required super.createdAt,
    required super.updatedAt,
    super.description,
    super.reference,
    super.paymentMethod,
  });

  // Add computed properties for backwards compatibility
  double get totalAmount => amount + lateFee;
  // int? get daysOverdue {
  //   if (!isOverdue) return null;
  //   return DateTime.now().difference(dueDate).inDays;
  // }

  factory PaymentModel.fromEntity(Payment payment) {
    return PaymentModel(
      id: payment.id,
      leaseId: payment.leaseId,
      tenantId: payment.tenantId,
      propertyId: payment.propertyId,
      type: payment.type,
      status: payment.status,
      amount: payment.amount,
      paidAmount: payment.paidAmount,
      lateFee: payment.lateFee,
      dueDate: payment.dueDate,
      paidDate: payment.paidDate,
      createdAt: payment.createdAt,
      updatedAt: payment.updatedAt,
      description: payment.description,
      reference: payment.reference,
      paymentMethod: payment.paymentMethod,
    );
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'] ?? '',
      leaseId: map['leaseId'] ?? '',
      tenantId: map['tenantId'] ?? '',
      propertyId: map['propertyId'] ?? '',
      type: _parsePaymentType(map['type']),
      status: _parsePaymentStatus(map['status']),
      amount: (map['amount'] ?? 0.0).toDouble(),
      paidAmount: (map['paidAmount'] ?? 0.0).toDouble(),
      lateFee: (map['lateFee'] ?? 0.0).toDouble(),
      dueDate: DateTime.parse(map['dueDate']),
      paidDate:
          map['paidDate'] != null ? DateTime.parse(map['paidDate']) : null,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      description: map['description'],
      reference: map['reference'],
      paymentMethod: map['paymentMethod'],
    );
  }

  static PaymentType _parsePaymentType(String? typeString) {
    if (typeString == null) return PaymentType.other;

    switch (typeString.toLowerCase()) {
      case 'rent':
        return PaymentType.rent;
      case 'deposit':
        return PaymentType.deposit;
      case 'latefee':
      case 'late_fee':
        return PaymentType.lateFee;
      case 'maintenance':
        return PaymentType.maintenance;
      case 'utility':
      case 'utilities':
        return PaymentType.utility;
      case 'other':
        return PaymentType.other;
      default:
        return PaymentType.other;
    }
  }

  static PaymentStatus _parsePaymentStatus(String? statusString) {
    if (statusString == null) return PaymentStatus.pending;

    switch (statusString.toLowerCase()) {
      case 'pending':
        return PaymentStatus.pending;
      case 'paid':
        return PaymentStatus.paid;
      case 'completed':
        return PaymentStatus.completed;
      case 'overdue':
        return PaymentStatus.overdue;
      case 'partial':
        return PaymentStatus.partial;
      case 'partiallypaid':
      case 'partially_paid':
        return PaymentStatus.partiallyPaid;
      case 'cancelled':
        return PaymentStatus.cancelled;
      default:
        return PaymentStatus.pending;
    }
  }

  factory PaymentModel.fromJson(String source) {
    return PaymentModel.fromMap(json.decode(source));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'leaseId': leaseId,
      'tenantId': tenantId,
      'propertyId': propertyId,
      'type': type.name,
      'status': status.name,
      'amount': amount,
      'paidAmount': paidAmount,
      'lateFee': lateFee,
      'dueDate': dueDate.toIso8601String(),
      'paidDate': paidDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'description': description,
      'reference': reference,
      'paymentMethod': paymentMethod,
    };
  }

  String toJson() => json.encode(toMap());

  // Database table creation
  static const String tableName = 'payments';

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      id TEXT PRIMARY KEY,
      leaseId TEXT NOT NULL,
      tenantId TEXT NOT NULL,
      propertyId TEXT NOT NULL,
      type TEXT NOT NULL,
      status TEXT NOT NULL,
      amount REAL NOT NULL,
      paidAmount REAL NOT NULL DEFAULT 0.0,
      lateFee REAL NOT NULL DEFAULT 0.0,
      dueDate TEXT NOT NULL,
      paidDate TEXT,
      createdAt TEXT NOT NULL,
      updatedAt TEXT NOT NULL,
      description TEXT,
      reference TEXT,
      paymentMethod TEXT,
      FOREIGN KEY (leaseId) REFERENCES leases (id),
      FOREIGN KEY (tenantId) REFERENCES tenants (id),
      FOREIGN KEY (propertyId) REFERENCES properties (id)
    )
  ''';

  @override
  PaymentModel copyWith({
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
    return PaymentModel(
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
}

// Helper class for payment calculations and business rules
class PaymentBusinessRules {
  static const double defaultLateFeePercentage = 5.0; // 5%
  static const double defaultMaximumLateFee = 100.0; // $100 max
  static const int defaultGracePeriodDays = 5;

  /// Calculate late fee based on business rules
  static double calculateLateFee({
    required double rentAmount,
    required int daysOverdue,
    double lateFeePercentage = defaultLateFeePercentage,
    double maximumLateFee = defaultMaximumLateFee,
    int gracePeriodDays = defaultGracePeriodDays,
  }) {
    if (daysOverdue <= gracePeriodDays) return 0.0;

    final calculatedFee = rentAmount * (lateFeePercentage / 100);
    return calculatedFee > maximumLateFee ? maximumLateFee : calculatedFee;
  }

  /// Update payment status based on current state
  static PaymentStatus updatePaymentStatus({
    required double amount,
    required double paidAmount,
    required double lateFee,
    required DateTime dueDate,
  }) {
    final totalDue = amount + lateFee;

    if (paidAmount >= totalDue) {
      return PaymentStatus.completed;
    }

    if (paidAmount > 0 && paidAmount < totalDue) {
      return DateTime.now().isAfter(dueDate)
          ? PaymentStatus.overdue
          : PaymentStatus.partiallyPaid;
    }

    return DateTime.now().isAfter(dueDate)
        ? PaymentStatus.overdue
        : PaymentStatus.pending;
  }

  /// Generate payment reference number
  static String generatePaymentReference({
    required String propertyId,
    required PaymentType type,
  }) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final typeCode = type.name.substring(0, 3).toUpperCase();
    final propCode =
        propertyId.length >= 4
            ? propertyId.substring(0, 4).toUpperCase()
            : propertyId.toUpperCase().padRight(4, 'X');
    return '$propCode-$typeCode-${timestamp.substring(timestamp.length - 6)}';
  }
}
