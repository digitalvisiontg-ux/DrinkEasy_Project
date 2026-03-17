import 'package:drink_eazy/App/Component/button_component.dart';
import 'package:drink_eazy/App/Component/error_popup_component.dart';
import 'package:drink_eazy/App/Component/showMessage_component.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/connexion.dart';
import 'package:drink_eazy/Utils/form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';

class NouveauMotDePassePage extends StatefulWidget {
  final String login;
  final String otp;

  const NouveauMotDePassePage({
    Key? key,
    required this.login,
    required this.otp,
  }) : super(key: key);

  @override
  State<NouveauMotDePassePage> createState() => _NouveauMotDePassePageState();
}

class _NouveauMotDePassePageState extends State<NouveauMotDePassePage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool loading = false;

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    setState(() => loading = true);

    final success = await auth.resetPassword(
      widget.login,
      widget.otp,
      _passwordCtrl.text.trim(),
      _confirmPasswordCtrl.text.trim(),
    );

    setState(() => loading = false);

    if (success == true) {
      showMessageComponent(
        context,
        "Mot de passe réinitialisé 🎉",
        'Succès',
        false,
      );
      await Future.delayed(const Duration(seconds: 1));
      Get.offAll(() => const ConnexionPage());
    } else {
      showErrorPopupComponent(
        context,
        title: 'Erreur',
        message: auth.errorMessage ?? 'Erreur lors de la réinitialisation.',
      );
    }
  }

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
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
                          SizedBox(height: size.height * 0.15),
                          Text(
                            'Nouveau mot de passe',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * 0.08,
                              fontFamily: 'Agbalumo',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Définissez votre nouveau mot de passe',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: size.width * 0.04,
                            ),
                          ),

                          const Spacer(),

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
                                  FormWidget(
                                    controller: _passwordCtrl,
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: Colors.black54,
                                    ),
                                    hintText: "Nouveau mot de passe",
                                    obscureText: true,
                                    validator: validatePassword,
                                  ),
                                  const SizedBox(height: 16),
                                  FormWidget(
                                    controller: _confirmPasswordCtrl,
                                    prefixIcon: const Icon(
                                      Icons.lock_reset_outlined,
                                      color: Colors.black54,
                                    ),
                                    hintText: "Confirmer le mot de passe",
                                    obscureText: true,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'Veuillez confirmer le mot de passe';
                                      }
                                      if (v != _passwordCtrl.text) {
                                        return 'Les mots de passe ne correspondent pas';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 28),

                                  AbsorbPointer(
                                    absorbing: loading,
                                    child: ButtonComponent(
                                      textButton: loading
                                          ? "Réinitialisation en cours..."
                                          : "Réinitialiser le mot de passe",
                                      onPressed: loading ? null : _handleResetPassword,
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  GestureDetector(
                                    onTap: () =>
                                        Get.offAll(() => const ConnexionPage()),
                                    child: Center(
                                      child: Text.rich(
                                        TextSpan(
                                          text: "Revenir à la ",
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: size.width * 0.036,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "connexion",
                                              style: TextStyle(
                                                color: Colors.red.shade800,
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

          /// --- Bouton retour
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8.0,
              left: MediaQuery.of(context).padding.left + 16.0,
            ),
            child: Align(
              alignment: Alignment.topLeft,
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
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
