import 'service_state.dart';

typedef ProfileState = ServiceBaseState;

class ProfileInitial extends ServiceBaseState {
  @override
  List<Object?> get props => [];
}

class ProfileLoading extends ServiceLoadingState {}

class ProfileLoaded extends ServiceBaseState {
  ProfileLoaded(this.referalCode, this.changedPin);
  final String? referalCode;
  final String? changedPin;

  @override
  List<Object?> get props => [referalCode];
}

class ProfileError extends ServiceErrorState {
  ProfileError(super.message);
}
