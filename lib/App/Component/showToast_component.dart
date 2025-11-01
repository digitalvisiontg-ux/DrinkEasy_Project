import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Composant de Toast élégant et réutilisable
void showToastComponent(
  BuildContext context,
  String message, {
  bool isError = false,
  IconData? icon,
  ToastGravity gravity = ToastGravity.TOP,
}) {
  final fToast = FToast();
  fToast.init(context);

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.85),
      borderRadius: BorderRadius.circular(14),
      // border: Border.all(
      //   // color: isError ? Colors.redAccent : Colors.greenAccent,
      //   // width: 2,
      // ),
      // boxShadow: [
      //   BoxShadow(
      //     color: (isError ? Colors.redAccent : Colors.greenAccent).withOpacity(
      //       0.3,
      //     ),
      //     blurRadius: 10,
      //     offset: const Offset(0, 4),
      //   ),
      // ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon ?? (isError ? Icons.error_outline : Icons.check_circle),
          color: isError ? Colors.red : Colors.white,
          size: 24,
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: gravity,
    toastDuration: const Duration(seconds: 3),
  );
}
