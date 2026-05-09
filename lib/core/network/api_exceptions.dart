class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (StatusCode: $statusCode)';
}

class NetworkException extends ApiException {
  NetworkException(String message) : super(message);
}

class ServerException extends ApiException {
  ServerException(String message, {int? statusCode})
    : super(message, statusCode: statusCode);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super(message, statusCode: 401);
}

class BadRequestException extends ApiException {
  BadRequestException(String message) : super(message, statusCode: 400);
}
