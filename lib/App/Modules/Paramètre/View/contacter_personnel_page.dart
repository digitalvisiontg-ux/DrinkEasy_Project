import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContacterPersonnelPage extends StatefulWidget {
  const ContacterPersonnelPage({super.key});

  @override
  State<ContacterPersonnelPage> createState() => _ContacterPersonnelPageState();
}

class _ContacterPersonnelPageState extends State<ContacterPersonnelPage> {
  String selectedReason = "Appeler un serveur";
  final TextEditingController messageController = TextEditingController();

  final List<Map<String, dynamic>> reasons = [
    {
      "title": "Appeler un serveur",
      "icon": Icons.person_outline,
      "color": Colors.green,
    },
    {
      "title": "Demander l’addition",
      "icon": Icons.receipt_long_outlined,
      "color": Colors.orange,
    },
    {
      "title": "Signaler un problème",
      "icon": Icons.report_problem_outlined,
      "color": Colors.red,
    },
    {
      "title": "Autre demande",
      "icon": Icons.help_outline,
      "color": Colors.blue,
    },
  ];

  void _sendRequest() {
    Get.snackbar(
      "Demande envoyée",
      "Le personnel a été informé et viendra à votre table.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );

    messageController.clear();
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Contacter le personnel",
          style: TextStyle(
            color: Colors.black,
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
                colors: [Color.fromARGB(255, 230, 255, 240), Color(0xFFDFFFE9)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.notifications_active_outlined,
                  size: 36,
                  color: Colors.black87,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    "Besoin d’aide ?\nLe personnel est à votre disposition.",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),

          _section("Motif de la demande"),

          // --------------------------------------------------
          // 📌 RAISONS
          // --------------------------------------------------
          ...reasons.map((r) {
            final isSelected = selectedReason == r["title"];
            return GestureDetector(
              onTap: () {
                setState(() => selectedReason = r["title"]);
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
                    color: isSelected ? r["color"] : Colors.transparent,
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
                        color: r["color"].withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(r["icon"], color: r["color"]),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        r["title"],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle, color: r["color"], size: 22),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 20),
          _section("Message (optionnel)"),

          // --------------------------------------------------
          // ✏ MESSAGE
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
              controller: messageController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Ex: Nous souhaitons commander à nouveau...",
              ),
            ),
          ),

          const SizedBox(height: 30),

          // --------------------------------------------------
          // 🚀 ENVOYER
          // --------------------------------------------------
          SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _sendRequest,
              icon: const Icon(Icons.send, color: Colors.black),
              label: const Text(
                "Envoyer la demande",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
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
  // 🔹 SECTION
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
