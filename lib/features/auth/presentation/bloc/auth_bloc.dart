// lib/features/auth/presentation/bloc/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser _loginUser;
  final RegisterUser _registerUser;
  final LogoutUser _logoutUser;
  final GetCurrentUser _getCurrentUser;
  final AuthRepository _authRepository;

  AuthBloc({
    required LoginUser loginUser,
    required RegisterUser registerUser,
    required LogoutUser logoutUser,
    required GetCurrentUser getCurrentUser,
    required AuthRepository authRepository,
  }) : _loginUser = loginUser,
       _registerUser = registerUser,
       _logoutUser = logoutUser,
       _getCurrentUser = getCurrentUser,
       _authRepository = authRepository,
       super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthProfileUpdateRequested>(_onAuthProfileUpdateRequested);
  }

  Future<void> _onAuthStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _getCurrentUser(NoParams());

    result.fold((failure) => emit(AuthUnauthenticated()), (user) {
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _loginUser(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure.toString()))),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _registerUser(
      RegisterParams(
        name: event.name,
        email: event.email,
        password: event.password,
        role: event.role,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure.toString()))),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _logoutUser(NoParams());

    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure.toString()))),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onAuthProfileUpdateRequested(
    AuthProfileUpdateRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! AuthAuthenticated) return;

    final currentUser = (state as AuthAuthenticated).user;
    emit(AuthLoading());

    final result = await _authRepository.updateProfile(
      userId: currentUser.id,
      name: event.name,
      profileImage: event.profileImage,
    );

    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure.toString()))),
      (_) async {
        // Get updated user
        final userResult = await _getCurrentUser(NoParams());
        userResult.fold(
          (failure) =>
              emit(AuthError(_mapFailureToMessage(failure.toString()))),
          (user) {
            if (user != null) {
              emit(AuthProfileUpdated(user));
            } else {
              emit(AuthUnauthenticated());
            }
          },
        );
      },
    );
  }

  String _mapFailureToMessage(String failure) {
    if (failure.contains('User not found')) {
      return 'User not found. Please check your email.';
    } else if (failure.contains('Invalid credentials')) {
      return 'Invalid email or password.';
    } else if (failure.contains('already exists')) {
      return 'An account with this email already exists.';
    } else if (failure.contains('Account is deactivated')) {
      return 'Your account has been deactivated. Please contact support.';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }
}
