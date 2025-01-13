import 'package:equatable/equatable.dart';

abstract class SendMoneyState extends Equatable {}

class SendMoneyInitial extends SendMoneyState {
  int amount;
   SendMoneyInitial(this.amount);
  @override
  List<Object?> get props => [amount];
}

class SentMoney extends SendMoneyState {
  final String? response;
  SentMoney(this.response);

  @override
  List<Object?> get props => [ response];
}

class SendingMoney extends SendMoneyState {
  @override
  List<Object?> get props => [];
}

class SendMoneyError extends SendMoneyState {
  final String message;
  SendMoneyError(this.message);

  @override
  List<Object?> get props => [message];
}
