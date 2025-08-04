

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class RegisterFormState {

  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final FullName fullName;
  final Email email;
  final Password password;

  RegisterFormState({
    this.isPosting=false, 
    this.isFormPosted=false, 
    this.isValid=false,
    this.fullName= const FullName.pure(),
    this.email= const Email.pure(), 
    this.password= const Password.pure(),
    });

  RegisterFormState copyWith ({
    final bool? isPosting,
    final bool? isFormPosted,
    final bool? isValid,
    final FullName? fullName,
    final Email? email,
    final Password? password,
    }) => RegisterFormState(
    isPosting: isPosting ?? this.isPosting ,
    isFormPosted: isFormPosted ?? this.isFormPosted ,
    isValid: isValid ?? this.isValid ,
    fullName: fullName ?? this.fullName ,
    email: email ?? this.email ,
    password: password ?? this.password ,
  );

  @override
  String toString(){
    return '''
            RegisterFormState:
              isPosting:    $isPosting
              isFormPosted: $isFormPosted
              isValid:      $isValid
              fullName:     $fullName
              email:        $email
              password:     $password
           ''';
  }
}


class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  RegisterFormNotifier(): super( RegisterFormState() );

  onEmailChange ( String value ) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password, state.fullName])

    );
  }

  onPasswordChange ( String value ) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.email, state.fullName])
    );
  }

  onFullNameChange ( String value ) {
    final newFullName = FullName.dirty(value);
    state = state.copyWith(
      fullName: newFullName,
      isValid: Formz.validate([newFullName, state.email, state.password])
    );

  }

  onFormSubmit () async {
    _touchEveryField();

    if ( !state.isValid ) return;

     print(state);

    // await loginUserCallback( state.email.value, state.password.value );

  }

  _touchEveryField () {

    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final fullName = FullName.dirty(state.fullName.value);

    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      fullName: fullName,
      isValid: Formz.validate([email, password, fullName])
    );

  }
  
}

final registerFormProvider = StateNotifierProvider<RegisterFormNotifier, RegisterFormState>((ref) {
  return RegisterFormNotifier();
});