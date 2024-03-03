import 'package:black_book/models/banner/detial.dart';
import 'package:equatable/equatable.dart';

abstract class BannerState extends Equatable {}

class BannerInitial extends BannerState {
  @override
  List<Object?> get props => [];
}

class BannerLoading extends BannerState {
  @override
  List<Object?> get props => [];
}

class BannerFailure extends BannerState {
  final String message;

  BannerFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class BannerSuccess extends BannerState {
  final List<BannerDetial> data;
  BannerSuccess(this.data);
  @override
  List<Object?> get props => [data];
}
