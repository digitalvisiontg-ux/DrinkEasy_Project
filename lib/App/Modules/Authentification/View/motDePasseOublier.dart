import 'package:drink_eazy/App/Component/button_component.dart';
import 'package:drink_eazy/App/Component/showMessage_component.dart';
<<<<<<< HEAD:lib/App/Modules/Connexion/View/motDePasseOublier.dart
import 'package:drink_eazy/App/Modules/Connexion/View/otp.dart';
=======
import 'package:drink_eazy/App/Modules/Authentification/Controller/controller.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/otp.dart';
>>>>>>> main:lib/App/Modules/Authentification/View/motDePasseOublier.dart
import 'package:drink_eazy/Utils/form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';

class MotDePasseOubliePage extends StatefulWidget {
  const MotDePasseOubliePage({Key? key}) : super(key: key);

  @override
  State<MotDePasseOubliePage> createState() => _MotDePasseOubliePageState();
}

class _MotDePasseOubliePageState extends State<MotDePasseOubliePage> {
  final _formKey = GlobalKey<FormState>();
  final _loginCtrl = TextEditingController(); // login = email ou phone
  bool loading = false;

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;

    final login = _loginCtrl.text.trim();
    setState(() => loading = true);

<<<<<<< HEAD:lib/App/Modules/Connexion/View/motDePasseOublier.dart
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.forgotPassword(login);

    setState(() => loading = false);

    if (success == true) {
      showMessageComponent(
        context,
        'Un OTP a été envoyé à $login',
        'Succès',
        false,
      );
      Get.to(() => OtpPage(login: login));
    } else {
      showMessageComponent(
        context,
        auth.errorMessage ?? 'Erreur lors de l’envoi de l’OTP',
        'Erreur',
        true,
      );
=======
    try {
      // Simulation d’un appel API
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        showMessageComponent(
          context,
          'Un lien de réinitialisation a été envoyé à $email',
          'Succès',
          false,
        );
        Get.back();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => loading = false);
>>>>>>> main:lib/App/Modules/Authentification/View/motDePasseOublier.dart
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/bgimage2.jpg', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
<<<<<<< HEAD:lib/App/Modules/Connexion/View/motDePasseOublier.dart
          Column(
            children: [
              const Spacer(flex: 2),
=======

          /// 🔹 Bouton retour (icône circulaire)
          Positioned(
            top: 45,
            left: 16,
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

          /// 🔹 Contenu principal
          Column(
            children: [
              const Spacer(flex: 2),

              /// 🔸 Titre principal
>>>>>>> main:lib/App/Modules/Authentification/View/motDePasseOublier.dart
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Mot de passe oublié',
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
                      'Recevez un lien de réinitialisation',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 1),
<<<<<<< HEAD:lib/App/Modules/Connexion/View/motDePasseOublier.dart
=======

              /// 🔸 Formulaire (fond blanc)
>>>>>>> main:lib/App/Modules/Authentification/View/motDePasseOublier.dart
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
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
                      /// Champ email
                      FormWidget(
                        controller: _loginCtrl,
                        prefixIcon: const Icon(Icons.person_outlined, color: Colors.black54),
                        hintText: "Email ou Téléphone",
                        obscureText: false,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Veuillez saisir votre login';
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),
                      GestureDetector(
                        onTap: loading ? null : _handleReset,
                        child: ButtonComponent(
                          textButton: loading ? 'Envoi en cours...' : 'Envoyer',
                        ),
                      ),
                      const SizedBox(height: 16),
<<<<<<< HEAD:lib/App/Modules/Connexion/View/motDePasseOublier.dart
=======

                      /// Lien retour à la connexion
                      GestureDetector(
                        onTap: () =>
                            Get.to(OtpPage(email: _emailCtrl.text.trim())),
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
>>>>>>> main:lib/App/Modules/Authentification/View/motDePasseOublier.dart
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
