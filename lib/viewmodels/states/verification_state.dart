abstract class VerificationState {}

class VerificationInitial extends VerificationState {}

class Verified extends VerificationState {
  String pin;
  int subscriptionId;
  String? sucessMessage;
  Verified(this.pin,this.subscriptionId,this.sucessMessage);
}

class Verifying extends VerificationState {}

class VerificationError extends VerificationState {
  final String message;
  VerificationError(this.message);
}
