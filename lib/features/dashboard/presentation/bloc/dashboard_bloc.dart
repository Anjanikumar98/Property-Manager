// lib/features/dashboard/presentation/bloc/dashboard_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:property_manager/features/properties/domain/repositories/property_repository.dart';
import 'package:property_manager/features/leases/domain/repositories/lease_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final PropertyRepository propertyRepository;
  final LeaseRepository leaseRepository;
 // final PaymentRepository paymentRepository;
 //  final TenantRepository tenantRepository;

  DashboardBloc({
    required this.propertyRepository,
    required this.leaseRepository,
   //  required this.paymentRepository,
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
   //   final dashboardData = await _fetchDashboardData();
    //  emit(DashboardLoaded(data: dashboardData));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  Future<void> _onRefreshDashboardData(
    RefreshDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    try {
//      final dashboardData = await _fetchDashboardData();
 //     emit(DashboardLoaded(data: dashboardData));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

 //  Future<DashboardData> _fetchDashboardData() async {
 //    // Fetch all required data
 //    final properties = await propertyRepository.getProperties(
 //      DatabaseConstants.propertyOwnerId,
 //    ); // need to update
 //    final leases = await leaseRepository.getLeases();
 // //   final payments = await paymentRepository.getPayments();
 // //   final tenants = await tenantRepository.getTenants();
 //
 //    // Calculate metrics
 //    final totalProperties = properties.length();
 //    final activeLeases =
 //        leases.where((lease) => lease.status == 'active').length;
 //    final vacantProperties = totalProperties - activeLeases;
 //
 //    final currentMonth = DateTime.now();
 //    // final monthlyRevenue = payments
 //    //     .where(
 //    //       (payment) =>
 //    //           payment.paymentDate.month == currentMonth.month &&
 //    //           payment.paymentDate.year == currentMonth.year,
 //    //     )
 //    //     .fold(0.0, (sum, payment) => sum + payment.amount);
 //
 //    // final totalRevenue = payments.fold(
 //    //   0.0,
 //    //   (sum, payment) => sum + payment.amount,
 //    // );
 //    final occupancyRate =
 //        totalProperties > 0 ? (activeLeases / totalProperties) * 100 : 0.0;
 //
 //    // Generate recent activities
 //    // final recentActivities = _generateRecentActivities(
 //    //   payments,
 //    //   leases,
 //    //   properties,
 //    // );
 //
 //    // Generate payment overview
 //   // final paymentOverview = _generatePaymentOverview(payments);
 //
 //    return DashboardData(
 //      totalProperties: totalProperties,
 //      activeLeases: activeLeases,
 //      vacantProperties: vacantProperties,
 //      monthlyRevenue: monthlyRevenue,
 //      totalRevenue: totalRevenue,
 //      occupancyRate: occupancyRate,
 //      recentActivities: recentActivities,
 //      paymentOverview: paymentOverview,
 //    );
 //  }

  List<RecentActivity> _generateRecentActivities(payments, leases, properties) {
    List<RecentActivity> activities = [];

    // Add recent payments
    final recentPayments = payments
        .where(
          (payment) =>
              DateTime.now().difference(payment.paymentDate).inDays <= 7,
        )
        .take(5);

    for (var payment in recentPayments) {
      activities.add(
        RecentActivity(
          id: payment.id,
          title: 'Payment Received',
          description: 'Rent payment of ₹${payment.amount.toStringAsFixed(0)}',
          timestamp: payment.paymentDate,
          type: ActivityType.payment,
        ),
      );
    }

    // Add recent leases
    final recentLeases = leases
        .where(
          (lease) => DateTime.now().difference(lease.startDate).inDays <= 30,
        )
        .take(3);

    for (var lease in recentLeases) {
      activities.add(
        RecentActivity(
          id: lease.id,
          title: 'New Lease Created',
          description: 'Lease agreement signed',
          timestamp: lease.startDate,
          type: ActivityType.lease,
        ),
      );
    }

    // Sort by timestamp (most recent first)
    activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return activities.take(10).toList();
  }

  List<PaymentStatus> _generatePaymentOverview(payments) {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);

    final paidPayments =
        payments
            .where(
              (p) => p.paymentDate.isAfter(currentMonth) && p.status == 'paid',
            )
            .toList();
    final pendingPayments =
        payments.where((p) => p.status == 'pending').toList();
    final overduePayments =
        payments
            .where(
              (p) =>
                  p.status == 'overdue' ||
                  (p.status == 'pending' && p.dueDate.isBefore(now)),
            )
            .toList();

    return [
      PaymentStatus(
        status: 'Paid',
        count: paidPayments.length,
        amount: paidPayments.fold(0.0, (sum, p) => sum + p.amount),
      ),
      PaymentStatus(
        status: 'Pending',
        count: pendingPayments.length,
        amount: pendingPayments.fold(0.0, (sum, p) => sum + p.amount),
      ),
      PaymentStatus(
        status: 'Overdue',
        count: overduePayments.length,
        amount: overduePayments.fold(0.0, (sum, p) => sum + p.amount),
      ),
    ];
  }
}
