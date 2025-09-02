// lib/features/tenants/presentation/bloc/tenant_event.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/tenant.dart';

abstract class TenantEvent extends Equatable {
  const TenantEvent();

  @override
  List<Object?> get props => [];
}

class LoadTenants extends TenantEvent {}

// Renamed to avoid conflict with SearchTenants use case
class SearchTenantsEvent extends TenantEvent {
  final String query;

  const SearchTenantsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterTenants extends TenantEvent {
  final bool? isActive;
  final String? propertyId;

  const FilterTenants({this.isActive, this.propertyId});

  @override
  List<Object?> get props => [isActive, propertyId];
}

// Renamed to avoid conflict with AddTenant use case
class AddTenantEvent extends TenantEvent {
  final Tenant tenant;

  const AddTenantEvent(this.tenant);

  @override
  List<Object?> get props => [tenant];
}

// Renamed to avoid conflict with UpdateTenant use case
class UpdateTenantEvent extends TenantEvent {
  final Tenant tenant;

  const UpdateTenantEvent(this.tenant);

  @override
  List<Object?> get props => [tenant];
}

// Renamed to avoid conflict with DeleteTenant use case
class DeleteTenantEvent extends TenantEvent {
  final String tenantId;

  const DeleteTenantEvent(this.tenantId);

  @override
  List<Object?> get props => [tenantId];
}

class ActivateTenant extends TenantEvent {
  final String tenantId;

  const ActivateTenant(this.tenantId);

  @override
  List<Object?> get props => [tenantId];
}

class DeactivateTenant extends TenantEvent {
  final String tenantId;

  const DeactivateTenant(this.tenantId);

  @override
  List<Object?> get props => [tenantId];
}

