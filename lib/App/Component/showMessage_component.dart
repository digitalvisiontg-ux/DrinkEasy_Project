import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showMessageComponent(
  BuildContext context,
  String message,
  String title,
  bool isError,
) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: isError ? Colors.red : Colors.green,
    colorText: Colors.white,
    margin: const EdgeInsets.all(16),
    duration: const Duration(seconds: 2),
  );
}
