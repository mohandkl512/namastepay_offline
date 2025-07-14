import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {}

class ProfileInitial extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileLoaded extends ProfileState {
  final String? referalCode;
  final String? changedPin;
  ProfileLoaded(this.referalCode,this.changedPin);

  @override
  List<Object?> get props => [referalCode];
}

class ProfileLoading extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
