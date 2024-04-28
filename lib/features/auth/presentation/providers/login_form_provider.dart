//! 1- state de este provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/email.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/password.dart';

class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.email = const Email.pure(),
      this.password = const Password.pure()});

  @override
  String toString() {
    return '''
      isPosting:$isPosting,
      isFormPosted:$isFormPosted,
      isValid:$isValid,
      email:$email,
      password:$password
    ''';
  }

  /* vamos a crear este metodo toString para poder ver el valor de cada uno de los elementos 
  vamos a poder ver la impresion del estado
   */

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
  /*
   vamos a crear un metodo copyWith que lo vamos a querer utilizar para que?
   para crear nuevos estados en el estado actual 
    vamos a querer crear nuevos estados en el estado actual
   */
}

//! 2- como implementos un notifier - nuestro manejador de estado
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier()
      : super(
            LoginFormState()); /* en el super la creacion edel estado inicial */
  onEmailChange(String value) {
    /* cuando cambia el email  */
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail, isValid: Formz.validate([newEmail, state.password]));
  }

  onPasswordChange(String value) {
    /* cuando cambia el email  */
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate([newPassword, state.email]));
  }

  onFormSubmit() {
    _touchEveryField();
    if (!state.isValid) return;    
    print('onformsubmit');
    print(state);
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        isValid: Formz.validate(
          [email, password],
        ));
    print('state');
    print(state);
  }
}

//! 3- implementamos StateNotifierProvider que consume de afuera
/* 
final LoginFormProvider = StateNotifierProvider.autoDispose<notifier,state>((ref) {
  return LoginFormNotifier();
});
 */
final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  return LoginFormNotifier();
});
