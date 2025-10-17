import 'package:drink_eazy/App/Component/button_component.dart';
import 'package:drink_eazy/App/Component/showMessage_component.dart';
import 'package:drink_eazy/App/Modules/Account/View/accountPage.dart';
import 'package:drink_eazy/App/Modules/Connexion/Controller/controller.dart';
import 'package:drink_eazy/App/Modules/Connexion/View/inscription.dart';
import 'package:drink_eazy/App/Modules/Connexion/View/motDePasseOublier.dart';
import 'package:drink_eazy/Utils/form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnexionPage extends StatefulWidget {
  final Future<void> Function(String email, String password)? onLogin;

  const ConnexionPage({Key? key, this.onLogin}) : super(key: key);

  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool loading = false;
  bool remember = false;

  Future<void> _handleLogin() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    setState(() => loading = true);
    try {
      if (widget.onLogin != null) {
        await widget.onLogin!(email, password);
      } else {
        await Future.delayed(const Duration(seconds: 1));
        debugPrint('Login with $email / $password (remember=$remember)');
      }
      if (mounted) {
        showMessageComponent(context, 'Connexion réussie', 'Succès', false);
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

          /// 🔹 Filtre sombre transparent
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),

          /// 🔹 Contenu principal
          Column(
            children: [
              const Spacer(flex: 2),

              /// 🔹 Titre centré verticalement (comme la SplashPage)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                      'Connectez-vous pour commander',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    // Retour à la page de home
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: GestureDetector(
                        onTap: () => Get.to(AccountPage()),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Retour',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 1),

              /// 🔹 Zone blanche arrondie (Formulaire)
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
                      /// Champ Email
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

                      /// Champ Mot de passe
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

                      /// 🔹 Lien "Mot de passe oublié ?"
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Get.snackbar(
                              'Mot de passe oublié',
                              'Fonctionnalité à venir 🔐',
                              backgroundColor: Colors.black87,
                              colorText: Colors.white,
                              duration: const Duration(seconds: 2),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => MotDePasseOubliePage());
                              },
                              child: Text(
                                "Mot de passe oublié ?",
                                style: TextStyle(
                                  color: Colors.red.shade800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      /// Bouton connexion
                      GestureDetector(
                        onTap: loading ? null : () => _handleLogin(),
                        child: ButtonComponent(textButton: 'Se connecter'),
                      ),
                      const SizedBox(height: 16),

                      /// Lien inscription
                      GestureDetector(
                        onTap: () {
                          Get.to(InscriptionPage());
                        },
                        child: Center(
                          child: Text.rich(
                            TextSpan(
                              text: "Pas de compte ? ",
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
