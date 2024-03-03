import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class UploadPhoto extends Equatable {
  const UploadPhoto();

  @override
  List<Object> get props => [];
}

// зураг хуулах
class UploadPhotoEvent extends UploadPhoto {
  final File photo;
  const UploadPhotoEvent(this.photo);
  @override
  List<Object> get props => [];
}
