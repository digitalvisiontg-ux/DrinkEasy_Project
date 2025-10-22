import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'reset_password_page.dart';

class VerifyOtpPage extends StatefulWidget {
  final String login;

  const VerifyOtpPage({super.key, required this.login});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vérification du code OTP'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Entrez le code OTP envoyé à ${widget.login}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'Code OTP',
                border: OutlineInputBorder(),
                counterText: "",
              ),
            ),
            const SizedBox(height: 20),
            auth.isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final otp = otpController.text.trim();
                        if (otp.length != 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Le code OTP doit comporter 6 chiffres')),
                          );
                          return;
                        }

                        final response = await auth.verifyOtp(widget.login, otp);

                        if (response) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('OTP vérifié avec succès')),
                          );

                          // Redirection vers la page ResetPassword
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ResetPasswordPage(
                                login: widget.login,
                                otp: otp,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(auth.errorMessage ?? 'Code OTP invalide'),
                            ),
                          );
                        }
                      },
                      child: const Text('Vérifier le code'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
