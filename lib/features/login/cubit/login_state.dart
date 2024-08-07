part of 'login_cubit.dart';

enum LoginStatus { initial, verifying, signingIn, failure, success }

extension LoginStatusExtensions on LoginStatus {
  bool get isSigningIn => this == LoginStatus.signingIn;
}

enum SignInMethod { none, phone }

extension SignInMethodExtensions on SignInMethod {
  bool get isPhone => this == SignInMethod.phone;
}

final class LoginState extends Equatable {
  const LoginState._({
    this.status = LoginStatus.initial,
    this.signInMethod = SignInMethod.none,
    this.failure = UserFailure.empty,
  });

  const LoginState.initial() : this._();

  const LoginState.verifyingPhone()
      : this._(
          status: LoginStatus.verifying,
          signInMethod: SignInMethod.phone,
        );

  const LoginState.signingInWithPhone()
      : this._(
          status: LoginStatus.signingIn,
          signInMethod: SignInMethod.phone,
        );

  const LoginState.successfulSignIn()
      : this._(
          status: LoginStatus.success,
        );

  const LoginState.failure(UserFailure failure)
      : this._(
          status: LoginStatus.failure,
          failure: failure,
        );

  final LoginStatus status;
  final SignInMethod signInMethod;
  final UserFailure failure;

  @override
  List<Object> get props => [status, signInMethod, failure];
}

extension LoginStateExtensions on LoginState {
  bool get isFailure => status == LoginStatus.failure;
  bool get isSuccess => status == LoginStatus.success;
  bool get isSigningInWithPhone => status.isSigningIn && signInMethod.isPhone;
  bool get isVerifyingWithPhone => status.isSigningIn && signInMethod.isPhone;
}
