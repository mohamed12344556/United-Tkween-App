import 'package:dio/dio.dart';

import 'api_error_model.dart';

class ApiErrorHandler {
  static ApiErrorModel handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          return ApiErrorModel(
            errorMessage: ErrorData(
              message: 'Connection to server failed',
              code: 500,
            ),
            status: false,
          );
        case DioExceptionType.cancel:
          return ApiErrorModel(
            errorMessage: ErrorData(
              message: "Request to the server was cancelled",
              code: 499,
            ),
            status: false,
          );
        case DioExceptionType.connectionTimeout:
          return ApiErrorModel(
            errorMessage: ErrorData(
              message: "Connection timeout with the server",
              code: 408,
            ),
            status: false,
          );
        case DioExceptionType.unknown:
          return ApiErrorModel(
            errorMessage: ErrorData(
              message:
                  "Connection to the server failed due to internet connection",
              code: 0,
            ),
            status: false,
          );
        case DioExceptionType.receiveTimeout:
          return ApiErrorModel(
            errorMessage: ErrorData(
              message: "Receive timeout in connection with the server",
              code: 408,
            ),
            status: false,
          );
        case DioExceptionType.badResponse:
          return _handleError(error.response?.statusCode, error.response?.data);
        case DioExceptionType.sendTimeout:
          return ApiErrorModel(
            errorMessage: ErrorData(
              message: "Send timeout in connection with the server",
              code: 408,
            ),
            status: false,
          );
        default:
          return ApiErrorModel(
            errorMessage: ErrorData(
              message: "Something went wrong",
              code: 500,
            ),
            status: false,
          );
      }
    } else {
      return ApiErrorModel(
        errorMessage: ErrorData(
          message: 'Unknown error occurred',
          code: 500,
        ),
        status: false,
      );
    }
  }

  static ApiErrorModel _handleError(int? statusCode, dynamic response) {
    return ApiErrorModel(
      errorMessage: ErrorData(
        message: response?['error']?['description'] ?? 'Unknown error occurred',
        code: response?['error']?['statusCode'] ?? statusCode ?? 500,
      ),
      status: false,
      data: response?['data'],
    );
  }
}
