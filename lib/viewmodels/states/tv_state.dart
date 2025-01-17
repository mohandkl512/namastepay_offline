import 'package:equatable/equatable.dart';

abstract class TvState extends Equatable {}

class TvInitial extends TvState {
  int amount;
  String? tvType;
  String? paymentOption;
  TvInitial({required this.amount, this.tvType, this.paymentOption});
  @override
  List<Object?> get props => [amount];
}

class TvRequestSucessfull extends TvState {
  final String? response;
  TvRequestSucessfull(this.response);

  @override
  List<Object?> get props => [response];
}

class TvRequestLoading extends TvState {
  @override
  List<Object?> get props => [];
}

class TvRequestError extends TvState {
  final String message;
  TvRequestError(this.message);

  @override
  List<Object?> get props => [message];
}
