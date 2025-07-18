import 'package:equatable/equatable.dart';

abstract class ServiceBaseState extends Equatable {}

class ServiceLoadingState extends ServiceBaseState {
  @override
  List<Object?> get props => [];
}

class ServiceSuccessState extends ServiceBaseState {
  ServiceSuccessState(this.response);
  final String? response;
  @override
  List<Object?> get props => [response];
}

class ServiceErrorState extends ServiceBaseState {
  ServiceErrorState(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
