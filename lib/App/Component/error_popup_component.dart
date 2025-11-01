import 'dart:ui';
import 'package:flutter/material.dart';

/// Composant de popup d’erreur ou d’alerte réutilisable
///
/// [context] — le BuildContext courant
/// [title] — titre du popup (ex: "Erreur", "Attention")
/// [message] — message principal
/// [isError] — pour changer la couleur (rouge pour erreur, vert pour succès)
/// [onClose] — callback optionnel quand l’utilisateur ferme la popup
void showErrorPopupComponent(
  BuildContext context, {
  required String title,
  required String message,
  bool isError = true,
  VoidCallback? onClose,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isError ? Icons.error_outline : Icons.check_circle_outline,
                    color: isError ? Colors.red : Colors.green,
                    size: 50,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isError ? Colors.red : Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (onClose != null) onClose();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isError
                          ? Colors.red.shade700
                          : Colors.green.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
