// lib/features/tenants/presentation/bloc/tenant_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:property_manager/features/auth/domain/usecases/login_user.dart';
import 'package:property_manager/features/tenants/domain/usecases/search_tenant.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/tenant.dart';
import '../../domain/usecases/add_tenant.dart';
import '../../domain/usecases/get_tenants.dart';
import '../../domain/usecases/update_tenant.dart';
import '../../domain/usecases/delete_tenant.dart';
import 'tenant_event.dart';
import 'tenant_state.dart';

class TenantBloc extends Bloc<TenantEvent, TenantState> {
  final GetTenants getTenants;
  final AddTenant addTenant;
  final UpdateTenant updateTenant;
  final DeleteTenant deleteTenant;
  final SearchTenants searchTenants;

  TenantBloc({
    required this.getTenants,
    required this.addTenant,
    required this.updateTenant,
    required this.deleteTenant,
    required this.searchTenants,
  }) : super(TenantInitial()) {
    on<LoadTenants>(_onLoadTenants);
    on<SearchTenantsEvent>(_onSearchTenants);
    on<FilterTenants>(_onFilterTenants);
    on<AddTenantEvent>(_onAddTenant);
    on<UpdateTenantEvent>(_onUpdateTenant);
    on<DeleteTenantEvent>(_onDeleteTenant);
    on<ActivateTenant>(_onActivateTenant);
    on<DeactivateTenant>(_onDeactivateTenant);
  }

  void _onLoadTenants(LoadTenants event, Emitter<TenantState> emit) async {
    emit(TenantLoading());

    final failureOrTenants = await getTenants(NoParams());

    failureOrTenants.fold(
      (failure) => emit(TenantError(_mapFailureToMessage(failure))),
      (tenants) =>
          emit(TenantLoaded(tenants: tenants, filteredTenants: tenants)),
    );
  }

  void _onSearchTenants(
    SearchTenantsEvent event,
    Emitter<TenantState> emit,
  ) async {
    if (state is TenantLoaded) {
      final currentState = state as TenantLoaded;

      if (event.query.isEmpty) {
        emit(
          currentState.copyWith(
            filteredTenants: currentState.tenants,
            searchQuery: '',
          ),
        );
        return;
      }

      final filteredTenants =
          currentState.tenants.where((tenant) {
            final query = event.query.toLowerCase();
            return tenant.fullName.toLowerCase().contains(query) ||
                tenant.email.toLowerCase().contains(query) ||
                tenant.phone.contains(query);
          }).toList();

      emit(
        currentState.copyWith(
          filteredTenants: filteredTenants,
          searchQuery: event.query,
        ),
      );
    }
  }

  void _onFilterTenants(FilterTenants event, Emitter<TenantState> emit) {
    if (state is TenantLoaded) {
      final currentState = state as TenantLoaded;

      List<Tenant> filteredTenants = currentState.tenants;

      // Apply active/inactive filter
      if (event.isActive != null) {
        filteredTenants =
            filteredTenants
                .where((tenant) => tenant.isActive == event.isActive)
                .toList();
      }

      // Apply property filter
      if (event.propertyId != null) {
        filteredTenants =
            filteredTenants
                .where(
                  (tenant) => tenant.propertyIds.contains(event.propertyId),
                )
                .toList();
      }

      emit(
        currentState.copyWith(
          filteredTenants: filteredTenants,
          activeFilter: event.isActive,
          propertyFilter: event.propertyId,
        ),
      );
    }
  }

  void _onAddTenant(AddTenantEvent event, Emitter<TenantState> emit) async {
    emit(TenantLoading());

    final failureOrTenant = await addTenant(
      AddTenantParams(tenant: event.tenant),
    );

    failureOrTenant.fold(
      (failure) => emit(TenantError(_mapFailureToMessage(failure))),
      (tenant) async {
        // Reload tenants list
        final failureOrTenants = await getTenants(NoParams());
        failureOrTenants.fold(
          (failure) => emit(TenantError(_mapFailureToMessage(failure))),
          (tenants) => emit(
            TenantOperationSuccess(
              message: 'Tenant added successfully',
              tenants: tenants,
            ),
          ),
        );
      },
    );
  }

  void _onUpdateTenant(
    UpdateTenantEvent event,
    Emitter<TenantState> emit,
  ) async {
    emit(TenantLoading());

    final failureOrTenant = await updateTenant(
      UpdateTenantParams(tenant: event.tenant),
    );

    failureOrTenant.fold(
      (failure) => emit(TenantError(_mapFailureToMessage(failure))),
      (tenant) async {
        // Reload tenants list
        final failureOrTenants = await getTenants(NoParams());
        failureOrTenants.fold(
          (failure) => emit(TenantError(_mapFailureToMessage(failure))),
          (tenants) => emit(
            TenantOperationSuccess(
              message: 'Tenant updated successfully',
              tenants: tenants,
            ),
          ),
        );
      },
    );
  }

  void _onDeleteTenant(
    DeleteTenantEvent event,
    Emitter<TenantState> emit,
  ) async {
    emit(TenantLoading());

    final failureOrSuccess = await deleteTenant(
      DeleteTenantParams(id: event.tenantId),
    );

    failureOrSuccess.fold(
      (failure) => emit(TenantError(_mapFailureToMessage(failure))),
      (_) async {
        // Reload tenants list
        final failureOrTenants = await getTenants(NoParams());
        failureOrTenants.fold(
          (failure) => emit(TenantError(_mapFailureToMessage(failure))),
          (tenants) => emit(
            TenantOperationSuccess(
              message: 'Tenant deleted successfully',
              tenants: tenants,
            ),
          ),
        );
      },
    );
  }

  void _onActivateTenant(
    ActivateTenant event,
    Emitter<TenantState> emit,
  ) async {
    if (state is TenantLoaded) {
      final currentState = state as TenantLoaded;
      final tenant = currentState.tenants.firstWhere(
        (t) => t.id == event.tenantId,
      );

      final updatedTenant = tenant.copyWith(isActive: true);
      add(UpdateTenantEvent(updatedTenant));
    }
  }

  void _onDeactivateTenant(
    DeactivateTenant event,
    Emitter<TenantState> emit,
  ) async {
    if (state is TenantLoaded) {
      final currentState = state as TenantLoaded;
      final tenant = currentState.tenants.firstWhere(
        (t) => t.id == event.tenantId,
      );

      final updatedTenant = tenant.copyWith(isActive: false);
      add(UpdateTenantEvent(updatedTenant));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred';
      case CacheFailure:
        return 'Cache error occurred';
      case NetworkFailure:
        return 'Network error occurred';
      default:
        return 'Unexpected error occurred';
    }
  }
}
