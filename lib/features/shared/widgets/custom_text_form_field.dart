import 'package:flutter/material.dart';


class CustomTextFormField extends StatelessWidget {

  final String? label;
  final String? hint;
  final String? errorMessage;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key, 
    this.label, 
    this.hint, 
    this.errorMessage, 
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged, 
    this.validator, 
  });

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(40)
    );

    const borderRadius = Radius.circular(15);

    return Container(
      // padding: const EdgeInsets.only(bottom: 0, top: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: borderRadius, bottomLeft: borderRadius, bottomRight: borderRadius ),
        boxShadow: [
          BoxShadow(
            // color: Colors.black.withOpacity(0.06),
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0,5)
          )
        ]
      ),
      child: TextFormField(
        onChanged: onChanged,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle( fontSize: 20, color: Colors.black54 ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          enabledBorder: border,
          focusedBorder: border,
          errorBorder: border.copyWith( borderSide: const BorderSide( color: Colors.transparent )),
          // errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
          focusedErrorBorder: border.copyWith( borderSide: const BorderSide( color: Colors.transparent )),
          isDense: true,
          label: label != null ? Text(label!) : null,
          hintText: hint,
          errorText: errorMessage,
          focusColor: colors.primary,
          // icon: Icon( Icons.supervised_user_circle_outlined, color: colors.primary, )
        ),
      ),
    );
  }
}
