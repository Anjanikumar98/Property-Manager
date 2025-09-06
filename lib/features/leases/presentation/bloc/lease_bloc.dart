// lib/features/leases/presentation/bloc/lease_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:property_manager/features/leases/domain/entities/lease.dart';
import '../../domain/usecases/create_lease.dart';
import '../../domain/usecases/get_leases.dart';
import '../../domain/usecases/terminate_lease.dart';
import '../../domain/repositories/lease_repository.dart';
import 'lease_event.dart';
import 'lease_state.dart';

class LeaseBloc extends Bloc<LeaseEvent, LeaseState> {
  final CreateLease createLease;
  final GetLeases getLeases;
  final TerminateLease terminateLease;
  final LeaseRepository leaseRepository;

  LeaseBloc({
    required this.createLease,
    required this.getLeases,
    required this.terminateLease,
    required this.leaseRepository,
  }) : super(LeaseInitial()) {
    on<LoadLeasesEvent>(_onLoadLeases);
    on<CreateLeaseEvent>(_onCreateLease);
    on<UpdateLeaseEvent>(_onUpdateLease);
    on<DeleteLeaseEvent>(_onDeleteLease);
    on<TerminateLeaseEvent>(_onTerminateLease);
    on<RenewLeaseEvent>(_onRenewLease);
  }

  Future<void> _onLoadLeases(
    LoadLeasesEvent event,
    Emitter<LeaseState> emit,
  ) async {
    emit(LeaseLoading());

    try {
      // Execute all lease queries concurrently
      final results = await Future.wait([
        getLeases(const GetLeasesParams(filterType: LeaseFilterType.all)),
        getLeases(const GetLeasesParams(filterType: LeaseFilterType.active)),
        getLeases(const GetLeasesParams(filterType: LeaseFilterType.expiring)),
      ]);

      final allLeasesResult = results[0];
      final activeLeasesResult = results[1];
      final expiringLeasesResult = results[2];

      // Check if any requests failed and emit error for the first failure found
      if (allLeasesResult.isLeft()) {
        emit(
          LeaseError(
            allLeasesResult.fold((failure) => failure.message, (_) => ''),
          ),
        );
        return;
      }

      if (activeLeasesResult.isLeft()) {
        emit(
          LeaseError(
            activeLeasesResult.fold((failure) => failure.message, (_) => ''),
          ),
        );
        return;
      }

      if (expiringLeasesResult.isLeft()) {
        emit(
          LeaseError(
            expiringLeasesResult.fold((failure) => failure.message, (_) => ''),
          ),
        );
        return;
      }

      // All requests succeeded, extract the data
      final allLeases = allLeasesResult.fold(
        (_) => <Lease>[],
        (leases) => leases,
      );
      final activeLeases = activeLeasesResult.fold(
        (_) => <Lease>[],
        (leases) => leases,
      );
      final expiringLeases = expiringLeasesResult.fold(
        (_) => <Lease>[],
        (leases) => leases,
      );

      emit(
        LeaseLoaded(
          leases: allLeases,
          activeLeases: activeLeases,
          expiringLeases: expiringLeases,
        ),
      );
    } catch (e) {
      emit(LeaseError('Failed to load leases: ${e.toString()}'));
    }
  }

  // Alternative approach with better error handling
  Future<void> _onLoadLeasesAlternative(
    LoadLeasesEvent event,
    Emitter<LeaseState> emit,
  ) async {
    emit(LeaseLoading());

    try {
      // Load all leases
      final allLeasesResult = await getLeases(
        const GetLeasesParams(filterType: LeaseFilterType.all),
      );

      if (allLeasesResult.isLeft()) {
        emit(
          LeaseError(
            allLeasesResult.fold((failure) => failure.message, (_) => ''),
          ),
        );
        return;
      }

      // Load active leases
      final activeLeasesResult = await getLeases(
        const GetLeasesParams(filterType: LeaseFilterType.active),
      );

      if (activeLeasesResult.isLeft()) {
        emit(
          LeaseError(
            activeLeasesResult.fold((failure) => failure.message, (_) => ''),
          ),
        );
        return;
      }

      // Load expiring leases
      final expiringLeasesResult = await getLeases(
        const GetLeasesParams(filterType: LeaseFilterType.expiring),
      );

      if (expiringLeasesResult.isLeft()) {
        emit(
          LeaseError(
            expiringLeasesResult.fold((failure) => failure.message, (_) => ''),
          ),
        );
        return;
      }

      // Extract successful results
      final allLeases = allLeasesResult.getOrElse(() => <Lease>[]);
      final activeLeases = activeLeasesResult.getOrElse(() => <Lease>[]);
      final expiringLeases = expiringLeasesResult.getOrElse(() => <Lease>[]);

      emit(
        LeaseLoaded(
          leases: allLeases,
          activeLeases: activeLeases,
          expiringLeases: expiringLeases,
        ),
      );
    } catch (e) {
      emit(LeaseError('Failed to load leases: ${e.toString()}'));
    }
  }

