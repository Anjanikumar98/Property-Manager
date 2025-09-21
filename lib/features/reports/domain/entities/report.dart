// features/reports/domain/entities/report.dart
import 'package:property_manager/features/payments/domain/entities/payment.dart';

class Report {
  final String id;
  final String title;
  final ReportType type;
  final Map<String, dynamic> data;
  final ReportFilters filters;
  final DateTime generatedAt;
  final String generatedBy;

  const Report({
    required this.id,
    required this.title,
    required this.type,
    required this.data,
    required this.filters,
    required this.generatedAt,
    required this.generatedBy,
  });
}

enum ReportType {
  income,
  expense,
  occupancy,
  paymentCollection,
  comprehensive,
  custom,
}

class ReportFilters {
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String>? propertyIds;
  final List<String>? tenantIds;
  final PaymentStatus? paymentStatus;
  final String? category;

  const ReportFilters({
    this.startDate,
    this.endDate,
    this.propertyIds,
    this.tenantIds,
    this.paymentStatus,
    this.category,
  });

  ReportFilters copyWith({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? propertyIds,
    List<String>? tenantIds,
    PaymentStatus? paymentStatus,
    String? category,
  }) {
    return ReportFilters(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      propertyIds: propertyIds ?? this.propertyIds,
      tenantIds: tenantIds ?? this.tenantIds,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      category: category ?? this.category,
    );
  }
}

class IncomeReport {
  final double totalIncome;
  final double rentIncome;
  final double otherIncome;
  final List<MonthlyIncomeData> monthlyData;
  final List<PropertyIncomeData> propertyBreakdown;
  final num averageMonthlyIncome;
  final double growthRate;

  const IncomeReport({
    required this.totalIncome,
    required this.rentIncome,
    required this.otherIncome,
    required this.monthlyData,
    required this.propertyBreakdown,
    required this.averageMonthlyIncome,
    required this.growthRate,
  });
}

class ExpenseReport {
  final double totalExpenses;
  final Map<String, double> categoryBreakdown;
  final List<MonthlyExpenseData> monthlyData;
  final List<PropertyExpenseData> propertyBreakdown;
  final double averageMonthlyExpense;
  final String topExpenseCategory;

  const ExpenseReport({
    required this.totalExpenses,
    required this.categoryBreakdown,
    required this.monthlyData,
    required this.propertyBreakdown,
    required this.averageMonthlyExpense,
    required this.topExpenseCategory,
  });
}

class OccupancyReport {
  final double currentOccupancyRate;
  final double averageOccupancyRate;
  final List<OccupancyTrendData> trendData;
  final List<PropertyOccupancyData> propertyBreakdown;
  final int totalUnits;
  final int occupiedUnits;
  final int vacantUnits;
  final double averageLeaseLength;

  const OccupancyReport({
    required this.currentOccupancyRate,
    required this.averageOccupancyRate,
    required this.trendData,
    required this.propertyBreakdown,
    required this.totalUnits,
    required this.occupiedUnits,
    required this.vacantUnits,
    required this.averageLeaseLength,
  });
}

class PaymentCollectionReport {
  final double collectionRate;
  final double totalExpected;
  final double totalCollected;
  final double totalOutstanding;
  final List<MonthlyCollectionData> monthlyData;
  final List<TenantPaymentData> tenantBreakdown;
  final int onTimePayments;
  final int latePayments;
  final int missedPayments;

  const PaymentCollectionReport({
    required this.collectionRate,
    required this.totalExpected,
    required this.totalCollected,
    required this.totalOutstanding,
    required this.monthlyData,
    required this.tenantBreakdown,
    required this.onTimePayments,
    required this.latePayments,
    required this.missedPayments,
  });
}

// Supporting data classes
class MonthlyIncomeData {
  final DateTime month;
  final double amount;
  final double rentAmount;
  final double otherAmount;

  const MonthlyIncomeData({
    required this.month,
    required this.amount,
    required this.rentAmount,
    required this.otherAmount,
  });
}

class PropertyIncomeData {
  final String propertyId;
  final String propertyName;
  final double totalIncome;
  final double rentIncome;
  final double otherIncome;
  final int units;

  const PropertyIncomeData({
    required this.propertyId,
    required this.propertyName,
    required this.totalIncome,
    required this.rentIncome,
    required this.otherIncome,
    required this.units,
  });
}

class MonthlyExpenseData {
  final DateTime month;
  final double amount;
  final Map<String, double> categoryBreakdown;

  const MonthlyExpenseData({
    required this.month,
    required this.amount,
    required this.categoryBreakdown,
  });
}

class PropertyExpenseData {
  final String propertyId;
  final String propertyName;
  final double totalExpense;
  final Map<String, double> categoryBreakdown;

  const PropertyExpenseData({
    required this.propertyId,
    required this.propertyName,
    required this.totalExpense,
    required this.categoryBreakdown,
  });
}

class OccupancyTrendData {
  final DateTime date;
  final double occupancyRate;
  final int totalUnits;
  final int occupiedUnits;

  const OccupancyTrendData({
    required this.date,
    required this.occupancyRate,
    required this.totalUnits,
    required this.occupiedUnits,
  });
}

class PropertyOccupancyData {
  final String propertyId;
  final String propertyName;
  final int totalUnits;
  final int occupiedUnits;
  final double occupancyRate;
  final double averageRent;

  const PropertyOccupancyData({
    required this.propertyId,
    required this.propertyName,
    required this.totalUnits,
    required this.occupiedUnits,
    required this.occupancyRate,
    required this.averageRent,
  });
}

class MonthlyCollectionData {
  final DateTime month;
  final double expected;
  final double collected;
  final double outstanding;
  final double collectionRate;

  const MonthlyCollectionData({
    required this.month,
    required this.expected,
    required this.collected,
    required this.outstanding,
    required this.collectionRate,
  });
}

class TenantPaymentData {
  final String tenantId;
  final String tenantName;
  final double totalExpected;
  final double totalPaid;
  final double outstanding;
  final double paymentRate;
  final int onTimePayments;
  final int latePayments;

  const TenantPaymentData({
    required this.tenantId,
    required this.tenantName,
    required this.totalExpected,
    required this.totalPaid,
    required this.outstanding,
    required this.paymentRate,
    required this.onTimePayments,
    required this.latePayments,
  });
}
