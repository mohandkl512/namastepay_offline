import 'package:equatable/equatable.dart';

abstract class RequestState extends Equatable {}

class RequestInitial extends RequestState {
  int amount;
   RequestInitial(this.amount);
  @override
  List<Object?> get props => [amount];
}

class Requested extends RequestState {
  final String? response;
  Requested(this.response);

  @override
  List<Object?> get props => [ response];
}

class Requesting extends RequestState {
  @override
  List<Object?> get props => [];
}

class RequestError extends RequestState {
  final String message;
  RequestError(this.message);

  @override
  List<Object?> get props => [message];
}
