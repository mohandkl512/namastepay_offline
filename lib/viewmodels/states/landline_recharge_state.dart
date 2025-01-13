import 'package:equatable/equatable.dart';

abstract class LandlineRechargeState extends Equatable {}

class LandlineRechargeInitial extends LandlineRechargeState {
  int amount;
  LandlineRechargeInitial(this.amount);
  @override
  List<Object?> get props => [];
}

class LandlineRechargeSelected extends LandlineRechargeState {
  final String? response;
  LandlineRechargeSelected(this.response);

  @override
  List<Object?> get props => [response];
}

class LandlineRecharging extends LandlineRechargeState {
  @override
  List<Object?> get props => [];
}

class LandlineError extends LandlineRechargeState {
  final String message;
  LandlineError(this.message);

  @override
  List<Object?> get props => [message];
}
