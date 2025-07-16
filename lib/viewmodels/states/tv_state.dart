import 'service_state.dart';

typedef TvState = ServiceBaseState;

class TvInitial extends ServiceBaseState {
  final int amount;
  final String? tvType;
  final String? paymentOption;
  TvInitial({required this.amount, this.tvType, this.paymentOption});
  @override
  List<Object?> get props => [amount];
}

class TvRequestSucessfull extends ServiceSuccessState {
  TvRequestSucessfull(super.response);
}

class TvRequestLoading extends ServiceLoadingState {}

class TvRequestError extends ServiceErrorState {
  TvRequestError(super.message);
}
