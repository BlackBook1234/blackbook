import 'package:black_book/models/upload/upload_detial.dart';
import 'package:equatable/equatable.dart';

abstract class UploadPhotoState extends Equatable {}

class UploadInitial extends UploadPhotoState {
  @override
  List<Object?> get props => [];
}

class UploadLoading extends UploadPhotoState {
  @override
  List<Object?> get props => [];
}

class UploadFailure extends UploadPhotoState {
  final String message;

  UploadFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class UploadSuccess extends UploadPhotoState {
  final UploadDetialModel data;
  UploadSuccess(this.data);
  @override
  List<Object?> get props => [data];
}
