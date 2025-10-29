import 'package:drink_eazy/App/Component/button_component.dart';
import 'package:drink_eazy/App/Component/showMessage_component.dart';
import 'package:drink_eazy/App/Modules/Authentification/Controller/controller.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/connexion.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'package:drink_eazy/Utils/form.dart' hide validatePassword;

class NouveauMotDePassePage extends StatefulWidget {
  final String login;
  final String otp;

  const NouveauMotDePassePage({
    Key? key,
    required this.login,
    required this.otp,
  }) : super(key: key);

  @override
  State<NouveauMotDePassePage> createState() => _NouveauMotDePassePageState();
}

class _NouveauMotDePassePageState extends State<NouveauMotDePassePage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool loading = false;

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final newPassword = _passwordCtrl.text.trim();
    final auth = Provider.of<AuthProvider>(context, listen: false);

    setState(() => loading = true);
    final success = await auth.resetPassword(
      widget.login,
      widget.otp,
      newPassword,
      _confirmPasswordCtrl.text.trim(),
    );
    setState(() => loading = false);

    if (success == true) {
      showMessageComponent(
        context,
        auth.errorMessage ??
            'Votre mot de passe a été réinitialisé avec succès pour ${widget.login}',
        'Succès',
        false,
      );
      await Future.delayed(const Duration(milliseconds: 800));
      Get.offAll(() => ConnexionPage());
    } else {
      showMessageComponent(
        context,
        auth.errorMessage ?? 'Erreur lors de la réinitialisation',
        'Erreur',
        true,
      );
    }
  }

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔹 Image de fond
          Positioned.fill(
            child: Image.asset('assets/images/bgimage2.jpg', fit: BoxFit.cover),
          ),

          /// 🔹 Filtre sombre
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),

          /// 🔹 Bouton retour cohérent avec le reste de l’app
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// 🔹 Contenu principal
          Column(
            children: [
              const Spacer(flex: 2),

              // 🔸 Titre principal
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Nouveau mot de passe',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontFamily: 'Agbalumo',
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Définissez votre nouveau mot de passe',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 1),

              // 🔸 Bloc formulaire blanc
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 28,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FormWidget(
                        controller: _passwordCtrl,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.black54,
                        ),
                        hintText: "Nouveau mot de passe",
                        obscureText: true,
                        validator: validatePassword,
                      ),
                      const SizedBox(height: 16),
                      FormWidget(
                        controller: _confirmPasswordCtrl,
                        prefixIcon: const Icon(
                          Icons.lock_reset_outlined,
                          color: Colors.black54,
                        ),
                        hintText: "Confirmer le mot de passe",
                        obscureText: true,
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Veuillez confirmer le mot de passe';
                          if (v != _passwordCtrl.text)
                            return 'Les mots de passe ne correspondent pas';
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),

                      /// Bouton de validation
                      AbsorbPointer(
                        absorbing: loading,
                        child: ButtonComponent(
                          textButton: loading
                              ? "Réinitialisation en cours..."
                              : "Réinitialiser le mot de passe",
                          onPressed: loading ? null : _handleResetPassword,
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// Lien retour vers la connexion
                      GestureDetector(
                        onTap: () => Get.offAll(ConnexionPage()),
                        child: Center(
                          child: Text.rich(
                            TextSpan(
                              text: "Revenir à la ",
                              style: TextStyle(color: Colors.grey.shade600),
                              children: [
                                TextSpan(
                                  text: "connexion",
                                  style: TextStyle(
                                    color: Colors.red.shade800,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
