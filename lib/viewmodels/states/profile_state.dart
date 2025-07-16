import 'service_state.dart';

typedef ProfileState = ServiceBaseState;

class ProfileInitial extends ServiceBaseState {
  @override
  List<Object?> get props => [];
}

class ProfileLoaded extends ServiceBaseState {
  final String? referalCode;
  final String? changedPin;
  ProfileLoaded(this.referalCode,this.changedPin);

  @override
  List<Object?> get props => [referalCode];
}

class ProfileLoading extends ServiceLoadingState {}

class ProfileError extends ServiceErrorState {
  ProfileError(super.message);
}
