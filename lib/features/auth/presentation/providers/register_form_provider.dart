

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


class Notifier extends StateNotifier<RegisterFormState> {
  Notifier(): super( RegisterFormState() );

  onEmailChange ( String value ) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password, state.fullName])

    );
  }

  onPasswordChange () {

  }

  onFormSubmit () {

  }

  _touchEveryField () {

  }
  
}