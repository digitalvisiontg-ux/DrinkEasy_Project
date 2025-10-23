import 'package:drink_eazy/App/Component/button_component.dart';
import 'package:drink_eazy/App/Component/showMessage_component.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/nouveauMotDePasse.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';

class OtpPage extends StatefulWidget {
  final String login; // email ou phone

  const OtpPage({Key? key, required this.login}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _otpController = TextEditingController();
  bool loading = false;

  Future<void> _verifyOtp() async {
    if (_otpController.text.length != 6) {
      showMessageComponent(context, "Code invalide", "Erreur", true);
      return;
    }

    setState(() => loading = true);
<<<<<<< HEAD:lib/App/Modules/Connexion/View/otp.dart
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.verifyOtp(
      widget.login,
      _otpController.text.trim(),
    );

    setState(() => loading = false);

    if (success == true) {
      // ← Utiliser success == true
      showMessageComponent(
        context,
        "OTP vérifié avec succès ✅",
        "Succès",
        false,
      );
      Get.to(
        () => NouveauMotDePassePage(
          login: widget.login,
          otp: _otpController.text.trim(),
        ),
      );
    } else {
      showMessageComponent(
        context,
        auth.errorMessage ?? "Code OTP invalide",
        "Erreur",
        true,
      );
=======
    try {
      // Simulation de vérification OTP
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        showMessageComponent(
          context,
          "Vérification réussie ✅",
          "Succès",
          false,
        );

        // 🔹 Redirige vers la création du nouveau mot de passe
        Get.to(() => NouveauMotDePassePage(email: widget.email));
      }
    } catch (e) {
      if (mounted) {
        showMessageComponent(
          context,
          "Une erreur s'est produite : ${e.toString()}",
          "Erreur",
          true,
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
>>>>>>> main:lib/App/Modules/Authentification/View/otp.dart
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/bgimage2.jpg', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
<<<<<<< HEAD:lib/App/Modules/Connexion/View/otp.dart
          Column(
            children: [
              const Spacer(flex: 2),
=======

          /// 🔹 Bouton retour
          Positioned(
            top: 45,
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

          /// 🔹 Contenu principal
          Column(
            children: [
              const Spacer(flex: 2),

              /// 🔸 Titre principal
>>>>>>> main:lib/App/Modules/Authentification/View/otp.dart
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Vérification OTP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontFamily: 'Agbalumo',
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Code envoyé à ${widget.login}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 1),
<<<<<<< HEAD:lib/App/Modules/Connexion/View/otp.dart
=======

              /// 🔸 Bloc blanc
>>>>>>> main:lib/App/Modules/Authentification/View/otp.dart
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 28,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Entrez le code à 6 chiffres reçu",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black87, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Pinput(
                        controller: _otpController,
                        length: 6,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.shade700),
                          ),
                        ),
                        showCursor: true,
                      ),
                    ),
                    const SizedBox(height: 28),
                    GestureDetector(
                      onTap: loading ? null : _verifyOtp,
                      child: ButtonComponent(
                        textButton: loading
                            ? "Vérification..."
                            : "Vérifier le code",
                      ),
                    ),
<<<<<<< HEAD:lib/App/Modules/Connexion/View/otp.dart
=======

                    const SizedBox(height: 16),

                    /// Lien de renvoi
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => NouveauMotDePassePage(email: widget.email),
                        );
                      },
                      child: Center(
                        child: Text.rich(
                          TextSpan(
                            text: "Vous n’avez pas reçu de code ? ",
                            style: TextStyle(color: Colors.grey.shade600),
                            children: [
                              TextSpan(
                                text: "Renvoyer",
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
                    const SizedBox(height: 10),
>>>>>>> main:lib/App/Modules/Authentification/View/otp.dart
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
