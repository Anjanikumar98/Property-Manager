import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]) : super();

  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {
  final String message;

  const ServerFailure(this.message);

  @override
  List<Object> get props => [message];
}

class CacheFailure extends Failure {
  final String message;

  const CacheFailure(this.message);

  @override
  List<Object> get props => [message];
}

class NetworkFailure extends Failure {
  final String message;

  const NetworkFailure(this.message);

  @override
  List<Object> get props => [message];
}

class ValidationFailure extends Failure {
  final String message;

  const ValidationFailure(this.message);

  @override
  List<Object> get props => [message];
}

// Auth failures
class AuthFailure extends Failure {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure() : super('Invalid email or password');
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure() : super('User not found');
}

class EmailAlreadyExistsFailure extends AuthFailure {
  const EmailAlreadyExistsFailure() : super('Email already exists');
}

class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure() : super('Password is too weak');
}

// Database failures
class DatabaseFailure extends Failure {
  final String message;

  const DatabaseFailure(this.message);

  @override
  List<Object> get props => [message];
}

class PropertyNotFoundFailure extends DatabaseFailure {
  const PropertyNotFoundFailure() : super('Property not found');
}

class TenantNotFoundFailure extends DatabaseFailure {
  const TenantNotFoundFailure() : super('Tenant not found');
}

class LeaseNotFoundFailure extends DatabaseFailure {
  const LeaseNotFoundFailure() : super('Lease not found');
}

class PaymentNotFoundFailure extends DatabaseFailure {
  const PaymentNotFoundFailure() : super('Payment not found');
}

// File operation failures
class FileFailure extends Failure {
  final String message;

  const FileFailure(this.message);

  @override
  List<Object> get props => [message];
}

class FileNotFoundFailure extends FileFailure {
  const FileNotFoundFailure() : super('File not found');
}

class FileUploadFailure extends FileFailure {
  const FileUploadFailure() : super('Failed to upload file');
}

class FileDeleteFailure extends FileFailure {
  const FileDeleteFailure() : super('Failed to delete file');
}

class InvalidFileTypeFailure extends FileFailure {
  const InvalidFileTypeFailure() : super('Invalid file type');
}

class FileSizeExceededFailure extends FileFailure {
  const FileSizeExceededFailure() : super('File size exceeded maximum limit');
}

// Permission failures
class PermissionFailure extends Failure {
  final String message;

  const PermissionFailure(this.message);

  @override
  List<Object> get props => [message];
}

class StoragePermissionFailure extends PermissionFailure {
  const StoragePermissionFailure() : super('Storage permission denied');
}

class CameraPermissionFailure extends PermissionFailure {
  const CameraPermissionFailure() : super('Camera permission denied');
}

class NotificationPermissionFailure extends PermissionFailure {
  const NotificationPermissionFailure()
    : super('Notification permission denied');
}

// Business logic failures
class BusinessLogicFailure extends Failure {
  final String message;

  const BusinessLogicFailure(this.message);

  @override
  List<Object> get props => [message];
}

class PropertyAlreadyOccupiedFailure extends BusinessLogicFailure {
  const PropertyAlreadyOccupiedFailure()
    : super('Property is already occupied');
}

class LeaseAlreadyExistsFailure extends BusinessLogicFailure {
  const LeaseAlreadyExistsFailure()
    : super('Active lease already exists for this property');
}

class InvalidDateRangeFailure extends BusinessLogicFailure {
  const InvalidDateRangeFailure() : super('Invalid date range provided');
}

class InsufficientBalanceFailure extends BusinessLogicFailure {
  const InsufficientBalanceFailure() : super('Insufficient balance');
}

class PaymentAlreadyExistsFailure extends BusinessLogicFailure {
  const PaymentAlreadyExistsFailure()
    : super('Payment already recorded for this period');
}

// Utility class to convert exceptions to failures
class FailureHandler {
  static Failure handleException(Exception exception) {
    if (exception is FormatException) {
      return ValidationFailure(exception.message);
    } else if (exception is ArgumentError) {
      return ValidationFailure(exception.toString());
    } else {
      return ServerFailure(exception.toString());
    }
  }

  static Failure handleError(Error error) {
    return ServerFailure(error.toString());
  }
}

