// lib/features/dashboard/presentation/bloc/dashboard_state.dart
import 'package:equatable/equatable.dart';
import 'package:property_manager/features/dashboard/data/models/dashboard_data_model.dart';

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

class DashboardRefreshing extends DashboardState {
  final DashboardData? currentData;

  const DashboardRefreshing({this.currentData});

  @override
  List<Object?> get props => [currentData];
}
