import 'package:drink_eazy/App/Component/button_component.dart';
import 'package:drink_eazy/App/Component/showMessage_component.dart';
import 'package:drink_eazy/App/Modules/Connexion/Controller/controller.dart';
import 'package:drink_eazy/App/Modules/Connexion/View/connexion.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'package:drink_eazy/Utils/form.dart';

class NouveauMotDePassePage extends StatefulWidget {
  final String login;
  final String otp;

  const NouveauMotDePassePage({Key? key, required this.login, required this.otp}) : super(key: key);

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

    final newPassword = _passwordCtrl.text.trim();
    final auth = Provider.of<AuthProvider>(context, listen: false);

    setState(() => loading = true);
    final success = await auth.resetPassword(widget.login, widget.otp, newPassword, _confirmPasswordCtrl.text.trim());
    setState(() => loading = false);

    if (success == true) {
      showMessageComponent(context, 'Votre mot de passe a été réinitialisé avec succès pour ${widget.login}', 'Succès', false);
      Get.offAll(() => ConnexionPage());
    } else {
      showMessageComponent(context, auth.errorMessage ?? 'Erreur lors de la réinitialisation', 'Erreur', true);
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
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/images/bgimage2.jpg', fit: BoxFit.cover)),
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.5))),
          Column(
            children: [
              const Spacer(flex: 2),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Nouveau mot de passe', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 34, fontFamily: 'Agbalumo', letterSpacing: 1.2)),
                    SizedBox(height: 8),
                    Text('Définissez votre nouveau mot de passe', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 16)),
                  ],
                ),
              ),
              const Spacer(flex: 1),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FormWidget(controller: _passwordCtrl, prefixIcon: const Icon(Icons.lock_outline, color: Colors.black54), hintText: "Nouveau mot de passe", obscureText: true, validator: validatePassword),
                      const SizedBox(height: 16),
                      FormWidget(controller: _confirmPasswordCtrl, prefixIcon: const Icon(Icons.lock_reset_outlined, color: Colors.black54), hintText: "Confirmer le mot de passe", obscureText: true, validator: (v) {
                        if (v == null || v.isEmpty) return 'Veuillez confirmer le mot de passe';
                        if (v != _passwordCtrl.text) return 'Les mots de passe ne correspondent pas';
                        return null;
                      }),
                      const SizedBox(height: 28),
                      GestureDetector(
                        onTap: loading ? null : _handleResetPassword,
                        child: ButtonComponent(textButton: loading ? 'Mise à jour en cours...' : 'Réinitialiser le mot de passe'),
                      ),
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
