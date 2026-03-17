import 'package:drink_eazy/App/Component/showMessage_component.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class ChangerMotDePassePage extends StatefulWidget {
  const ChangerMotDePassePage({super.key});

  @override
  State<ChangerMotDePassePage> createState() => _ChangerMotDePassePageState();
}

class _ChangerMotDePassePageState extends State<ChangerMotDePassePage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _hideCurrent = true;
  bool _hideNew = true;
  bool _hideConfirm = true;

  bool _isLoading = false;

  void _savePassword() async {
    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      showMessageComponent(
        context,
        "Veuillez remplir tous les champs",
        "Erreur",
        true,
      );
      return;
    }

    if (_newPasswordController.text.length < 6) {
      showMessageComponent(
        context,
        "Le mot de passe doit contenir au moins 6 caractères",
        "Mot de passe faible",
        true,
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      showMessageComponent(
        context,
        "Les mots de passe ne correspondent pas",
        "Erreur",
        true,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.changePassword(
      _currentPasswordController.text,
      _newPasswordController.text,
      _confirmPasswordController.text,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (success) {
        Get.back(); // Retour en arrière d'abord
        Future.delayed(const Duration(milliseconds: 300), () {
          showMessageComponent(
            Get.context ?? context,
            "Votre mot de passe a été modifié avec succès",
            "Succès",
            false,
          );
        });
      } else {
        showMessageComponent(
          context,
          authProvider.errorMessage ?? "Erreur lors du changement de mot de passe",
          "Erreur",
          true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Changer le mot de passe",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --------------------------------------------------
            // 🔐 HEADER
            // --------------------------------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 254, 171, 46),
                    Color.fromARGB(255, 255, 90, 40),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: const [
                  Icon(Icons.lock_reset_rounded, size: 38, color: Colors.white),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      "Sécurisez votre compte en modifiant votre mot de passe.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --------------------------------------------------
            // 🔑 FORMULAIRE
            // --------------------------------------------------
            _buildPasswordField(
              label: "Mot de passe actuel",
              controller: _currentPasswordController,
              obscure: _hideCurrent,
              toggle: () => setState(() => _hideCurrent = !_hideCurrent),
            ),

            const SizedBox(height: 14),

            _buildPasswordField(
              label: "Nouveau mot de passe",
              controller: _newPasswordController,
              obscure: _hideNew,
              toggle: () => setState(() => _hideNew = !_hideNew),
            ),

            const SizedBox(height: 14),

            _buildPasswordField(
              label: "Confirmer le mot de passe",
              controller: _confirmPasswordController,
              obscure: _hideConfirm,
              toggle: () => setState(() => _hideConfirm = !_hideConfirm),
            ),

            const SizedBox(height: 14),

            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Get.toNamed('/mot_de_passe_oublie'),
                child: Text(
                  "Mot de passe oublié ?",
                  style: TextStyle(
                    color: Colors.amber.shade800,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --------------------------------------------------
            // 💾 BOUTON SAUVEGARDE
            // --------------------------------------------------
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _savePassword,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save, color: Colors.black),
              label: Text(
                _isLoading ? "Enregistrement..." : "Enregistrer le nouveau mot de passe",
                style: TextStyle(color: _isLoading ? Colors.white : Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isLoading ? Colors.grey : Colors.amber,
                foregroundColor: Colors.black, // Effet clic
                elevation: 0.1,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // 🔹 PASSWORD FIELD
  // --------------------------------------------------
  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback toggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87),
        prefixIcon: Icon(Icons.lock_outline, color: Colors.amber.shade800),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey.shade600,
          ),
          onPressed: toggle,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.amber.shade700, width: 1),
        ),
      ),
    );
  }
}
