import 'dart:ui';
import 'package:drink_eazy/App/Modules/Authentification/Controller/controller.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:drink_eazy/App/Component/button_component.dart';
import 'package:drink_eazy/Utils/form.dart'
    hide validateEmail, validatePassword;
import 'package:drink_eazy/App/Modules/Home/View/home.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  /// ✅ Message de succès (toast stylé)
  void showSuccessToast(String message) {
    FToast fToast = FToast();
    fToast.init(context);

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.greenAccent, width: 2),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.check_circle, color: Colors.green, size: 24),
          SizedBox(width: 10),
          Text(
            "Connexion réussie 🎉",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 2),
    );
  }

  void _showErrorPopup(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 50,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Erreur de connexion",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        "OK",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

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
      showSuccessToast("Connexion réussie 🎉");
      await Future.delayed(const Duration(seconds: 1));
      Get.offAll(() => const Home());
    } else {
      _showErrorPopup(
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

          /// --- Bouton retour
          Positioned(
            top: size.height * 0.05,
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

          /// --- Contenu principal
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const SizedBox(height: 70),

                          /// --- Titre principal
                          Column(
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
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
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
                                    hintText: "Adresse e-mail",
                                    obscureText: false,
                                    validator: validateEmail,
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
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "Créer un compte",
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
