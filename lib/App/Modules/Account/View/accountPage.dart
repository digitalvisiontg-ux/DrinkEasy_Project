import 'package:drink_eazy/App/Component/listTitle_component.dart';
import 'package:drink_eazy/App/Modules/Connexion/View/connexion.dart';
import 'package:drink_eazy/App/Modules/Connexion/View/inscription.dart';
import 'package:drink_eazy/App/Modules/Home/View/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.to(Home());
          },
        ),
        title: const Text(
          "Mon Compte",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar circulaire jaune
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.amber,
                    child: const Icon(
                      Icons.person_2_outlined,
                      color: Colors.black,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Titre "Mode invité"
                  const Text(
                    "Mode invité",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),

                  // Sous-texte explicatif
                  Text(
                    "Connectez-vous pour accéder à tous les avantages",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // BOUTONS : Se connecter / Créer un compte
            ElevatedButton.icon(
              onPressed: () {
                Get.to(ConnexionPage());
              },
              icon: const Icon(Icons.login, color: Colors.black),
              label: const Text(
                "Se connecter",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () {
                Get.to(InscriptionPage());
              },
              icon: const Icon(Icons.person_add_alt_1, color: Colors.black),
              label: const Text(
                "Créer un compte",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300, width: 1),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // LISTE : Options du compte
            listTileComponent(
              icon: Icons.history,
              title: "Historique des commandes",
              onTap: () {},
            ),
            listTileComponent(
              icon: Icons.favorite_border,
              title: "Mes favoris",
              onTap: () {},
            ),
            listTileComponent(
              icon: Icons.card_giftcard,
              title: "Offres spéciales",
              onTap: () {},
            ),
            listTileComponent(
              icon: Icons.settings,
              title: "Paramètres",
              onTap: () {},
            ),
            listTileComponent(
              icon: Icons.headset_mic_outlined,
              title: "Support client",
              onTap: () {},
            ),

            SizedBox(height: 24),

            // SECTION : Programme de fidélité
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "⭐ Programme de fidélité",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Gagnez des points à chaque commande et débloquez des récompenses exclusives !",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "• 1 commande = 10 points\n• 100 points = 1 boisson offerte",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // FOOTER : Version de l’application
            Column(
              children: [
                Text(
                  "DrinkEasy v1.0",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Votre bar digital préféré",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
