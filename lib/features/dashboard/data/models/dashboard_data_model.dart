// Dashboard Data Models

class DashboardData {
  final SummaryData summaryData;
  final List<FinancialDataPoint> financialData;
  final PaymentStatusData paymentStatusData;
  final OccupancyData occupancyData;
  final List<RecentActivity> recentActivities;

  DashboardData({
    required this.summaryData,
    required this.financialData,
    required this.paymentStatusData,
    required this.occupancyData,
    required this.recentActivities,
  });
}

class SummaryData {
  final int totalProperties;
  final int totalTenants;
  final int activeLeases;
  final double monthlyRevenue;
  final double totalRevenue;
  final double outstandingPayments;
  final double occupancyRate;
  final int maintenanceRequests;

  SummaryData({
    required this.totalProperties,
    required this.totalTenants,
    required this.activeLeases,
    required this.monthlyRevenue,
    required this.totalRevenue,
    required this.outstandingPayments,
    required this.occupancyRate,
    required this.maintenanceRequests,
  });

  factory SummaryData.empty() => SummaryData(
    totalProperties: 0,
    totalTenants: 0,
    activeLeases: 0,
    monthlyRevenue: 0.0,
    totalRevenue: 0.0,
    outstandingPayments: 0.0,
    occupancyRate: 0.0,
    maintenanceRequests: 0,
  );
}

class FinancialDataPoint {
  final String month;
  final double income;
  final double expenses;
  final double netIncome;

  FinancialDataPoint({
    required this.month,
    required this.income,
    required this.expenses,
    required this.netIncome,
  });

  factory FinancialDataPoint.fromJson(Map<String, dynamic> json) {
    return FinancialDataPoint(
      month: json['month'],
      income: json['income']?.toDouble() ?? 0.0,
      expenses: json['expenses']?.toDouble() ?? 0.0,
      netIncome: json['netIncome']?.toDouble() ?? 0.0,
    );
  }
}

class PaymentStatusData {
  final int onTimePayments;
  final int latePayments;
  final int pendingPayments;
  final int overduePayments;

  PaymentStatusData({
    required this.onTimePayments,
    required this.latePayments,
    required this.pendingPayments,
    required this.overduePayments,
  });

  factory PaymentStatusData.empty() => PaymentStatusData(
    onTimePayments: 0,
    latePayments: 0,
    pendingPayments: 0,
    overduePayments: 0,
  );

  int get totalPayments =>
      onTimePayments + latePayments + pendingPayments + overduePayments;
}

class OccupancyData {
  final int occupiedUnits;
  final int vacantUnits;
  final int maintenanceUnits;
  final List<PropertyOccupancy> propertyBreakdown;

  OccupancyData({
    required this.occupiedUnits,
    required this.vacantUnits,
    required this.maintenanceUnits,
    required this.propertyBreakdown,
  });

  factory OccupancyData.empty() => OccupancyData(
    occupiedUnits: 0,
    vacantUnits: 0,
    maintenanceUnits: 0,
    propertyBreakdown: [],
  );

  int get totalUnits => occupiedUnits + vacantUnits + maintenanceUnits;

  double get occupancyRate =>
      totalUnits > 0 ? (occupiedUnits / totalUnits) * 100 : 0.0;
}

class PropertyOccupancy {
  final String propertyId;
  final String propertyName;
  final int totalUnits;
  final int occupiedUnits;
  final double revenue;

  PropertyOccupancy({
    required this.propertyId,
    required this.propertyName,
    required this.totalUnits,
    required this.occupiedUnits,
    required this.revenue,
  });

  double get occupancyRate =>
      totalUnits > 0 ? (occupiedUnits / totalUnits) * 100 : 0.0;
}

class RecentActivity {
  final String id;
  final String type;
  final String title;
  final String description;
  final DateTime timestamp;
  final String? propertyName;
  final String? tenantName;
  final double? amount;
  final ActivityStatus status;

  RecentActivity({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    this.propertyName,
    this.tenantName,
    this.amount,
    required this.status,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
      propertyName: json['propertyName'],
      tenantName: json['tenantName'],
      amount: json['amount']?.toDouble(),
      status: ActivityStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ActivityStatus.info,
      ),
    );
  }
}

enum ActivityStatus { success, warning, error, info }

// Chart Data Models
class ChartDataPoint {
  final String label;
  final double value;
  final String? category;

  ChartDataPoint({required this.label, required this.value, this.category});
}

class MonthlyFinancialSummary {
  final String period;
  final double totalIncome;
  final double totalExpenses;
  final double netIncome;
  final double occupancyRate;
  final int newTenants;
  final int leasesExpired;

  MonthlyFinancialSummary({
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
}
