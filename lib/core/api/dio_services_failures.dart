import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
abstract class Failure {

  final String errorMessage;
  const Failure(this.errorMessage);
}



class ServerFailure extends Failure {
  ServerFailure(super.errorMessage);

  factory ServerFailure.fromDioException(DioException dioException ,BuildContext context) {
    log("❌ DioException: ${dioException.message}");

    if (dioException.response != null) {
      log("❌ Response Data: ${dioException.response?.data}");
      return ServerFailure.fromResponse(
          dioException.response?.statusCode,
          dioException.response?.data,
          context
      );
    } else {
      switch (dioException.type) {
        case DioExceptionType.connectionTimeout:
          return ServerFailure(
              'Connection timeout with the API server. Please try again later.');
        case DioExceptionType.sendTimeout:
          return ServerFailure(
              'Send timeout with the API server. Please try again later.');
        case DioExceptionType.receiveTimeout:
          return ServerFailure(
              'Receive timeout with the API server. Please try again later.');
        case DioExceptionType.cancel:
          return ServerFailure('Request to the API server was cancelled.');
        case DioExceptionType.connectionError:
          return ServerFailure(
              'Connection error occurred. Please check your internet connection and try again.');
        case DioExceptionType.unknown:
        default:
          return ServerFailure(
              'An unknown error occurred. Please try again later.');
      }
    }
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic response ,context) {
    log("❌ Handling Response Error - Status Code: $statusCode");

    if (response is Map<String, dynamic>) {
      if (response.containsKey('message') && response['message'] is String) {
        log("❌ Error Data: $response['message']");

        return ServerFailure(response['message']);
      }

      if (response.containsKey('error')) {
        final errorData = response['error'];
        if (errorData.toString().contains('Duplicate entry')) {
          return ServerFailure(
              'This email is already registered. Try logging in instead.');
        }
        if (errorData is String) {
          log("❌ Error Data: $errorData");
          return ServerFailure(errorData);
        } else if (errorData is Map<String, dynamic>) {
          log("❌ Error Data: $errorData");
          if (errorData.isNotEmpty) {
            final firstErrorKey = errorData.keys.first;
            final firstErrorValue = errorData[firstErrorKey];

            if (firstErrorValue is List && firstErrorValue.isNotEmpty) {
              log("❌ Error Data: $errorData");

              return ServerFailure(firstErrorValue.first.toString());
            }
            log("❌ Error Data: $errorData");

            return ServerFailure(firstErrorValue.toString());
          }
        }
      }
    }

    switch (statusCode) {
      case 400:
        return ServerFailure('Bad Request: The server could not understand the request.');
      case 401:
        return ServerFailure('Unauthorized: Access is denied due to invalid credentials.');
      case 403:
        return ServerFailure('Forbidden: You do not have permission to access this resource.');
      case 404:
        return ServerFailure('Not Found: The requested resource could not be found.');
      case 405:
        return ServerFailure('Method Not Allowed: The HTTP method is not supported.');
      case 406:
        return ServerFailure('Not Acceptable: The server cannot produce a response matching the request.');
      case 408:
        return ServerFailure('Request Timeout: The server timed out waiting for the request.');
      case 409:
        return ServerFailure('Conflict: The request could not be completed due to a conflict.');
      case 410:
        return ServerFailure('Gone: The resource is no longer available.');
      case 411:
        return ServerFailure('Length Required: The server requires a valid Content-Length header.');
      case 412:
        return ServerFailure('Precondition Failed: The server does not meet one of the preconditions.');
      case 413:
        return ServerFailure('Payload Too Large: The request entity is too large.');
      case 414:
        return ServerFailure('URI Too Long: The request URI is too long.');
      case 415:
        return ServerFailure('Unsupported Media Type: The media type is not supported.');
      case 422:
        return ServerFailure('Unprocessable Entity: The server understands the request but cannot process it.');
      case 429:
        return ServerFailure('Too Many Requests: You have sent too many requests in a given amount of time.');
      case 500:
        return ServerFailure('Internal Server Error: The server encountered an error.');
      case 501:
        return ServerFailure('Not Implemented: The server does not support the functionality required.');
      case 502:
        return ServerFailure('Bad Gateway: The server received an invalid response from the upstream server.');
      case 503:
        return ServerFailure('Service Unavailable: The server is currently unavailable.');
      case 504:
        return ServerFailure('Gateway Timeout: The server did not receive a timely response from the upstream server.');
      case 505:
        return ServerFailure('HTTP Version Not Supported: The server does not support the HTTP protocol version.');
      default:
        log("❌ Unexpected Error: $statusCode");
        return ServerFailure('Unexpected Error: An unexpected error occurred.');
    }
  }
}