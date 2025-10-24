import 'package:drink_eazy/Utils/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ButtonComponent extends StatelessWidget {
  final String textButton;
  final VoidCallback? onPressed;

  const ButtonComponent({super.key, required this.textButton, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 1,
          splashFactory: InkRipple.splashFactory,
        ),
        child: Text(
          textButton,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
