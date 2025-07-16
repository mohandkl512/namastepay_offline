import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {}

class HomeInitial extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeSelected extends HomeState {
  final String? serviceCode;
  HomeSelected(this.serviceCode);

  @override
  List<Object?> get props => [serviceCode];
}

class HomeLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
