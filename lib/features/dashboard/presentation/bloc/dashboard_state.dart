// lib/features/dashboard/presentation/bloc/dashboard_state.dart
import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardData data;

  const DashboardLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object?> get props => [message];
}

class DashboardData {
  final int totalProperties;
  final int activeLeases;
  final int vacantProperties;
  final double monthlyRevenue;
  final double totalRevenue;
  final double occupancyRate;
  final List<RecentActivity> recentActivities;
  final List<PaymentStatus> paymentOverview;

  DashboardData({
    required this.totalProperties,
    required this.activeLeases,
    required this.vacantProperties,
    required this.monthlyRevenue,
    required this.totalRevenue,
    required this.occupancyRate,
    required this.recentActivities,
    required this.paymentOverview,
  });
}

class RecentActivity {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final ActivityType type;

  RecentActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
  });
}

enum ActivityType { payment, lease, property, tenant }

class PaymentStatus {
  final String status;
  final int count;
  final double amount;

  PaymentStatus({
    required this.status,
    required this.count,
    required this.amount,
  });
}

