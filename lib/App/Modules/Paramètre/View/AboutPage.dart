import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
          "À propos",
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
          // 🔶 HEADER APP
          // --------------------------------------------------
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 254, 171, 46),
                  Color.fromARGB(255, 255, 90, 40),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: const [
                Icon(Icons.local_bar_rounded, size: 46, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  "DrinkEasy",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Votre bar digital préféré",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          _section("Présentation"),

          _infoTile(
            icon: Icons.info_outline,
            title: "Qu’est-ce que DrinkEasy ?",
            content:
                "DrinkEasy est une application de commande digitale conçue pour "
                "les bars et restaurants. Les clients commandent directement "
                "depuis leur table, sans attente.",
          ),

          _infoTile(
            icon: Icons.restaurant_menu_outlined,
            title: "Service à table",
            content:
                "Aucune livraison n’est proposée. Les commandes sont préparées "
                "et servies directement à votre table par le personnel.",
          ),

          const SizedBox(height: 20),
          _section("Notre mission"),

          _infoTile(
            icon: Icons.flag_outlined,
            title: "Objectif",
            content:
                "Simplifier l’expérience client, réduire l’attente et offrir "
                "un service fluide, rapide et moderne.",
          ),

          _infoTile(
            icon: Icons.trending_up_rounded,
            title: "Innovation",
            content:
                "Digitaliser la commande en salle pour améliorer le confort "
                "des clients et l’efficacité du personnel.",
          ),

          const SizedBox(height: 20),
          _section("Application"),

          _simpleTile(
            icon: Icons.verified_outlined,
            title: "Version",
            value: "DrinkEasy v1.0.0",
          ),

          _simpleTile(
            icon: Icons.devices_outlined,
            title: "Plateforme",
            value: "Android & iOS",
          ),

          const SizedBox(height: 20),
          _section("Contact"),

          _actionTile(
            icon: Icons.email_outlined,
            title: "Nous contacter",
            subtitle: "contact@drinkeasy.com",
            onTap: () {
              Get.snackbar(
                "Contact",
                "Ouverture du client mail...",
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),

          const SizedBox(height: 30),

          Center(
            child: Column(
              children: [
                Text(
                  "© 2025 DrinkEasy",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Made with ❤️ for bars",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ],
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

  // --------------------------------------------------
  // 🔹 INFO TILE
  // --------------------------------------------------
  Widget _infoTile({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.orange.shade700),
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
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // 🔹 SIMPLE TILE
  // --------------------------------------------------
  Widget _simpleTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey.shade800),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        trailing: Text(
          value,
          style: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // 🔹 ACTION TILE
  // --------------------------------------------------
  Widget _actionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: Colors.blue.shade700),
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
                        fontSize: 15,
                      ),
                    ),
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
