import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

// Ангилал шинээр үүсгэх
class GetPackagesEvent extends PaymentEvent {
  final String url;
  const GetPackagesEvent(this.url);
  @override
  List<Object> get props => [url];
}

class GetInvoiceEvent extends PaymentEvent {
  final String keys;
  final String storeId;
  const GetInvoiceEvent(this.keys, this.storeId);
  @override
  List<Object> get props => [keys, storeId];
}

class CheckInvoiceEvent extends PaymentEvent {
  final int orderId;
  const CheckInvoiceEvent(this.orderId);
  @override
  List<Object> get props => [orderId];
}
