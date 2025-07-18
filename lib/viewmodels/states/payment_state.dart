import 'service_state.dart';

typedef PaymentState = ServiceBaseState;

class PaymentInitial extends ServiceBaseState {
  final int amount;
  PaymentInitial(this.amount);
  @override
  List<Object?> get props => [];
}

class PaymentDone extends ServiceSuccessState {
  final int  ispTypeId;
  PaymentDone(this.ispTypeId, super.response);
  @override
  List<Object?> get props => [ispTypeId, response];
}

class PaymentProcessing extends ServiceLoadingState {}

class PaymentError extends ServiceErrorState {
  PaymentError(super.message);
}
