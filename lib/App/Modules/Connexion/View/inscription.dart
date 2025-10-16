import 'package:drink_eazy/App/Component/button_component.dart';
import 'package:drink_eazy/App/Component/showMessage_component.dart';
import 'package:drink_eazy/App/Modules/Connexion/Controller/controller.dart';
import 'package:drink_eazy/Utils/form.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class InscriptionPage extends StatefulWidget {
  final Future<void> Function(String email, String password, String username)?
  onRegister;

  const InscriptionPage({Key? key, this.onRegister}) : super(key: key);

  @override
  State<InscriptionPage> createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();

  bool loading = false;

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordCtrl.text != _confirmCtrl.text) {
      showMessageComponent(
        context,
        "Les mots de passe ne correspondent pas ❌",
        "Erreur",
        true,
      );
      return;
    }

    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    final username = _usernameCtrl.text.trim();

    setState(() => loading = true);
    try {
      if (widget.onRegister != null) {
        await widget.onRegister!(email, password, username);
      } else {
        await Future.delayed(const Duration(seconds: 1));
        debugPrint('Register: $username / $email');
      }

      if (mounted) {
        showMessageComponent(
          context,
          'Inscription réussie 🎉',
          'Succès',
          false,
        );
        Get.back(); // Retour à la page de connexion
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
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _usernameCtrl.dispose();
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

          /// 🔹 Contenu principal
          Column(
            children: [
              const Spacer(flex: 2),

              /// 🔹 Titre centré
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'DrinkEazy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 44,
                        fontFamily: 'Agbalumo',
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Créez votre compte',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 1),

              /// 🔹 Zone blanche du formulaire
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
                      /// Nom d'utilisateur
                      FormWidget(
                        controller: _usernameCtrl,
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: Colors.black54,
                        ),
                        hintText: "Nom d'utilisateur",
                        obscureText: false,
                        validator: (val) => val == null || val.isEmpty
                            ? "Entrez votre nom"
                            : null,
                      ),
                      const SizedBox(height: 16),

                      /// Email
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
                      const SizedBox(height: 16),

                      /// Mot de passe
                      FormWidget(
                        controller: _passwordCtrl,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.black54,
                        ),
                        hintText: "Mot de passe",
                        obscureText: true,
                        validator: validatePassword,
                      ),
                      const SizedBox(height: 16),

                      /// Confirmation mot de passe
                      FormWidget(
                        controller: _confirmCtrl,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.black54,
                        ),
                        hintText: "Confirmer le mot de passe",
                        obscureText: true,
                        validator: validatePassword,
                      ),
                      const SizedBox(height: 28),

                      /// Bouton d'inscription
                      GestureDetector(
                        onTap: loading ? null : () => _handleRegister(),
                        child: ButtonComponent(textButton: 'Créer un compte'),
                      ),
                      const SizedBox(height: 16),

                      /// Lien pour retourner à la connexion
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Center(
                          child: Text.rich(
                            TextSpan(
                              text: "Déjà un compte ? ",
                              style: TextStyle(color: Colors.grey.shade600),
                              children: [
                                TextSpan(
                                  text: "Se connecter",
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
