import 'service_state.dart';

typedef SendMoneyState = ServiceBaseState;

class SendMoneyInitial extends ServiceBaseState {
  final int amount;
  SendMoneyInitial(this.amount);
  @override
  List<Object?> get props => [amount];
}

class SentMoney extends ServiceSuccessState {
  SentMoney(super.response);
}

class SendingMoney extends ServiceLoadingState {}

class SendMoneyError extends ServiceErrorState {
  SendMoneyError(super.message);
}
