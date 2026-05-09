import 'dart:io';
import 'package:dio/dio.dart';
import 'package:lawyer_app/core/network/api_exceptions.dart';
import 'package:lawyer_app/core/network/dio_client.dart';

class ApiClient {
  final DioClient _dioClient;

  ApiClient(this._dioClient);

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        path,
        queryParameters: queryParameters,
      );
      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dioClient.dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dioClient.dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  dynamic _processResponse(Response response) {
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return response.data;
    } else {
      throw ServerException(
        response.statusMessage ?? 'Server error',
        statusCode: response.statusCode,
      );
    }
  }

  ApiException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['errorMessage'] ??
            e.response?.data?['error'] ??
            e.message ??
            'Unknown error';
            
        if (statusCode == 401) {
          return UnauthorizedException(message);
        } else if (statusCode == 400) {
          return BadRequestException(message);
        }
        return ServerException(message, statusCode: statusCode);
      case DioExceptionType.connectionError:
        if (e.error is SocketException) {
          return NetworkException('No Internet connection');
        }
        return NetworkException('Connection error');
      default:
        return ApiException('Something went wrong: ${e.message}');
    }
  }
}
