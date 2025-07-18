import 'service_state.dart';
import 'package:ussd_npay/utils/sim_type.dart';

typedef RechargeState = ServiceBaseState;

class RechargeInitial extends ServiceBaseState {
  final int amount;
  RechargeInitial(this.amount);
  @override
  List<Object?> get props => [];
}

class RechargeSelected extends ServiceSuccessState {
  final SimType simType;
  RechargeSelected(this.simType, super.response);

  @override
  List<Object?> get props => [simType, response];
}

class Recharging extends ServiceLoadingState {}

class RechargeError extends ServiceErrorState {
  RechargeError(super.message);
}
