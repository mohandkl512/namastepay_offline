import 'service_state.dart';

typedef CashoutState = ServiceBaseState;

class CashoutInitial extends ServiceBaseState {
  final int amount;
  CashoutInitial(this.amount);
  @override
  List<Object?> get props => [];
}

class CashoutDone extends ServiceSuccessState {
  final int amount;
  CashoutDone(this.amount, super.response);
  @override
  List<Object?> get props => [amount, response];
}

class CashoutProcessing extends ServiceLoadingState {}

class CashoutError extends ServiceErrorState {
  CashoutError(super.message);
}
