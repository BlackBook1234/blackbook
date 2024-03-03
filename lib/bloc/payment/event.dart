import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

// Ангилал шинээр үүсгэх
class GetPackagesEvent extends PaymentEvent {
  const GetPackagesEvent();
  @override
  List<Object> get props => [];
}

class GetInvoiceEvent extends PaymentEvent {
  final String keys;
  const GetInvoiceEvent(this.keys);
  @override
  List<Object> get props => [keys];
}

class CheckInvoiceEvent extends PaymentEvent {
  final String id, h;
  const CheckInvoiceEvent(this.id, this.h);
  @override
  List<Object> get props => [id, h];
}
