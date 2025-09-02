
class ServerException implements Exception {
  final String message;

  const ServerException(this.message);

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  final String message;

  const CacheException(this.message);

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

class DatabaseException implements Exception {
  final String message;

  const DatabaseException(this.message);

  @override
  String toString() => 'DatabaseException: $message';
}

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, String>? fieldErrors;

  const ValidationException(this.message, {this.fieldErrors});

  @override
  String toString() => 'ValidationException: $message';
}

class FileException implements Exception {
  final String message;

  const FileException(this.message);

  @override
  String toString() => 'FileException: $message';
}

class PermissionException implements Exception {
  final String message;

  const PermissionException(this.message);

  @override
  String toString() => 'PermissionException: $message';
}
