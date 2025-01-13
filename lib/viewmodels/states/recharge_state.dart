import 'package:equatable/equatable.dart';
import 'package:ussd_npay/utils/sim_type.dart';

abstract class RechargeState extends Equatable {}

class RechargeInitial extends RechargeState {
  int amount;
  RechargeInitial(this.amount);
  @override
  List<Object?> get props => [];
}

class RechargeSelected extends RechargeState {
  final SimType simType;
  final String? response;
  RechargeSelected(this.simType, this.response);

  @override
  List<Object?> get props => [simType, response];
}

class Recharging extends RechargeState {
  @override
  List<Object?> get props => [];
}

class RechargeError extends RechargeState {
  final String message;
  RechargeError(this.message);

  @override
  List<Object?> get props => [message];
}
