import 'package:equatable/equatable.dart';

abstract class ServiceState extends Equatable {}

class ServiceInitial extends ServiceState {
  @override
  List<Object?> get props => [];
}

class ServiceSelected extends ServiceState {
  final String? serviceCode;
  ServiceSelected(this.serviceCode);
  
  @override
  List<Object?> get props => [serviceCode];
}

class ServiceLoading extends ServiceState {
  @override
  List<Object?> get props => [];
}

class ServiceError extends ServiceState {
  final String message;
  ServiceError(this.message);
  
  @override
  List<Object?> get props => [message];
}
