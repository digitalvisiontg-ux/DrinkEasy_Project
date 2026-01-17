// import 'package:drink_eazy/App/Component/showToast_component.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart'; // ✅ Ajout

// class SupportClientPage extends StatefulWidget {
//   const SupportClientPage({super.key});

//   @override
//   State<SupportClientPage> createState() => _SupportClientPageState();
// }

// class _SupportClientPageState extends State<SupportClientPage> {
//   final _messageCtrl = TextEditingController();
//   final _emailCtrl = TextEditingController();
//   bool loading = false;

//   /// ✅ Fonction pour lancer des URLs
//   Future<void> _launchUrl(String url) async {
//     final uri = Uri.parse(url);
//     if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//       showToastComponent(
//         context,
//         "Impossible d’ouvrir le lien.",
//         isError: true,
//       );
//       // Get.snackbar("Erreur", "Impossible d’ouvrir : $url");
//     }
//   }

//   /// ✅ Appeler le support
//   void _callSupport() {
//     const phoneNumber = "+22897148251";
//     _launchUrl("tel:$phoneNumber");
//   }

//   /// ✅ Ouvrir WhatsApp
//   void _openWhatsApp() {
//     const whatsappNumber = "+228971148251";
//     const message = "Bonjour, j’aimerais avoir de l’aide...";
//     final encodedMessage = Uri.encodeComponent(message);
//     _launchUrl("whatsapp://send?phone=$whatsappNumber&text=$encodedMessage");
//   }

//   /// ✅ Envoyer un e-mail
//   void _sendEmail() {
//     const email = "digitalvisiontg@gmail.com";
//     final subject = Uri.encodeComponent("Assistance DrinkEazy");
//     final body = Uri.encodeComponent("Bonjour, j’aimerais avoir de l’aide...");
//     _launchUrl("mailto:$email?subject=$subject&body=$body");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F7FB),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black87),
//           onPressed: () => Get.back(),
//         ),
//         title: const Text(
//           "Support client",
//           style: TextStyle(
//             color: Colors.black87,
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Image.asset(
//               "assets/images/support.jpg",
//               height: MediaQuery.of(context).size.height * 0.20,
//             ),
//             const SizedBox(height: 18),

//             const Text(
//               "Comment pouvons-nous vous aider ?",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 6),
//             const Text(
//               "Notre équipe est disponible pour vous assister à tout moment.",
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.black54, fontSize: 14),
//             ),
//             const SizedBox(height: 28),

//             _buildTextField(
//               controller: _emailCtrl,
//               label: "Votre e-mail",
//               icon: Icons.email_outlined,
//             ),
//             const SizedBox(height: 16),

//             _buildTextField(
//               controller: _messageCtrl,
//               label: "Décrivez votre problème ou question",
//               icon: Icons.message_outlined,
//               maxLines: 5,
//             ),
//             const SizedBox(height: 24),

//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.amber,
//                 padding: EdgeInsets.symmetric(
//                   horizontal: MediaQuery.of(context).size.width * 0.1,
//                   vertical: 12,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 elevation: 1,
//               ),
//               onPressed: loading
//                   ? null
//                   : () async {
//                       if (_messageCtrl.text.trim().isEmpty ||
//                           _emailCtrl.text.trim().isEmpty) {
//                         Get.snackbar(
//                           "Erreur",
//                           "Veuillez remplir tous les champs",
//                           backgroundColor: Colors.red.shade50,
//                           colorText: Colors.red.shade800,
//                         );
//                         return;
//                       }

//                       setState(() => loading = true);
//                       await Future.delayed(const Duration(seconds: 2));

//                       if (mounted) {
//                         setState(() => loading = false);
//                         Get.snackbar(
//                           "Envoyé ✅",
//                           "Votre message a été transmis avec succès !",
//                           backgroundColor: Colors.green.shade50,
//                           colorText: Colors.green.shade800,
//                         );
//                         _emailCtrl.clear();
//                         _messageCtrl.clear();
//                       }
//                     },
//               child: Text(
//                 loading ? "Envoi en cours..." : "Envoyer le message",
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 32),

