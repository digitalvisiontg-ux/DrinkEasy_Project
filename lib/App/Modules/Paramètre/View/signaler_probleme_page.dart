import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignalerProblemePage extends StatefulWidget {
  const SignalerProblemePage({super.key});

  @override
  State<SignalerProblemePage> createState() => _SignalerProblemePageState();
}

class _SignalerProblemePageState extends State<SignalerProblemePage> {
  String selectedProblem = "Problème avec la commande";
  final TextEditingController descriptionController = TextEditingController();

  final List<Map<String, dynamic>> problems = [
    {
      "title": "Problème avec la commande",
      "icon": Icons.receipt_long_outlined,
      "color": Colors.orange,
    },
    {
      "title": "Problème de boisson / plat",
      "icon": Icons.local_bar_outlined,
      "color": Colors.redAccent,
    },
    {
      "title": "Problème de service",
      "icon": Icons.person_off_outlined,
      "color": Colors.blue,
    },
    {
      "title": "Problème de paiement",
      "icon": Icons.payment_outlined,
      "color": Colors.purple,
    },
    {
      "title": "Autre problème",
      "icon": Icons.help_outline,
      "color": Colors.grey,
    },
  ];

  void _sendReport() {
    Get.snackbar(
      "Signalement envoyé",
      "Le personnel a été informé et interviendra rapidement.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent.shade400,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );

    descriptionController.clear();
  }

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
          "Signaler un problème",
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
          // ⚠️ HEADER
          // --------------------------------------------------
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 247, 201, 208),
                  Color.fromARGB(255, 251, 133, 145),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.report_problem_outlined,
                  size: 36,
                  color: Colors.black87,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    "Un souci ?\nDites-nous ce qui ne va pas.",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),
          _section("Type de problème"),

          // --------------------------------------------------
          // 📌 LISTE DES PROBLÈMES
          // --------------------------------------------------
          ...problems.map((p) {
            final isSelected = selectedProblem == p["title"];
            return GestureDetector(
              onTap: () {
                setState(() => selectedProblem = p["title"]);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? p["color"] : Colors.transparent,
                    width: 1.6,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: p["color"].withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(p["icon"], color: p["color"]),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        p["title"],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle, color: p["color"], size: 22),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 20),
          _section("Description (optionnel)"),

          // --------------------------------------------------
          // ✏ DESCRIPTION
          // --------------------------------------------------
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
            child: TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText:
                    "Expliquez brièvement le problème rencontré (facultatif)",
              ),
            ),
          ),

          const SizedBox(height: 30),

          // --------------------------------------------------
          // 🚨 ENVOYER
          // --------------------------------------------------
          SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _sendReport,
              icon: const Icon(Icons.report_gmailerrorred, color: Colors.white),
              label: const Text(
                "Envoyer le signalement",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // 🔹 SECTION TITLE
  // --------------------------------------------------
  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
