abstract class VerificationState {}

class VerificationInitial extends VerificationState {}

class Verified extends VerificationState {
  String pin;
  int subscriptionId;
  String? sucessMessage;
  String? referralCode;
  Verified(this.pin,this.subscriptionId,this.sucessMessage,this.referralCode);
}

class Verifying extends VerificationState {}

class VerificationError extends VerificationState {
  final String message;
  VerificationError(this.message);
}
