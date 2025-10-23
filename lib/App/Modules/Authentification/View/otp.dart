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
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.verifyOtp(
      widget.login,
      _otpController.text.trim(),
    );
    setState(() => loading = false);

    if (success == true) {
      // Afficher le message du backend si disponible, sinon message par défaut
      showMessageComponent(
        context,
        auth.errorMessage == null || auth.errorMessage!.isEmpty
            ? "OTP vérifié avec succès ✅"
            : auth.errorMessage!,
        "Succès",
        false,
      );
      // Attendre un peu pour UX
      await Future.delayed(const Duration(milliseconds: 800));
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
                    AbsorbPointer(
                      absorbing: loading,
                      child: GestureDetector(
                        onTap: loading ? null : _verifyOtp,
                        child: ButtonComponent(
                          textButton: loading
                              ? "Vérification..."
                              : "Vérifier le code",
                        ),
                      ),
                    ),
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
