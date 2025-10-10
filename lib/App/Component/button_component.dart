import 'package:drink_eazy/Utils/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ButtonComponent extends StatelessWidget {
  ButtonComponent({required this.textButton, super.key});
  String textButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: primary,
      ),
      child: Center(
        child: Text(
          textButton,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
