import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'package:drink_eazy/App/Component/button_component.dart';
import 'package:drink_eazy/App/Modules/Authentification/Controller/controller.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/motDePasseOublier.dart';
import 'package:drink_eazy/App/Modules/Home/View/home.dart';
import 'package:drink_eazy/App/Modules/Connexion/View/inscription.dart';
import 'package:drink_eazy/Utils/form.dart' hide validatePassword;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ConnexionPage extends StatefulWidget {
  const ConnexionPage({super.key});

  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loading = false;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    final login = loginController.text.trim();
    final password = passwordController.text.trim();

    final success = await auth.login(login, password);

    setState(() => loading = false);

    if (success == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connexion réussie ✅')),
      );
      Get.offAll(() => const Home());
    } else {
      final msg = auth.errorMessage ?? 'Erreur de connexion';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    }
  }

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

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
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),

          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: height),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    /// 🔹 Titre & sous-titre
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'DrinkEazy',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 44,
                              fontFamily: 'Agbalumo',
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Connectez-vous pour commander',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
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
                              onTap: () => Get.back(),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.arrow_back,
                                      color: Colors.white, size: 16),
                                  SizedBox(width: 6),
                                  Text(
                                    'Retour à la page précédente',
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

                    /// 🔹 Formulaire
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 28),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(32)),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FormWidget(
                              controller: loginController,
                              prefixIcon: const Icon(Icons.person_outlined,
                                  color: Colors.black54),
                              hintText: "email ou téléphone",
                              obscureText: false,
                              validator: validateLogin, 
                            ),
                            const SizedBox(height: 16),
                            FormWidget(
                              controller: passwordController,
                              prefixIcon: const Icon(Icons.lock_outline,
                                  color: Colors.black54),
                              hintText: "Mot de passe",
                              obscureText: true,
                              validator: validatePassword,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => const MotDePasseOubliePage());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
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
                            const SizedBox(height: 28),
                            GestureDetector(
                              onTap: loading ? null : _handleLogin,
                              child: ButtonComponent(
                                textButton: loading
                                    ? 'Connexion en cours...'
                                    : 'Se connecter',
                              ),
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () => Get.to(() => const InscriptionPage()),
                              child: Center(
                                child: Text.rich(
                                  TextSpan(
                                    text: "Pas de compte ? ",
                                    style:
                                        TextStyle(color: Colors.grey.shade600),
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}