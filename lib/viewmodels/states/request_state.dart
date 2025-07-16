import 'service_state.dart';

typedef RequestState = ServiceBaseState;

class RequestInitial extends ServiceBaseState {
  final int amount;
  RequestInitial(this.amount);
  @override
  List<Object?> get props => [amount];
}

class Requested extends ServiceSuccessState {
  Requested(super.response);
}

class Requesting extends ServiceLoadingState {}

class RequestError extends ServiceErrorState {
  RequestError(super.message);
}
