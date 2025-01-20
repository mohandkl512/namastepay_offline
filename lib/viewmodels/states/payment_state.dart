import 'package:equatable/equatable.dart';

abstract class PaymentState extends Equatable {}

class PaymentInitial extends PaymentState {
  int amount;
  PaymentInitial(this.amount);
  @override
  List<Object?> get props => [];
}

class PaymentDone extends PaymentState {
  final int  ispTypeId;
  final String? response;
  PaymentDone(this.ispTypeId, this.response);

  @override
  List<Object?> get props => [ispTypeId, response];
}

class PaymentProcessing extends PaymentState {
  @override
  List<Object?> get props => [];
}

class PaymentError extends PaymentState {
  final String message;
  PaymentError(this.message);

  @override
  List<Object?> get props => [message];
}
