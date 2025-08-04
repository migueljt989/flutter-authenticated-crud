

import 'package:formz/formz.dart';

class RepeatedPassword extends FormzInput<String, String> {

  final String password;

  const RepeatedPassword.pure({this.password = ''}) : super.pure('');

  const RepeatedPassword.dirty({required this.password, String value=''}): super.dirty(value);




  @override
  String? validator(String value) {
    return password == value ? null : 'La contraseña no coincide';
  }

}