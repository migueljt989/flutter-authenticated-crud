


import 'package:formz/formz.dart';

// Define input validation errors
enum FullNmaeError { empty, length }

// Extend FormzInput and provide the input type and error type.
class FullName extends FormzInput<String, FullNmaeError> {

  // Call super.pure to represent an unmodified form input.
  const FullName.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const FullName.dirty( String value ) : super.dirty(value);


  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == FullNmaeError.empty ) return 'El campo es requerido';
    if ( displayError == FullNmaeError.length ) return 'Mínimo 6 caracteres';

    return null;
  }


  // Override validator to handle validating a given input value.
  @override
  FullNmaeError? validator(String value) {

    if ( value.isEmpty || value.trim().isEmpty ) return FullNmaeError.empty;
    if ( value.length < 6 ) return FullNmaeError.length;
    return null;
  }
}