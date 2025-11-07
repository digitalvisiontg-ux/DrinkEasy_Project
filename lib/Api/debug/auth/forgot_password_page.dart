import 'package:drink_eazy/Api/debug/auth/verify_otp_page.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController loginController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Mot de passe oublié')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: loginController,
              decoration: const InputDecoration(
                labelText: 'Email ou Téléphone',
              ),
            ),
            const SizedBox(height: 20),
            auth.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      final login = loginController.text.trim();

                      // final success = await auth.forgotPassword(login);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('OTP envoyé avec succès')),
                      );

                      // Redirection vers la page de vérification OTP
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VerifyOtpPage(login: login),
                        ),
                      );
                    },
                    child: const Text('Envoyer OTP'),
                  ),
          ],
        ),
      ),
    );
  }
}
