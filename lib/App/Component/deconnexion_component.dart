import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'package:drink_eazy/App/Component/confirm_component.dart';
import 'package:drink_eazy/App/Component/error_popup_component.dart';
import 'package:drink_eazy/App/Component/showMessage_component.dart';
import 'package:drink_eazy/App/Modules/Home/View/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

OutlinedButton Deconnexion_component(BuildContext context) {
  return OutlinedButton.icon(
    onPressed: () async {
      final confirm = await showConfirmComponent(
        context,
        title: 'Déconnexion',
        message: 'Voulez-vous vraiment vous déconnecter ?',
        confirmText: 'Déconnecter',
        cancelText: 'Annuler',
        confirmColor: Colors.red,
        cancelColor: Colors.grey.shade200,
        // icon: Icons.logout_rounded,
        // iconColor: Colors.red,
        // iconBgColor: Colors.redAccent.withOpacity(0.1),
      );

      if (confirm == true) {
        try {
          final auth = Provider.of<AuthProvider>(context, listen: false);
          await auth.logout();
          Get.offAll(const Home());
          showMessageComponent(
            context,
            'Déconnexion réussie',
            'Vous avez été déconnecté avec succès.',
            false,
          );
        } catch (e) {
          debugPrint('Erreur de déconnexion : $e');
          showErrorPopupComponent(
            context,
            title: 'Erreur',
            message: 'Une erreur est survenue lors de la déconnexion.',
          );
        }
      }
    },
    icon: const Icon(Icons.logout, color: Colors.red),
    label: const Text(
      "Déconnexion",
      style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
    ),
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: Colors.red.shade300),
      minimumSize: const Size.fromHeight(50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    ),
  );
}
