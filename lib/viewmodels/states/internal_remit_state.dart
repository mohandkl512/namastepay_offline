import 'package:equatable/equatable.dart';

abstract class InternalRemitState extends Equatable {}

class InternalRemitInitial extends InternalRemitState {
  InternalRemitInitial();
  @override
  List<Object?> get props => [];
}

class RemitDone extends InternalRemitState {
  final int amount;
  final String? response;
  RemitDone(this.amount, this.response);

  @override
  List<Object?> get props => [amount, response];
}

class RemitProcessing extends InternalRemitState {
  @override
  List<Object?> get props => [];
}

class RemitError extends InternalRemitState {
  final String message;
  RemitError(this.message);

  @override
  List<Object?> get props => [message];
}
