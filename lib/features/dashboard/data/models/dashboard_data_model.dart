// lib/features/dashboard/domain/models/dashboard_data_model.dart
import 'package:equatable/equatable.dart';
import 'package:property_manager/features/dashboard/presentation/widgets/occupancy_overview.dart';
import 'package:property_manager/features/dashboard/presentation/widgets/payment_status_chart.dart';
import 'package:property_manager/features/dashboard/presentation/widgets/recent_activities.dart';

class DashboardData extends Equatable {
  final SummaryData summaryData;
  final List<FinancialDataPoint> financialData;
  final PaymentStatusData paymentStatusData;
  final OccupancyData occupancyData;
  final List<RecentActivity> recentActivities;

  const DashboardData({
    required this.summaryData,
    required this.financialData,
    required this.paymentStatusData,
    required this.occupancyData,
    required this.recentActivities,
  });

  factory DashboardData.empty() => DashboardData(
    summaryData: SummaryData.empty(),
    financialData: const [],
    paymentStatusData: PaymentStatusData.empty(),
    occupancyData: OccupancyData.empty(),
    recentActivities: const [],
  );

  @override
  List<Object> get props => [
    summaryData,
    financialData,
    paymentStatusData,
    occupancyData,
    recentActivities,
  ];
}

class SummaryData extends Equatable {
  final int totalProperties;
  final int totalTenants;
  final int activeLeases;
  final double monthlyRevenue;
  final double totalRevenue;
  final double outstandingPayments;
  final double occupancyRate;
  final int maintenanceRequests;

  const SummaryData({
    required this.totalProperties,
    required this.totalTenants,
    required this.activeLeases,
    required this.monthlyRevenue,
    required this.totalRevenue,
    required this.outstandingPayments,
    required this.occupancyRate,
    required this.maintenanceRequests,
  });

  factory SummaryData.empty() => const SummaryData(
    totalProperties: 0,
    totalTenants: 0,
    activeLeases: 0,
    monthlyRevenue: 0.0,
    totalRevenue: 0.0,
    outstandingPayments: 0.0,
    occupancyRate: 0.0,
    maintenanceRequests: 0,
  );

  // Helper getter for dashboard display
  int get vacantProperties => totalProperties - activeLeases;

  @override
  List<Object> get props => [
    totalProperties,
    totalTenants,
    activeLeases,
    monthlyRevenue,
    totalRevenue,
    outstandingPayments,
    occupancyRate,
    maintenanceRequests,
  ];
}

class FinancialDataPoint extends Equatable {
  final String month;
  final double income;
  final double expenses;
  final double netIncome;

  const FinancialDataPoint({
    required this.month,
    required this.income,
    required this.expenses,
    required this.netIncome,
  });

  factory FinancialDataPoint.fromJson(Map<String, dynamic> json) {
    return FinancialDataPoint(
      month: json['month'] ?? '',
      income: (json['income'] ?? 0.0).toDouble(),
      expenses: (json['expenses'] ?? 0.0).toDouble(),
      netIncome: (json['netIncome'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'income': income,
      'expenses': expenses,
      'netIncome': netIncome,
    };
  }

  @override
  List<Object> get props => [month, income, expenses, netIncome];
}

// Chart Data Models
class ChartDataPoint extends Equatable {
  final String label;
  final double value;
  final String? category;

  const ChartDataPoint({
    required this.label,
    required this.value,
    this.category,
  });

  @override
  List<Object?> get props => [label, value, category];
}

class MonthlyFinancialSummary extends Equatable {
  final String period;
  final double totalIncome;
  final double totalExpenses;
  final double netIncome;
  final double occupancyRate;
  final int newTenants;
  final int leasesExpired;

  const MonthlyFinancialSummary({
    required this.period,
    required this.totalIncome,
    required this.totalExpenses,
    required this.netIncome,
    required this.occupancyRate,
    required this.newTenants,
    required this.leasesExpired,
  });

  double get profitMargin =>
      totalIncome > 0 ? (netIncome / totalIncome) * 100 : 0.0;

  @override
  List<Object> get props => [
    period,
    totalIncome,
    totalExpenses,
    netIncome,
    occupancyRate,
    newTenants,
    leasesExpired,
  ];
}
