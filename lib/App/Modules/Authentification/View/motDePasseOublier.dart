import 'package:drink_eazy/App/Component/button_component.dart';
import 'package:drink_eazy/App/Component/error_popup_component.dart';
import 'package:drink_eazy/App/Component/showMessage_component.dart';
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
  final _loginCtrl = TextEditingController();
  bool loading = false;

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;

    final login = _loginCtrl.text.trim();
    setState(() => loading = true);

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.forgotPassword(login);

    setState(() => loading = false);

    if (success == true) {
      showMessageComponent(
        context,
        auth.errorMessage ?? 'Un code OTP a été envoyé à $login',
        'Succès',
        false,
      );
      await Future.delayed(const Duration(milliseconds: 800));
      Get.toNamed('/otp', arguments: {'login': login, 'isReset': true});
    } else {
      showErrorPopupComponent(
        context,
        title: 'Erreur',
        message: auth.errorMessage ?? 'Erreur lors de l’envoi du code.',
      );
    }
  }

  @override
  void dispose() {
    _loginCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          /// --- Image de fond
          Positioned.fill(
            child: Image.asset('assets/images/bgimage2.jpg', fit: BoxFit.cover),
          ),

          /// --- Filtre sombre
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.55)),
          ),

          /// --- Bouton retour (même style que la connexion)
          Positioned(
            top: size.height * 0.05,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: size.width * 0.06,
                ),
              ),
            ),
          ),

          /// --- Contenu principal
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          SizedBox(height: size.height * 0.12),

                          /// --- Titre principal
                          Column(
                            children: [
                              Text(
                                'Mot de passe oublié',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * 0.08,
                                  fontFamily: 'Agbalumo',
                                  letterSpacing: 1.1,
                                ),
                              ),
                              SizedBox(height: size.height * 0.01),
                              Text(
                                'Recevez un code de réinitialisation',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: size.width * 0.04,
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          /// --- Bloc blanc du bas (formulaire)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.06,
                              vertical: 28,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(32),
                              ),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  /// --- Champ de saisie
                                  FormWidget(
                                    controller: _loginCtrl,
                                    prefixIcon: const Icon(
                                      Icons.person_outline,
                                      color: Colors.black54,
                                    ),
                                    hintText: "E-mail ou Téléphone",
                                    obscureText: false,
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'Veuillez saisir votre e-mail ou numéro de téléphone';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 24),

                                  /// --- Bouton envoyer
                                  AbsorbPointer(
                                    absorbing: loading,
                                    child: ButtonComponent(
                                      textButton: loading
                                          ? "Envoi en cours..."
                                          : "Envoyer le code",
                                      onPressed: loading ? null : _handleReset,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  /// --- Lien retour connexion
                                  GestureDetector(
                                    onTap: () => Get.toNamed('/connexion'),
                                    child: Center(
                                      child: Text.rich(
                                        textAlign: TextAlign.center,
                                        TextSpan(
                                          text:
                                              "Vous souvenez de votre mot de passe ? ",
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: size.width * 0.036,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "Se connecter",
                                              style: TextStyle(
                                                color: Colors.red.shade700,
                                                fontWeight: FontWeight.w600,
                                                fontSize: size.width * 0.038,
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
