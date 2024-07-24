// ignore_for_file: overridden_fields, annotate_overrides

import 'error_mapper.dart';

class APIError extends UError {
  final String message;
  final String error;

  final int? statusCode;

  APIError(this.message, this.error, [this.statusCode]) : super(error, message);

  @override
  String toString() {
    return "API_ERROR: {$error - $message - $statusCode}";
  }
}
