import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'verify_otp_page.dart';

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

                      final success = await auth.forgotPassword(login);

                      if (success != null) {
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
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(auth.errorMessage ?? 'Erreur lors de l’envoi de l’OTP')),
                        );
                      }
                    },
                    child: const Text('Envoyer OTP'),
                  ),
          ],
        ),
      ),
    );
  }
}
