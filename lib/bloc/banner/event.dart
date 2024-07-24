import 'package:equatable/equatable.dart';

abstract class BannerEvent extends Equatable {
  const BannerEvent();

  @override
  List<Object> get props => [];
}

// Ангилал шинээр үүсгэх
class GetBannerEvent extends BannerEvent {
  const GetBannerEvent();
  @override
  List<Object> get props => [];
}
