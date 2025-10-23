import 'package:drink_eazy/App/Component/button_component.dart';
import 'package:drink_eazy/App/Component/showMessage_component.dart';
import 'package:drink_eazy/App/Modules/Authentification/Controller/controller.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/connexion.dart';
import 'package:drink_eazy/Utils/form.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class InscriptionPhonePage extends StatefulWidget {
  final Future<void> Function(String phone, String password, String username)?
  onRegister;

  const InscriptionPhonePage({Key? key, this.onRegister}) : super(key: key);

  @override
  State<InscriptionPhonePage> createState() => _InscriptionPhonePageState();
}

class _InscriptionPhonePageState extends State<InscriptionPhonePage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
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

    final phone = _phoneCtrl.text.trim();
    final password = _passwordCtrl.text;
    final username = _usernameCtrl.text.trim();

    setState(() => loading = true);
    try {
      if (widget.onRegister != null) {
        await widget.onRegister!(phone, password, username);
      } else {
        await Future.delayed(const Duration(seconds: 1));
        debugPrint('Register (phone): $username / $phone');
      }

      if (mounted) {
        showMessageComponent(
          context,
          'Inscription réussie 🎉',
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
  void dispose() {
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _usernameCtrl.dispose();
    super.dispose();
  }

  String? validatePhoneLocal(String? value) {
    if (value == null || value.isEmpty) {
      return "Entrez votre numéro de téléphone";
    }
    final phoneRegExp = RegExp(r'^\+?[0-9]{8,15}$');
    if (!phoneRegExp.hasMatch(value)) {
      return "Numéro de téléphone invalide";
    }
    return null;
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

          /// 🔹 Bouton retour
          Positioned(
            top: 50,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ),
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
                      'Inscription par téléphone',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 3),

              /// 🔹 Zone blanche du formulaire
              Expanded(
                flex: 7,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 28,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
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

                          /// Numéro de téléphone
                          FormWidget(
                            controller: _phoneCtrl,
                            prefixIcon: const Icon(
                              Icons.phone_outlined,
                              color: Colors.black54,
                            ),
                            hintText: "Numéro de téléphone",
                            obscureText: false,
                            validator: validatePhoneLocal,
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
                          const SizedBox(height: 16),

                          /// Bouton d'inscription
                          GestureDetector(
                            onTap: loading ? null : () => _handleRegister(),
                            child: ButtonComponent(
                              textButton: 'Créer un compte',
                            ),
                          ),
                          const SizedBox(height: 16),

                          /// Lien pour retourner à la connexion
                          GestureDetector(
                            onTap: () => Get.to(ConnexionPage()),
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
