import 'service_state.dart';

typedef RemitState = ServiceBaseState;

class RemitInitial extends ServiceBaseState {
  RemitInitial();
  @override
  List<Object?> get props => [];
}

class RemitDone extends ServiceSuccessState {
  final int amount;
  RemitDone(this.amount, super.response);
  @override
  List<Object?> get props => [amount, response];
}

class RemitProcessing extends ServiceLoadingState {}

class RemitError extends ServiceErrorState {
  RemitError(super.message);
}
