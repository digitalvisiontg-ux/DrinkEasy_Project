import 'package:drink_eazy/App/Component/button_component.dart';
import 'package:drink_eazy/App/Component/error_popup_component.dart';
import 'package:drink_eazy/App/Component/showMessage_component.dart';
import 'package:drink_eazy/App/Modules/Home/View/home.dart';
import 'package:drink_eazy/Utils/form.dart';
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
      Get.offAll(() => const Home());
    } else {
      showErrorPopupComponent(
        context,
        title: 'Erreur',
        message: result['error'] ?? 'Erreur lors de l\'inscription',
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          /// 🔹 Image de fond
          Positioned.fill(
            child: Image.asset('assets/images/bgimage2.jpg', fit: BoxFit.cover),
          ),

          /// 🔹 Filtre sombre
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.55)),
          ),

          /// 🔹 Contenu principal
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
                          /// 🔹 Bouton retour
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

                          /// 🔹 Titre centré
                          const SizedBox(height: 10),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'DrinkEazy',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontFamily: 'Agbalumo',
                                  letterSpacing: 1.2,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Inscription par téléphone',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          /// 🔹 Zone blanche du formulaire
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
                                    validator: (val) =>
                                        val == null || val.isEmpty
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
                                  const SizedBox(height: 20),

                                  /// Bouton d'inscription
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

                                  /// Lien vers la connexion
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
