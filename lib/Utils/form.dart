import 'package:flutter/material.dart';

// Validation email
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Veuillez entrer votre e-mail';
  }
  final emailRegex = RegExp(r'^\S+@\S+\.\S+$');
  if (!emailRegex.hasMatch(value)) {
    return 'E-mail invalide';
  }
  return null;
}

// Validation mot de passe (min 6 caractères)
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Veuillez entrer un mot de passe';
  }
  if (value.length < 6) {
    return 'Le mot de passe doit contenir au moins 6 caractères';
  }
  return null;
}

class FormWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType textInputType;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;

  const FormWidget({
    this.keyboardType,
    this.prefixIcon,
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.validator,
    this.textInputType = TextInputType.emailAddress,
  });

  @override
  State<FormWidget> createState() => _FormFiledWidgetState();
}

class _FormFiledWidgetState extends State<FormWidget> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.textInputType,
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.obscureText ? _isObscure : false,

      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
          gapPadding: 5,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(width: 1, color: Colors.grey.shade300),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        prefixIcon: widget.prefixIcon,

        prefixIconColor: Colors.grey.shade800,
        hintStyle: TextStyle(color: Colors.grey.shade800, fontSize: 16),
        hintText: widget.hintText,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _isObscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() => _isObscure = !_isObscure);
                },
              )
            : null,
      ),
    );
  }
}
