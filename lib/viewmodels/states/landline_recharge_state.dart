import 'service_state.dart';

typedef LandlineRechargeState = ServiceBaseState;

class LandlineRechargeInitial extends ServiceBaseState {
  final int amount;
  LandlineRechargeInitial(this.amount);
  @override
  List<Object?> get props => [];
}

class LandlineRechargeSelected extends ServiceSuccessState {
  LandlineRechargeSelected(super.response);
}

class LandlineRecharging extends ServiceLoadingState {}

class LandlineError extends ServiceErrorState {
  LandlineError(super.message);
}
