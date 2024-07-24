import 'package:black_book/models/invoice/detial.dart';
import 'package:black_book/models/packages/detial.dart';
import 'package:equatable/equatable.dart';

abstract class PaymentState extends Equatable {}

class PaymentInitial extends PaymentState {
  @override
  List<Object?> get props => [];
}

class PackagesLoading extends PaymentState {
  @override
  List<Object?> get props => [];
}

class PackagesFailure extends PaymentState {
  final String message;
  PackagesFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class PackagesSuccess extends PaymentState {
  final List<PackagesDetial> data;
  PackagesSuccess(this.data);
  @override
  List<Object?> get props => [data];
}

class InvoiceLoading extends PaymentState {
  @override
  List<Object?> get props => [];
}

class InvoiceFailure extends PaymentState {
  final String message;
  InvoiceFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class InvoiceSuccess extends PaymentState {
  final InvoiceDetial data;
  InvoiceSuccess(this.data);
  @override
  List<Object?> get props => [data];
}


class CheckInvoiceLoading extends PaymentState {
  @override
  List<Object?> get props => [];
}

class CheckInvoiceFailure extends PaymentState {
  final String message;
  CheckInvoiceFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class CheckInvoiceSuccess extends PaymentState {
  CheckInvoiceSuccess();
  @override
  List<Object?> get props => [];
}
