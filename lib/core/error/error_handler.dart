import 'package:dio/dio.dart';

import 'api_error_model.dart';

class ApiErrorHandler {
  static ApiErrorModel handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          return ApiErrorModel(
            errorMessage: 'Connection to server failed',
            status: 'false',
          );
        case DioExceptionType.cancel:
          return ApiErrorModel(
            errorMessage: "Request to the server was cancelled",
            status: 'false',
          );
        case DioExceptionType.connectionTimeout:
          return ApiErrorModel(
            errorMessage: "Connection timeout with the server",
            status: 'false',
          );
        case DioExceptionType.unknown:
          return ApiErrorModel(
            errorMessage:
                "Connection to the server failed due to internet connection",
            status: 'false',
          );
        case DioExceptionType.receiveTimeout:
          return ApiErrorModel(
            errorMessage: "Receive timeout in connection with the server",
            status: 'false',
          );
        case DioExceptionType.badResponse:
          return _handleError(error.response?.statusCode, error.response?.data);
        case DioExceptionType.sendTimeout:
          return ApiErrorModel(
            errorMessage: "Send timeout in connection with the server",
            status: 'false',
          );
        default:
          return ApiErrorModel(
            errorMessage: "Something went wrong",
            status: 'false',
          );
      }
    } else {
      return ApiErrorModel(
        errorMessage: 'Unknown error occurred',
        status: 'false',
      );
    }
  }

  static ApiErrorModel _handleError(int? statusCode, dynamic response) {
    return ApiErrorModel(
      errorMessage: response?['error']?['description'] ?? 'Unknown error occurred',
      status: response?['error']?['status']?.toString() ?? 'false',
    );
  }
}
