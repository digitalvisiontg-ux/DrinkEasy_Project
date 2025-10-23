import 'package:drink_eazy/App/Modules/Account/View/accountPage.dart';
import 'package:drink_eazy/App/Modules/Authentification/Controller/controller.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/inscription_choice_page.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/inscription_email.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/motDePasseOublier.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:drink_eazy/App/Component/button_component.dart';
import 'package:drink_eazy/App/Component/showMessage_component.dart';
import 'package:drink_eazy/Utils/form.dart';
import 'package:drink_eazy/App/Modules/Home/View/home.dart';

class ConnexionPage extends StatefulWidget {
  const ConnexionPage({Key? key}) : super(key: key);

  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool loading = false;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulation
      if (mounted) {
        showMessageComponent(
          context,
          "Connexion réussie 🎉",
          "Bienvenue sur DrinkEazy",
          false,
        );
        Get.offAll(() => const Home());
      }
    } catch (e) {
      if (mounted) {
        showMessageComponent(
          context,
          "Erreur lors de la connexion ❌",
          "Vérifiez vos identifiants",
          true,
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// --- Image de fond
          Positioned.fill(
            child: Image.asset('assets/images/bgimage2.jpg', fit: BoxFit.cover),
          ),

          /// --- Filtre sombre
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.55)),
          ),

          /// --- Bouton retour (flèche stylée)
          Positioned(
            top: 45,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => Get.to(AccountPage()),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),

          /// --- Contenu principal
          Column(
            children: [
              const Spacer(flex: 3),

              /// --- Titre principal
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'DrinkEazy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 44,
                        fontFamily: 'Agbalumo',
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Connectez-vous pour commander vos boissons',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),

              /// --- Zone blanche (formulaire)
              Expanded(
                flex: 4,
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
                          /// --- Champ email
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
                          const SizedBox(height: 10),

                          /// --- Champ mot de passe
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

                          const SizedBox(height: 12),

                          /// --- Lien mot de passe oublié
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () =>
                                  Get.to(() => const MotDePasseOubliePage()),
                              child: Text(
                                "Mot de passe oublié ?",
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          /// --- Bouton connexion
                          GestureDetector(
                            onTap: loading ? null : _handleLogin,
                            child: ButtonComponent(textButton: "Se connecter"),
                          ),

                          const SizedBox(height: 16),

                          /// --- Lien inscription
                          GestureDetector(
                            onTap: () =>
                                Get.to(() => const InscriptionChoicePage()),
                            child: Center(
                              child: Text.rich(
                                TextSpan(
                                  text: "Pas encore de compte ? ",
                                  style: TextStyle(color: Colors.grey.shade600),
                                  children: [
                                    TextSpan(
                                      text: "Créer un compte",
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
