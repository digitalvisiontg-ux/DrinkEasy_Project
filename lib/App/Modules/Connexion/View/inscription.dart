import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'package:drink_eazy/App/Component/button_component.dart';
import 'package:drink_eazy/App/Modules/Authentification/Controller/controller.dart';
import 'package:drink_eazy/App/Modules/Home/View/home.dart';
import 'package:drink_eazy/Utils/form.dart' hide validateEmail, validatePassword;
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({super.key});

  @override
  State<InscriptionPage> createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();

  bool loading = false;

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final passwordConfirm = passwordConfirmController.text.trim();

    final success = await auth.register({
      'name': name,
      'email': email.isEmpty ? null : email,
      'phone': phone.isEmpty ? null : phone,
      'password': password,
      'password_confirmation': passwordConfirm,
    });

    setState(() => loading = false);

    if (success == true) {  
      print('8');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inscription réussie')),
      );
      print('9');
      Get.offAll(() => const Home()); // 🔹 Redirige vers la HomePage
      print('10');
    } else {
      final msg = auth.errorMessage ?? 'Erreur inscription';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/bgimage2.jpg', fit: BoxFit.cover),
          ),
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
                            'Créez votre compte',
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
                                  Icon(Icons.arrow_back, color: Colors.white, size: 16),
                                  SizedBox(width: 6),
                                  Text(
                                    'Retour à la page précédente',
                                    style: TextStyle(color: Colors.white, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 1),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FormWidget(
                              controller: nameController,
                              prefixIcon: const Icon(Icons.person_outline, color: Colors.black54),
                              hintText: "Nom d'utilisateur",
                              obscureText: false,
                              validator: (val) =>
                                  val == null || val.isEmpty ? "Entrez votre nom" : null,
                            ),
                            const SizedBox(height: 16),
                            FormWidget(
                              controller: phoneController,
                              prefixIcon: const Icon(Icons.phone_outlined, color: Colors.black54),
                              hintText: "Numéro de téléphone",
                              obscureText: false,
                              validator: validatePhone,
                            ),
                            const SizedBox(height: 16),
                            FormWidget(
                              controller: emailController,
                              prefixIcon: const Icon(Icons.email_outlined, color: Colors.black54),
                              hintText: "Adresse e-mail",
                              obscureText: false,
                              validator: validateEmail,
                            ),
                            const SizedBox(height: 16),
                            FormWidget(
                              controller: passwordController,
                              prefixIcon: const Icon(Icons.lock_outline, color: Colors.black54),
                              hintText: "Mot de passe",
                              obscureText: true,
                              validator: validatePassword,
                            ),
                            const SizedBox(height: 16),
                            FormWidget(
                              controller: passwordConfirmController,
                              prefixIcon: const Icon(Icons.lock_outline, color: Colors.black54),
                              hintText: "Confirmer le mot de passe",
                              obscureText: true,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Confirmez le mot de passe";
                                } else if (val != passwordController.text) {
                                  return "Les mots de passe ne correspondent pas";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 28),
                            GestureDetector(
                              onTap: loading ? null : _handleRegister,
                              child: ButtonComponent(
                                textButton:
                                    loading ? 'Création en cours...' : 'Créer un compte',
                              ),
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () => Get.back(),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
