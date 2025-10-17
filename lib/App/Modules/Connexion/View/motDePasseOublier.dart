import 'package:drink_eazy/App/Component/button_component.dart';
import 'package:drink_eazy/App/Component/showMessage_component.dart';
import 'package:drink_eazy/App/Modules/Connexion/Controller/controller.dart';
import 'package:drink_eazy/App/Modules/Connexion/View/otp.dart';
import 'package:drink_eazy/Utils/form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MotDePasseOubliePage extends StatefulWidget {
  const MotDePasseOubliePage({Key? key}) : super(key: key);

  @override
  State<MotDePasseOubliePage> createState() => _MotDePasseOubliePageState();
}

class _MotDePasseOubliePageState extends State<MotDePasseOubliePage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool loading = false;

  Future<void> _handleReset() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final email = _emailCtrl.text.trim();
    setState(() => loading = true);

    try {
      // Simule une requête API
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        showMessageComponent(
          context,
          'Un lien de réinitialisation a été envoyé à $email',
          'Succès',
          false,
        );
        Get.back(); // Retour à la page précédente
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
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

          /// 🔹 Filtre sombre transparent
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),

          /// 🔹 Contenu principal
          Column(
            children: [
              const Spacer(flex: 2),

              /// Titre principal
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

              /// Formulaire (fond blanc)
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
                        controller: _emailCtrl,
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.black54,
                        ),
                        hintText: "Adresse e-mail",
                        obscureText: false,
                        validator: validateEmail,
                      ),
                      const SizedBox(height: 28),

                      /// Bouton d’envoi
                      GestureDetector(
                        onTap: loading ? null : _handleReset,
                        child: ButtonComponent(
                          textButton: loading ? 'Envoi en cours...' : 'Envoyer',
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// Lien retour
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
