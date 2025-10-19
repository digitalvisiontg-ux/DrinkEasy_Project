import 'package:drink_eazy/Api/debug/auth/home_page.dart';
import 'package:drink_eazy/Api/debug/auth/register_test_page.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'forgot_password_page.dart';

class LoginTestPage extends StatefulWidget {
  const LoginTestPage({super.key});

  @override
  State<LoginTestPage> createState() => _LoginTestPageState();
}

class _LoginTestPageState extends State<LoginTestPage> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion Test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: loginController,
              decoration: const InputDecoration(
                labelText: 'Email ou téléphone',
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
            ),
            const SizedBox(height: 20),
            auth.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      final login = loginController.text.trim();
                      final password = passwordController.text.trim();

                      final success = await auth.login(login, password);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Connexion réussie')),
                        );
                        // 🔹 Redirection vers HomePage après connexion
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(auth.errorMessage ?? 'Erreur login'),
                          ),
                        );
                      }
                    },
                    child: const Text('Se connecter'),
                  ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterTestPage()),
                  ),
                  child: const Text("S'inscrire"),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordPage(),
                    ),
                  ),
                  child: const Text("Mot de passe oublié"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
