import 'package:drink_eazy/App/Component/error_popup_component.dart';
import 'package:drink_eazy/App/Component/showMessage_component.dart';
import 'package:drink_eazy/App/Modules/Authentification/Controller/controller.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:drink_eazy/App/Component/button_component.dart';
import 'package:drink_eazy/Utils/form.dart'
    hide validateEmail, validatePassword;
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

  /// 🧠 Gestion du login
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final login = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    final success = await auth.login(login, password);
    setState(() => loading = false);

    if (success == true) {
      // Affiche le showMessageComponent
      showMessageComponent(context, "Connexion réussie 🎉", "Succès", false);
      await Future.delayed(const Duration(seconds: 1));
      Get.offAll(() => const Home());
    } else {
      // Affiche le popup d'erreur
      showErrorPopupComponent(
        context,
        title: "Erreur",
        message:
            auth.errorMessage ??
            'Erreur lors de la connexion. Vérifiez vos identifiants.',
      );
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true, // 🔑 Clavier géré
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

          /// --- Contenu principal
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          SizedBox(height: size.height * 0.1),

                          /// --- Titre principal
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'DrinkEazy',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * 0.12,
                                  fontFamily: 'Agbalumo',
                                  letterSpacing: 1.2,
                                ),
                              ),
                              SizedBox(height: size.height * 0.01),
                              Text(
                                'Connectez-vous pour commander vos boissons',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: size.width * 0.04,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),

                          /// --- Zone blanche (formulaire)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.06,
                              vertical: 28,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(32),
                              ),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  /// --- Champ email
                                  FormWidget(
                                    controller: _emailCtrl,
                                    prefixIcon: const Icon(
                                      Icons.email_outlined,
                                      color: Colors.black54,
                                    ),
                                    hintText: "E-mail ou Téléphone",
                                    obscureText: false,
                                    validator: validateLogin,
                                  ),
                                  const SizedBox(height: 15),

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
                                          Get.toNamed('/mot_de_passe_oublie'),
                                      child: Text(
                                        "Mot de passe oublié ?",
                                        style: TextStyle(
                                          color: Colors.red.shade700,
                                          fontWeight: FontWeight.w500,
                                          fontSize: size.width * 0.038,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  /// --- Bouton connexion
                                  AbsorbPointer(
                                    absorbing: loading,
                                    child: ButtonComponent(
                                      textButton: loading
                                          ? "Connexion en cours..."
                                          : "Se connecter",
                                      onPressed: loading ? null : _handleLogin,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  /// --- Lien inscription
                                  GestureDetector(
                                    onTap: () =>
                                        Get.toNamed('/inscription_choice'),
                                    child: Center(
                                      child: Text.rich(
                                        TextSpan(
                                          text: "Pas de compte ? ",
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: size.width * 0.036,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "Créer un compte",
                                              style: TextStyle(
                                                color: Colors.red.shade700,
                                                fontWeight: FontWeight.w600,
                                                fontSize: size.width * 0.038,
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
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            // Utiliser le media query pour un bon resultat sur tous les écrans
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 0.0,
              left: MediaQuery.of(context).padding.left + 16.0,
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
