import 'package:drink_eazy/App/Component/button_component.dart';
import 'package:drink_eazy/App/Component/showMessage_component.dart';
import 'package:drink_eazy/App/Modules/Authentification/Controller/controller.dart';
// import 'package:drink_eazy/App/Modules/Authentification/Controller/controller.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/connexion.dart';
import 'package:drink_eazy/App/Modules/Home/View/home.dart';
import 'package:drink_eazy/Utils/form.dart' hide validatePassword;
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';

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

    setState(() => loading = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userData = {
      'name': _usernameCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim(),
      'password': _passwordCtrl.text,
      'password_confirmation': _confirmCtrl.text,
    };
    final result = await auth.register(userData);
    setState(() => loading = false);

    if (result['success'] == true) {
      showMessageComponent(
        context,
        result['message'] ?? 'Inscription réussie 🎉',
        'Succès',
        false,
      );
      await Future.delayed(const Duration(milliseconds: 800));
      Get.offAll(() => Home());
    } else {
      showMessageComponent(
        context,
        result['error'] ?? 'Erreur lors de l\'inscription',
        'Erreur',
        true,
      );
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
                          AbsorbPointer(
                            absorbing: loading,
                            child: ButtonComponent(
                              textButton: loading
                                  ? "Inscription en cours..."
                                  : "S'inscrire",
                              onPressed: loading ? null : _handleRegister,
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