  // Most concise approach using getOrElse
  Future<void> _onLoadLeasesConcise(
    LoadLeasesEvent event,
    Emitter<LeaseState> emit,
  ) async {
    emit(LeaseLoading());

    try {
      final results = await Future.wait([
        getLeases(const GetLeasesParams(filterType: LeaseFilterType.all)),
        getLeases(const GetLeasesParams(filterType: LeaseFilterType.active)),
        getLeases(const GetLeasesParams(filterType: LeaseFilterType.expiring)),
      ]);

      // Check for failures
      for (int i = 0; i < results.length; i++) {
        if (results[i].isLeft()) {
          final errorMessage = results[i].fold(
            (failure) => failure.message,
            (_) => 'Unknown error',
          );
          emit(LeaseError(errorMessage));
          return;
        }
      }

      emit(
        LeaseLoaded(
          leases: results[0].getOrElse(() => <Lease>[]),
          activeLeases: results[1].getOrElse(() => <Lease>[]),
          expiringLeases: results[2].getOrElse(() => <Lease>[]),
        ),
      );
    } catch (e) {
      emit(LeaseError('Failed to load leases: ${e.toString()}'));
    }
  }

  Future<void> _onCreateLease(
    CreateLeaseEvent event,
    Emitter<LeaseState> emit,
  ) async {
    emit(LeaseLoading());

    final result = await createLease(CreateLeaseParams(lease: event.lease));

    result.fold((failure) => emit(LeaseError(failure.toString())), (lease) {
      emit(LeaseOperationSuccess('Lease created successfully', lease: lease));
      // Reload leases
      add(
        const LoadLeasesEvent(GetLeasesParams(filterType: LeaseFilterType.all)),
      );
    });
  }

  Future<void> _onUpdateLease(
    UpdateLeaseEvent event,
    Emitter<LeaseState> emit,
  ) async {
    emit(LeaseLoading());

    final result = await leaseRepository.updateLease(event.lease);

    result.fold((failure) => emit(LeaseError(failure.toString())), (lease) {
      emit(LeaseOperationSuccess('Lease updated successfully', lease: lease));
      // Reload leases
      add(
        const LoadLeasesEvent(GetLeasesParams(filterType: LeaseFilterType.all)),
      );
    });
  }

  Future<void> _onDeleteLease(
    DeleteLeaseEvent event,
    Emitter<LeaseState> emit,
  ) async {
    emit(LeaseLoading());

    final result = await leaseRepository.deleteLease(event.leaseId);

    result.fold((failure) => emit(LeaseError(failure.toString())), (_) {
      emit(const LeaseOperationSuccess('Lease deleted successfully'));
      // Reload leases
      add(
        const LoadLeasesEvent(GetLeasesParams(filterType: LeaseFilterType.all)),
      );
    });
  }

  Future<void> _onTerminateLease(
    TerminateLeaseEvent event,
    Emitter<LeaseState> emit,
  ) async {
    emit(LeaseLoading());

    final result = await terminateLease(
      TerminateLeaseParams(
        leaseId: event.leaseId,
        terminationDate: event.terminationDate,
      ),
    );

    result.fold((failure) => emit(LeaseError(failure.toString())), (lease) {
      emit(
        LeaseOperationSuccess('Lease terminated successfully', lease: lease),
      );
      // Reload leases
      add(
        const LoadLeasesEvent(GetLeasesParams(filterType: LeaseFilterType.all)),
      );
    });
  }

  Future<void> _onRenewLease(
    RenewLeaseEvent event,
    Emitter<LeaseState> emit,
  ) async {
    emit(LeaseLoading());

    final result = await leaseRepository.renewLease(
      event.leaseId,
      event.newEndDate,
    );

    result.fold((failure) => emit(LeaseError(failure.toString())), (lease) {
      emit(LeaseOperationSuccess('Lease renewed successfully', lease: lease));
      // Reload leases
      add(
        const LoadLeasesEvent(GetLeasesParams(filterType: LeaseFilterType.all)),
      );
    });
  }
}
