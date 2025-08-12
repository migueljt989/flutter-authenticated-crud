

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class RegisterFormState {

  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final FullName fullName;
  final Email email;
  final Password password;
  final RepeatedPassword repetedPasword;

  RegisterFormState({
    this.isPosting=false, 
    this.isFormPosted=false, 
    this.isValid=false,
    this.fullName= const FullName.pure(),
    this.email= const Email.pure(), 
    this.password= const Password.pure(),
    this.repetedPasword= const RepeatedPassword.pure()
    });

  RegisterFormState copyWith ({
    final bool? isPosting,
    final bool? isFormPosted,
    final bool? isValid,
    final FullName? fullName,
    final Email? email,
    final Password? password,
    final RepeatedPassword? repetedPasword,
    }) => RegisterFormState(
    isPosting: isPosting ?? this.isPosting ,
    isFormPosted: isFormPosted ?? this.isFormPosted ,
    isValid: isValid ?? this.isValid ,
    fullName: fullName ?? this.fullName ,
    email: email ?? this.email ,
    password: password ?? this.password ,
    repetedPasword: repetedPasword ?? this.repetedPasword,
  );

  @override
  String toString(){
    return '''
            RegisterFormState:
              isPosting:     $isPosting
              isFormPosted:  $isFormPosted
              isValid:       $isValid
              fullName:      $fullName
              email:         $email
              password:      $password
              repetedPasword $repetedPasword
           ''';
  }
}


class RegisterFormNotifier extends StateNotifier<RegisterFormState> {

  final Future<void> Function (String, String, String) registerUserCallback;

  RegisterFormNotifier({ required this.registerUserCallback}): super( RegisterFormState() );

  

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

  onRepetedPaswordChange ( String value ) {
    final newRepeatedPassword = RepeatedPassword.dirty(password: state.password.value, value: value);
    state = state.copyWith(
      repetedPasword: newRepeatedPassword,
      isValid: Formz.validate([newRepeatedPassword, state.email, state.fullName, state.password]),
    );
  }
  


  onFullNameChange ( String value ) {
    final newFullName = FullName.dirty(value);
    state = state.copyWith(
      fullName: newFullName,
      isValid: Formz.validate([newFullName, state.email, state.password, state.repetedPasword])
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

final registerFormProvider = StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>((ref) {
  final registerUserCallback = ref.watch(authProvider.notifier).registerUser;
  return RegisterFormNotifier(registerUserCallback: registerUserCallback);
});
