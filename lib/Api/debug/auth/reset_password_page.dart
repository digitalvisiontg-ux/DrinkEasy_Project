import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'home_page.dart'; // 🔹 Import de HomePage

class ResetPasswordPage extends StatefulWidget {
  final String login;
  final String otp;

  const ResetPasswordPage({
    super.key,
    required this.login,
    required this.otp,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Réinitialiser le mot de passe'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Réinitialisez votre mot de passe pour ${widget.login}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nouveau mot de passe',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmer le mot de passe',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            auth.isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final password = passwordController.text.trim();
                        final confirm = confirmController.text.trim();

                        if (password.isEmpty || confirm.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Veuillez remplir tous les champs')),
                          );
                          return;
                        }

                        if (password != confirm) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Les mots de passe ne correspondent pas')),
                          );
                          return;
                        }

                        final success = await auth.resetPassword(
                          widget.login,
                          widget.otp,
                          password,
                          confirm,
                        );

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Mot de passe réinitialisé avec succès')),
                          );
                          // 🔹 Redirection vers HomePage après succès
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                            (route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(auth.errorMessage ?? 'Erreur lors de la réinitialisation'),
                            ),
                          );
                        }
                      },
                      child: const Text('Réinitialiser le mot de passe'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
