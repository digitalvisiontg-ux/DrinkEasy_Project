import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportClientPage extends StatefulWidget {
  const SupportClientPage({super.key});

  @override
  State<SupportClientPage> createState() => _SupportClientPageState();
}

class _SupportClientPageState extends State<SupportClientPage> {
  final _messageCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Support client",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// 🔹 Illustration
            Image.asset("assets/images/support.jpg", height: 180),
            const SizedBox(height: 18),

            /// 🔹 Titre
            const Text(
              "Comment pouvons-nous vous aider ?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Notre équipe est disponible pour vous assister à tout moment.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 28),

            /// 🔹 Champ e-mail
            _buildTextField(
              controller: _emailCtrl,
              label: "Votre e-mail",
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 16),

            /// 🔹 Champ message
            _buildTextField(
              controller: _messageCtrl,
              label: "Décrivez votre problème ou question",
              icon: Icons.message_outlined,
              maxLines: 5,
            ),
            const SizedBox(height: 24),

            /// 🔹 Bouton d’envoi
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 1,
              ),
              onPressed: loading
                  ? null
                  : () async {
                      if (_messageCtrl.text.trim().isEmpty ||
                          _emailCtrl.text.trim().isEmpty) {
                        Get.snackbar(
                          "Erreur",
                          "Veuillez remplir tous les champs",
                          backgroundColor: Colors.red.shade50,
                          colorText: Colors.red.shade800,
                        );
                        return;
                      }

                      setState(() => loading = true);
                      await Future.delayed(const Duration(seconds: 2));

                      if (mounted) {
                        setState(() => loading = false);
                        Get.snackbar(
                          "Envoyé ✅",
                          "Votre message a été transmis avec succès !",
                          backgroundColor: Colors.green.shade50,
                          colorText: Colors.green.shade800,
                        );
                        _emailCtrl.clear();
                        _messageCtrl.clear();
                      }
                    },
              child: Text(
                loading ? "Envoi en cours..." : "Envoyer le message",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 32),

            /// 🔹 Autres options de contact
            const Text(
              "Autres moyens de contact",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 14),

            _buildContactTile(
              icon: Icons.phone_outlined,
              title: "Appeler le support",
              subtitle: "+228 90 00 00 00",
              color: Colors.green.shade600,
              onTap: () => Get.snackbar("Appel", "Numéro : +228 90 00 00 00"),
            ),
            const SizedBox(height: 10),

            _buildContactTile(
              icon: Icons.chat_outlined,
              title: "WhatsApp",
              subtitle: "+228 91 11 11 11",
              color: Colors.teal.shade600,
              onTap: () => Get.snackbar("WhatsApp", "Ouverture du chat..."),
            ),
            const SizedBox(height: 10),

            _buildContactTile(
              icon: Icons.mail_outline,
              title: "E-mail",
              subtitle: "support@drinkeazy.com",
              color: Colors.orange.shade700,
              onTap: () =>
                  Get.snackbar("E-mail", "support@drinkeazy.com copié !"),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// Champ de texte personnalisé
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.red.shade700),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade700),
          borderRadius: BorderRadius.circular(20),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  /// Carte de contact stylisée
  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.black26,
        ),
        onTap: onTap,
      ),
    );
  }
}
