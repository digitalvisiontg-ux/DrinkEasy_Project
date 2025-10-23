import 'package:drink_eazy/App/Component/button_component.dart';
import 'package:drink_eazy/App/Component/showMessage_component.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/otp.dart';
import 'package:drink_eazy/Utils/form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';

class MotDePasseOubliePage extends StatefulWidget {
  const MotDePasseOubliePage({Key? key}) : super(key: key);

  @override
  State<MotDePasseOubliePage> createState() => _MotDePasseOubliePageState();
}

class _MotDePasseOubliePageState extends State<MotDePasseOubliePage> {
  final _formKey = GlobalKey<FormState>();
  final _loginCtrl = TextEditingController(); // login = email ou phone
  bool loading = false;

  Future<void> _handleReset() async {
    print("1");
    if (!_formKey.currentState!.validate()) return;
    print("12");

    final login = _loginCtrl.text.trim();
    print("13");
    setState(() => loading = true);
    print("1");
    final auth = Provider.of<AuthProvider>(context, listen: false);
    print("14");
    final success = await auth.forgotPassword(login);
    print("15");
    setState(() => loading = false);
    print("16");

    if (success == true) {
    print("17");
    print("18");
      showMessageComponent(
        context,
        auth.errorMessage ?? 'Un OTP a été envoyé à $login',
        'Succès',
        false,
      );
    print("19");
      await Future.delayed(const Duration(milliseconds: 800));
    print("100");
      Get.to(() => OtpPage(login: login));
    print("11");
    } else {
    print("122");
      showMessageComponent(
        context,
        auth.errorMessage ?? 'Erreur lors de l’envoi de l’OTP',
        'Erreur',
        true,
      );
    print("133");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/bgimage2.jpg', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),

          /// 🔹 Bouton retour (icône circulaire)
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
                  children: const [
                    Text(
                      'Mot de passe oublié',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontFamily: 'Agbalumo',
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Recevez un code de réinitialisation',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Champ email
                      FormWidget(
                        controller: _loginCtrl,
                        prefixIcon: const Icon(Icons.person_outlined, color: Colors.black54),
                        hintText: "Email ou Téléphone",
                        obscureText: false,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Veuillez saisir votre email ou nueméro de téléphone';
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),
                      AbsorbPointer(
                        absorbing: loading,
                        child: GestureDetector(
                          onTap: loading ? null : _handleReset,
                          child: ButtonComponent(
                            textButton: loading ? 'Envoi en cours...' : 'Envoyer',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
