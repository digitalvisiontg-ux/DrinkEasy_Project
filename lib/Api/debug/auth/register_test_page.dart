import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart'; // 🔹 Import de la HomePage

class RegisterTestPage extends StatefulWidget {
  const RegisterTestPage({super.key});

  @override
  State<RegisterTestPage> createState() => _RegisterTestPageState();
}

class _RegisterTestPageState extends State<RegisterTestPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Inscription Test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email (optionnel)'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Téléphone (optionnel)'),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Mot de passe'),
              ),
              TextField(
                controller: passwordConfirmController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirmer le mot de passe'),
              ),
              const SizedBox(height: 20),
              auth.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
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

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Inscription réussie')),
                          );
                          // 🔹 Redirection vers HomePage après inscription
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(auth.errorMessage ?? 'Erreur inscription')),
                          );
                        }
                      },
                      child: const Text("S'inscrire"),
                    ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                ),
                child: const Text("Déjà un compte ? Se connecter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
