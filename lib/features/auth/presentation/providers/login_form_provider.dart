/* 1 - State de este provider */
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/provider/auth_provider.dart';
import 'package:teslo_shop/features/infrastructure/inputs/email.dart';
import 'package:teslo_shop/features/infrastructure/inputs/password.dart';

class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });

  @override
  String toString() {
    // TODO: implement toString
    return '''

LoginFormState:
  isPosting: $isPosting,
  isFormPosted: $isFormPosted,
  isValid: $isValid,
  email: $email,
  password: $password,
''';
  }

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) =>
      LoginFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        email: email ?? this.email,
        password: password ?? this.password,
      );
}

/* 2 - Como implementamos un notifier */
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Function(String, String) loginUserCallback;
  LoginFormNotifier({required this.loginUserCallback})
      : super(LoginFormState());

  onEmailChanged(String value) {
    state = state.copyWith(
      email: Email.dirty(value),
      isValid: Email.dirty(value).isValid && state.password.isValid,
    );
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.email]),
    );
  }

  onFormSubmit() async {
    _touchedEverField();

    if (!state.isValid) return;

    state = state.copyWith(isPosting: true);

    await loginUserCallback(
      state.email.value,
      state.password.value,
    );
    state = state.copyWith(isPosting: false);
  }

  _touchedEverField() {
    final emai = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
      email: emai,
      isFormPosted: true,
      password: password,
      isValid: Formz.validate(
        [
          emai,
          password,
        ],
      ),
    );
  }
}
/* 3 - StateNotifierProvider - consume afuera */

final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;

  return LoginFormNotifier(
    loginUserCallback: loginUserCallback,
  );
});
