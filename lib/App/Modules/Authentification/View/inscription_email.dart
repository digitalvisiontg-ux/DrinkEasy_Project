import 'package:drink_eazy/App/Component/error_popup_component.dart';
import 'package:drink_eazy/App/Component/showMessage_component.dart';
import 'package:drink_eazy/App/Modules/Home/View/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'package:get/get.dart';
import 'package:drink_eazy/App/Component/button_component.dart';
import 'package:drink_eazy/Utils/form.dart';

class InscriptionEmailPage extends StatefulWidget {
  const InscriptionEmailPage({Key? key}) : super(key: key);

  @override
  State<InscriptionEmailPage> createState() => _InscriptionEmailPageState();
}

class _InscriptionEmailPageState extends State<InscriptionEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool loading = false;

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordCtrl.text != _confirmCtrl.text) {
      showErrorPopupComponent(
        context,
        title: "Erreur",
        message: "Les mots de passe ne correspondent pas ❌",
      );

      return;
    }

    setState(() => loading = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userData = {
      'name': _usernameCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'password': _passwordCtrl.text,
      'password_confirmation': _confirmCtrl.text,
    };
    final result = await auth.register(userData);
    setState(() => loading = false);

    if (result['success'] == true) {
      showMessageComponent(
        context,
        result['message'] ?? "Inscription réussie 🎉",
        "Succès",
        false,
      );
      await Future.delayed(const Duration(milliseconds: 800));
      Get.offAll(() => const Home());
    } else {
      showErrorPopupComponent(
        context,
        title: "Erreur",
        message: result['error'] ?? "Erreur lors de l'inscription",
      );
    }
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          /// --- Image de fond ---
          Positioned.fill(
            child: Image.asset("assets/images/bgimage2.jpg", fit: BoxFit.cover),
          ),

          /// --- Filtre sombre ---
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),

          /// --- Contenu principal ---
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
                          /// --- Bouton retour rond ---
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
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// --- Logo + titre ---
                          Column(
                            children: const [
                              Text(
                                "DrinkEazy",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Agbalumo",
                                  fontSize: 40,
                                  letterSpacing: 1.3,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Inscription par e-mail",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          /// --- Bloc Formulaire ---
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.06,
                              vertical: 30,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(35),
                              ),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(height: 10),

                                  /// --- Champ Nom ---
                                  FormWidget(
                                    controller: _usernameCtrl,
                                    prefixIcon: const Icon(
                                      Icons.person_outline,
                                      color: Colors.black54,
                                    ),
                                    hintText: "Nom d'utilisateur",
                                    obscureText: false,
                                    validator: (v) => v == null || v.isEmpty
                                        ? "Entrez votre nom"
                                        : null,
                                  ),
                                  const SizedBox(height: 16),

                                  /// --- Email ---
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

                                  /// --- Mot de passe ---
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

                                  /// --- Confirmer mot de passe ---
                                  FormWidget(
                                    controller: _confirmCtrl,
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: Colors.black54,
                                    ),
                                    hintText: "Confirmer le mot de passe",
                                    obscureText: true,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'Veuillez confirmer le mot de passe';
                                      }
                                      if (v != _passwordCtrl.text) {
                                        return 'Les mots de passe ne correspondent pas';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 28),

                                  /// --- Bouton inscription ---
                                  AbsorbPointer(
                                    absorbing: loading,
                                    child: ButtonComponent(
                                      textButton: loading
                                          ? "Inscription en cours..."
                                          : "S'inscrire",
                                      onPressed: loading
                                          ? null
                                          : _handleRegister,
                                    ),
                                  ),
                                  const SizedBox(height: 18),

                                  /// --- Lien retour vers connexion ---
                                  GestureDetector(
                                    onTap: () => Get.toNamed('/connexion'),
                                    child: Center(
                                      child: Text.rich(
                                        TextSpan(
                                          text: "Déjà un compte ? ",
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "Se connecter",
                                              style: TextStyle(
                                                color: Colors.red.shade700,
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
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
