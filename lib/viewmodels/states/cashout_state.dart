import 'package:equatable/equatable.dart';

abstract class CashoutState extends Equatable {}

class CashoutInitial extends CashoutState {
  final int amount;
  CashoutInitial(this.amount);
  @override
  List<Object?> get props => [];
}

class CashoutDone extends CashoutState {
  final int amount;
  final String? response;
  CashoutDone(this.amount, this.response);

  @override
  List<Object?> get props => [amount, response];
}

class CashoutProcessing extends CashoutState {
  @override
  List<Object?> get props => [];
}

class CashoutError extends CashoutState {
  final String message;
  CashoutError(this.message);

  @override
  List<Object?> get props => [message];
}
