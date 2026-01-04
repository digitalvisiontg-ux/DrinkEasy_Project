import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

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
          "Centre d’aide",
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
          // ----------------------------------
          // 🟡 HEADER
          // ----------------------------------
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
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: const [
                Icon(Icons.help_outline_rounded, size: 34, color: Colors.white),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    "Besoin d’aide ?\nTout fonctionne ici par service à table.",
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

          const SizedBox(height: 24),

          _section("Questions fréquentes"),

          // ----------------------------------
          // ❓ FAQ
          // ----------------------------------
          _faqTile(
            icon: Icons.shopping_cart_outlined,
            question: "Comment passer une commande ?",
            answer:
                "Choisissez vos boissons, ajoutez-les au panier, puis validez la commande. Elle sera préparée et servie directement à votre table.",
          ),

          _faqTile(
            icon: Icons.restaurant_menu,
            question: "Comment se passe le service ?",
            answer:
                "Une fois la commande validée, notre équipe prépare votre commande et vient vous servir directement à votre table.",
          ),

          _faqTile(
            icon: Icons.access_time,
            question: "Quel est le temps d’attente ?",
            answer:
                "Le temps moyen de préparation est de 10 à 20 minutes selon l’affluence.",
          ),

          _faqTile(
            icon: Icons.cancel_outlined,
            question: "Puis-je annuler une commande ?",
            answer:
                "Oui, tant que la commande n’est pas encore en préparation.",
          ),

          _faqTile(
            icon: Icons.payment_outlined,
            question: "Comment se fait le paiement ?",
            answer:
                "Le paiement se fait directement au bar ou au moment du service à table.",
          ),

          const SizedBox(height: 26),

          _section("Assistance"),

          // ----------------------------------
          // 📞 ACTIONS
          // ----------------------------------
          _actionTile(
            icon: Icons.chat_bubble_outline,
            title: "Contacter le personnel",
            subtitle: "Besoin d’aide immédiate à votre table",
            onTap: () {
              Get.toNamed('/contacter_personnel');
            },
          ),

          _actionTile(
            icon: Icons.report_problem_outlined,
            title: "Signaler un problème",
            subtitle: "Commande, service ou application",
            onTap: () {
              Get.toNamed('/signaler_probleme');
            },
          ),

          const SizedBox(height: 28),

          Center(
            child: Text(
              "DrinkEasy • Service à table",
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
  // ❓ FAQ TILE
  // --------------------------------------------------
  Widget _faqTile({
    required IconData icon,
    required String question,
    required String answer,
  }) {
    return AnimatedTap(
      child: Container(
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
        child: ExpansionTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          leading: Icon(icon, color: Colors.orange.shade700),
          title: Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          children: [
            Text(
              answer,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // 📞 ACTION TILE
  // --------------------------------------------------
  Widget _actionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return AnimatedTap(
      onTap: onTap,
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
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
                    const SizedBox(height: 4),
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

// --------------------------------------------------
// ✨ ANIMATION TAP (identique Paramètres)
// --------------------------------------------------
class AnimatedTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const AnimatedTap({super.key, required this.child, this.onTap});

  @override
  State<AnimatedTap> createState() => _AnimatedTapState();
}

class _AnimatedTapState extends State<AnimatedTap>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _scale = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _down(_) => _controller.forward();
  void _up(_) => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _down,
      onTapUp: _up,
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: widget.child,
      ),
    );
  }
}
