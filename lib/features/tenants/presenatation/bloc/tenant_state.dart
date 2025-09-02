// lib/features/tenants/presentation/bloc/tenant_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/tenant.dart';

abstract class TenantState extends Equatable {
  const TenantState();

  @override
  List<Object?> get props => [];
}

class TenantInitial extends TenantState {}

class TenantLoading extends TenantState {}

class TenantLoaded extends TenantState {
  final List<Tenant> tenants;
  final List<Tenant> filteredTenants;
  final String searchQuery;
  final bool? activeFilter;
  final String? propertyFilter;

  const TenantLoaded({
    required this.tenants,
    required this.filteredTenants,
    this.searchQuery = '',
    this.activeFilter,
    this.propertyFilter,
  });

  @override
  List<Object?> get props => [
    tenants,
    filteredTenants,
    searchQuery,
    activeFilter,
    propertyFilter,
  ];

  TenantLoaded copyWith({
    List<Tenant>? tenants,
    List<Tenant>? filteredTenants,
    String? searchQuery,
    bool? activeFilter,
    String? propertyFilter,
  }) {
    return TenantLoaded(
      tenants: tenants ?? this.tenants,
      filteredTenants: filteredTenants ?? this.filteredTenants,
      searchQuery: searchQuery ?? this.searchQuery,
      activeFilter: activeFilter ?? this.activeFilter,
      propertyFilter: propertyFilter ?? this.propertyFilter,
    );
  }
}

class TenantError extends TenantState {
  final String message;

  const TenantError(this.message);

  @override
  List<Object?> get props => [message];
}

class TenantOperationSuccess extends TenantState {
  final String message;
  final List<Tenant> tenants;

  const TenantOperationSuccess({required this.message, required this.tenants});

  @override
  List<Object?> get props => [message, tenants];
}
