import 'package:flutter/services.dart';

import 'api_error.dart';

class UError {
  final String error;
  final String description;

  UError(this.error, this.description);
}

UError errorMapper(Object error) {
  if (error is APIError) return error;

  if (error is PlatformException) {
    if (error.code == 'ACTIVITY_NOT_FOUND') {
      return UError(
        'Аппликейшн олдсонгүй',
        'Аппликейшн олдсонгүй',
      );
    }
    return UError(
      'Platform Exception',
      error.code,
    );
  }

  if (error is TypeError) {
    return UError(
      'JSON алдаа',
      '${error.toString()}\n${error.stackTrace}',
    );
  }

  return APIError('Алдаа', '$error');
}