//             const Text(
//               "Autres moyens de contact",
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 14),

//             _buildContactTile(
//               icon: Icons.phone_outlined,
//               title: "Appeler le support",
//               subtitle: "+228 97 14 82 51",
//               color: Colors.green.shade600,
//               onTap: _callSupport,
//             ),
//             const SizedBox(height: 10),

//             _buildContactTile(
//               icon: Icons.chat_outlined,
//               title: "WhatsApp",
//               subtitle: "+228 97 14 82 51",
//               color: Colors.teal.shade600,
//               onTap: _openWhatsApp,
//             ),
//             const SizedBox(height: 10),

//             _buildContactTile(
//               icon: Icons.mail_outline,
//               title: "E-mail",
//               subtitle: "digitalvisiontg@gmail.com",
//               color: Colors.orange.shade700,
//               onTap: _sendEmail,
//             ),
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     int maxLines = 1,
//   }) {
//     return TextField(
//       controller: controller,
//       maxLines: maxLines,
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: Colors.red.shade700),
//         labelText: label,
//         labelStyle: const TextStyle(color: Colors.black54),
//         filled: true,
//         fillColor: Colors.white,
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.red.shade700),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         border: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.grey.shade300),
//           borderRadius: BorderRadius.circular(20),
//         ),
//       ),
//     );
//   }

//   Widget _buildContactTile({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Color color,
//     VoidCallback? onTap,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: ListTile(
//         leading: Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(14),
//           ),
//           child: Icon(icon, color: color, size: 24),
//         ),
//         title: Text(
//           title,
//           style: const TextStyle(
//             fontWeight: FontWeight.w700,
//             fontSize: 15,
//             color: Colors.black87,
//           ),
//         ),
//         subtitle: Text(
//           subtitle,
//           style: const TextStyle(fontSize: 13, color: Colors.black54),
//         ),
//         trailing: const Icon(
//           Icons.arrow_forward_ios,
//           size: 16,
//           color: Colors.black26,
//         ),
//         onTap: onTap,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportClientPage extends StatelessWidget {
  const SupportClientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.4,
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

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --------------------------------------------------
          // 🔔 HEADER
          // --------------------------------------------------
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 254, 171, 46),
                  Color.fromARGB(255, 255, 90, 40),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.support_agent_rounded,
                  size: 34,
                  color: Colors.white,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    "Besoin d’aide ?\nChoisissez l’option adaptée à votre situation.",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),

          // --------------------------------------------------
          // 🧑‍🍳 CONTACTER LE PERSONNEL
          // --------------------------------------------------
          _supportTile(
            icon: Icons.restaurant,
            iconColor: Colors.green,
            title: "Contacter le personnel",
            subtitle: "Demander l’intervention d’un serveur à votre table",
            onTap: () {
              Get.toNamed('/contacter_personnel');
            },
          ),

          // --------------------------------------------------
          // 🚨 SIGNALER UN PROBLÈME
          // --------------------------------------------------
          _supportTile(
            icon: Icons.report_problem_outlined,
            iconColor: Colors.red,
            title: "Signaler un problème",
            subtitle: "Un souci avec votre commande ou le service",
            onTap: () {
              Get.toNamed('/signaler_probleme');
            },
          ),

          // --------------------------------------------------
          // 📩 CONTACTEZ-NOUS
          // --------------------------------------------------
          _supportTile(
            icon: Icons.mail_outline,
            iconColor: Colors.blue,
            title: "Contactez-nous",
            subtitle: "Question, suggestion ou réclamation générale",
            onTap: () {
              Get.toNamed('/contact');
            },
          ),

          const SizedBox(height: 30),

          Center(
            child: Text(
              "DrinkEasy • Support & Assistance",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // 🔹 SUPPORT TILE
  // --------------------------------------------------
  Widget _supportTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.black26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
