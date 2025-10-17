import 'package:flutter/material.dart';

class FormWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType textInputType;
  // J'aimerai ajouter une icone en prefixe
  final Widget? prefixIcon;

  const FormWidget({
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
