abstract class VerificationState {}

class VerificationInitial extends VerificationState {}

class Verified extends VerificationState {
  String pin;
  int subscriptionId;
  Verified(this.pin,this.subscriptionId);
}

class Verifying extends VerificationState {}

class VerificationError extends VerificationState {
  final String message;
  VerificationError(this.message);
}
