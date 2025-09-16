// lib/features/dashboard/presentation/bloc/dashboard_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:property_manager/features/dashboard/data/models/dashboard_data_model.dart';
import 'package:property_manager/features/dashboard/presentation/widgets/occupancy_overview.dart';
import 'package:property_manager/features/dashboard/presentation/widgets/payment_status_chart.dart';
import 'package:property_manager/features/dashboard/presentation/widgets/recent_activities.dart';
import 'package:property_manager/features/leases/domain/entities/lease.dart';
import 'package:property_manager/features/properties/domain/entities/property.dart';
import 'package:property_manager/features/properties/domain/repositories/property_repository.dart';
import 'package:property_manager/features/leases/domain/repositories/lease_repository.dart';
import 'package:property_manager/features/tenants/domain/entities/tenant.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final PropertyRepository propertyRepository;
  final LeaseRepository leaseRepository;
  // final PaymentRepository paymentRepository;
  // final TenantRepository tenantRepository;

  DashboardBloc({
    required this.propertyRepository,
    required this.leaseRepository,
    // required this.paymentRepository,
    // required this.tenantRepository,
  }) : super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
    on<RefreshDashboardData>(_onRefreshDashboardData);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final dashboardData = await _fetchDashboardData();
      emit(DashboardLoaded(data: dashboardData));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  Future<void> _onRefreshDashboardData(
    RefreshDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    // Keep current data visible during refresh
    final currentState = state;
    if (currentState is DashboardLoaded) {
      emit(DashboardRefreshing(currentData: currentState.data));
    }

    try {
      final dashboardData = await _fetchDashboardData();
      emit(DashboardLoaded(data: dashboardData));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  Future<DashboardData> _fetchDashboardData() async {
    try {
      // Fetch all required data
      final propertiesResult = await propertyRepository.getProperties(
        "owner_id",
      );
      final leasesResult = await leaseRepository.getLeases();

      // Unwrap results
      final properties = propertiesResult.fold<List<Property>>(
        (failure) => [], // handle error case if needed
        (data) => data,
      );

      final leases = leasesResult.fold<List<Lease>>(
        (failure) => [], // handle error case if needed
        (data) => data,
      );

      final totalProperties = properties.length;
      final activeLeases =
          leases.where((lease) => lease.status == LeaseStatus.active).length;
      final vacantProperties = totalProperties - activeLeases;

      // ✅ Define totalTenants (mock for now, until tenantRepository is used)
      final totalTenants = 0;
      // final tenantsResult = await tenantRepository.getTenants();
      // final tenants = tenantsResult.fold<List<Tenant>>((_) => [], (data) => data);
      // final totalTenants = tenants.length;

      // Calculate occupancy data
      final occupancyData = _calculateOccupancyData(properties, leases);

      // Generate payment status data (mock for now)
      final paymentStatusData = _generateMockPaymentStatusData();

      // Generate recent activities
      final recentActivities = _generateRecentActivities(leases, properties);

      // Calculate summary data
      final summaryData = SummaryData(
        totalProperties: totalProperties,
        totalTenants: totalTenants,
        activeLeases: activeLeases,
        monthlyRevenue: _calculateMonthlyRevenue(), // Replace with actual logic
        totalRevenue: _calculateTotalRevenue(), // Replace with actual logic
        outstandingPayments: 0.0, // Mock for now
        occupancyRate: occupancyData.occupancyRate,
        maintenanceRequests: 0, // Mock for now
      );

      // Generate financial data points (mock for now)
      final financialData = _generateFinancialDataPoints();

      return DashboardData(
        summaryData: summaryData,
        financialData: financialData,
        paymentStatusData: paymentStatusData,
        occupancyData: occupancyData,
        recentActivities: recentActivities,
      );
    } catch (e) {
      throw Exception('Failed to fetch dashboard data: $e');
    }
  }

  OccupancyData _calculateOccupancyData(properties, leases) {
    int totalUnits = 0;
    int occupiedUnits = 0;
    List<PropertyOccupancy> propertyBreakdown = [];

    for (var property in properties) {
      // Assuming property has units field
      int propertyUnits = property.units ?? 1;
      totalUnits += propertyUnits;

      // Count occupied units for this property
      int propertyOccupied =
          leases
              .where(
                (lease) =>
                    lease.propertyId == property.id && lease.status == 'active',
              )
              .length;

      occupiedUnits += propertyOccupied;

      // Add to property breakdown
      propertyBreakdown.add(
        PropertyOccupancy(
          propertyId: property.id,
          propertyName: property.name ?? 'Unknown Property',
          totalUnits: propertyUnits,
          occupiedUnits: propertyOccupied,
          revenue: _calculatePropertyRevenue(property.id), // Mock calculation
        ),
      );
    }

    return OccupancyData(
      occupiedUnits: occupiedUnits,
      vacantUnits: totalUnits - occupiedUnits,
      maintenanceUnits: 0, // Mock for now
      propertyBreakdown: propertyBreakdown,
    );
  }

  PaymentStatusData _generateMockPaymentStatusData() {
    // TODO: Replace with actual payment data calculation
    return PaymentStatusData(
      onTimePayments: 15,
      latePayments: 3,
      pendingPayments: 2,
      overduePayments: 1,
    );
  }

  List<RecentActivity> _generateRecentActivities(leases, properties) {
    List<RecentActivity> activities = [];

    // Add recent lease activities
    final recentLeases = leases
        .where(
          (lease) =>
              DateTime.now()
                  .difference(lease.createdAt ?? DateTime.now())
                  .inDays <=
              30,
        )
        .take(5);

    for (var lease in recentLeases) {
      activities.add(
        RecentActivity(
          id: lease.id,
          type: 'lease',
          title: 'New Lease Created',
          description: 'Lease agreement signed',
          timestamp: lease.createdAt ?? DateTime.now(),
          status: ActivityStatus.success,
          propertyName: _getPropertyName(lease.propertyId, properties),
          tenantName: lease.tenantName,
        ),
      );
    }

    // Add mock payment activities
    activities.addAll(_generateMockPaymentActivities());

    // Sort by timestamp (most recent first)
    activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return activities.take(10).toList();
  }

  List<RecentActivity> _generateMockPaymentActivities() {
    final now = DateTime.now();
    return [
      RecentActivity(
        id: 'payment_1',
        type: 'payment',
        title: 'Payment Received',
        description: 'Monthly rent payment',
        timestamp: now.subtract(const Duration(hours: 2)),
        status: ActivityStatus.success,
        amount: 25000.0,
        propertyName: 'Sunrise Apartments',
        tenantName: 'John Doe',
      ),
      RecentActivity(
        id: 'payment_2',
        type: 'payment',
        title: 'Payment Overdue',
        description: 'Rent payment is 5 days overdue',
        timestamp: now.subtract(const Duration(days: 1)),
        status: ActivityStatus.error,
        amount: 30000.0,
        propertyName: 'Green Valley',
        tenantName: 'Jane Smith',
      ),
    ];
  }

  List<FinancialDataPoint> _generateFinancialDataPoints() {
    final now = DateTime.now();
    return List.generate(6, (index) {
      final month = DateTime(now.year, now.month - index, 1);
      final income = 150000.0 + (index * 10000); // Mock data
      final expenses = 50000.0 + (index * 3000); // Mock data

      return FinancialDataPoint(
        month: _formatMonth(month),
        income: income,
        expenses: expenses,
        netIncome: income - expenses,
      );
    }).reversed.toList();
  }

  String _formatMonth(DateTime date) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month]} ${date.year}';
  }

  double _calculateMonthlyRevenue() {
    // TODO: Calculate from actual payment data
    return 185000.0; // Mock value
  }

  double _calculateTotalRevenue() {
    // TODO: Calculate from actual payment data
    return 2250000.0; // Mock value
  }

  double _calculatePropertyRevenue(String propertyId) {
    // TODO: Calculate from actual payment data
    return 75000.0; // Mock value
  }

  String? _getPropertyName(String? propertyId, properties) {
    if (propertyId == null) return null;
    try {
      final property = properties.firstWhere((p) => p.id == propertyId);
      return property.name;
    } catch (e) {
      return 'Unknown Property';
    }
  }
}
