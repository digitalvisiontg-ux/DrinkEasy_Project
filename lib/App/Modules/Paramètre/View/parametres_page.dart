import 'package:drink_eazy/App/Component/confirm_component.dart';
import 'package:drink_eazy/App/Component/deconnexion_component.dart';
import 'package:drink_eazy/App/Modules/Gerer_Compte/View/gerer_Compte.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';

class ParametresPage extends StatefulWidget {
  const ParametresPage({super.key});

  @override
  State<ParametresPage> createState() => _ParametresPageState();
}

class _ParametresPageState extends State<ParametresPage> {
  // bool notificationsEnabled = true;
  // bool darkMode = false;

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
          "Paramètres",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        children: [
          _section("Compte"),
          Builder(
            builder: (context) {
              final user = Provider.of<AuthProvider>(context).user;

              return Column(
                children: [
                  _tile(
                    icon: Icons.person_outline,
                    title: user != null
                        ? user['name']?.toString() ?? 'Utilisateur'
                        : "Mode invité",
                    subtitle: user != null
                        ? user['email']?.toString() ??
                              user['phone']?.toString() ??
                              'Profil utilisateur'
                        : "Connectez-vous pour gérer votre profil",
                    onTap: () {
                      if (user == null) {
                        Get.toNamed('/inscription_choice');
                      } else {
                        Get.to(() => const GererComptePage());
                      }
                    },
                  ),

                  if (user != null)
                    _tile(
                      icon: Icons.lock_outline,
                      title: "Changer le mot de passe",
                      subtitle: "Modifier votre mot de passe",
                      onTap: () {
                        Get.snackbar(
                          "Sécurité",
                          "Changement du mot de passe...",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                ],
              );
            },
          ),

          _section("Support"),
          _tile(
            icon: Icons.help_outline,
            title: "Centre d’aide",
            subtitle: "FAQ et assistance",
            onTap: () => Get.toNamed('/help_center'),
          ),

          _tile(
            icon: Icons.privacy_tip_outlined,
            title: "Confidentialité",
            subtitle: "Politique et sécurité",
            onTap: () => Get.toNamed('/confidentiality'),
          ),

          _section("Application"),
          _tile(
            icon: Icons.info_outline,
            title: "À propos",
            subtitle: "Drink Eazy • Version 1.0.0",
            onTap: () {
              // showAboutDialog(
              //   context: context,
              //   applicationName: "Drink Eazy",
              //   applicationVersion: "1.0.0",
              //   applicationIcon: const Icon(
              //     Icons.local_drink_outlined,
              //     size: 48,
              //     color: Colors.orange,
              //   ),
              //   applicationLegalese: "© 2024 Drink Eazy. Tous droits réservés.",
              // );
              Get.toNamed('/about');
            },
          ),

          _tile(
            icon: Icons.account_circle_outlined,
            title: "Informations du compte",
            subtitle: "Détails de votre compte",
            onTap: () => Get.toNamed('/information_compte'),
          ),

          _tile(
            icon: Icons.swap_horiz_rounded,
            title: "Changer de compte",
            subtitle: "Se connecter avec un autre compte",
            onTap: () {
              final user = Provider.of<AuthProvider>(
                context,
                listen: false,
              ).user;

              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // --------------------------------------------------
                        // 🔹 HANDLE
                        // --------------------------------------------------
                        Container(
                          width: 42,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // --------------------------------------------------
                        // 🔹 TITLE
                        // --------------------------------------------------
                        const Text(
                          "Compte actif",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // --------------------------------------------------
                        // 👤 PROFIL UTILISATEUR
                        // --------------------------------------------------
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.amber,
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.black,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user?['name']?.toString() ??
                                          'Utilisateur',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      user?['email']?.toString() ??
                                          user?['phone']?.toString() ??
                                          'drinkeasy@gmail.com',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.check_circle_rounded,
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        // --------------------------------------------------
                        // ➕ AJOUTER UN COMPTE
                        // --------------------------------------------------
                        _bottomSheetAction(
                          icon: Icons.person_add_alt_1_rounded,
                          iconColor: Colors.orange.shade700,
                          title: "Ajouter un compte",
                          subtitle: "Créer ou connecter un nouveau compte",
                          onTap: () {
                            Get.back();
                            Get.toNamed('/inscription_choice');
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),

          _tile(
            icon: Icons.delete_outline,
            title: "Supprimer le compte",
            subtitle: "Suppression définitive",
            color: Colors.red,
            onTap: () {
              showConfirmComponent(
                context,
                title: "Supprimer le compte",
                confirmText: "Supprimer",
                cancelText: "Annuler",
                confirmColor: Colors.red,
                cancelColor: Colors.grey.shade200,
                message:
                    "Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.",
              );
            },
          ),

          const SizedBox(height: 15),

          // _section("Paramètres"),
          // _tile(
          //   icon: Icons.notifications_outlined,
          //   title: "Notifications",
          //   subtitle: "Gérer vos préférences de notification",
          //   onTap: () {
          //     showModalBottomSheet(
          //       context: context,
          //       builder: (context) => Container(
          //         padding: const EdgeInsets.all(20),
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             const Text(
          //               "Notifications",
          //               style: TextStyle(
          //                 fontSize: 18,
          //                 fontWeight: FontWeight.w700,
          //               ),
          //             ),
          //             const SizedBox(height: 20),
          //             SwitchListTile(
          //               title: const Text("Notifications push"),
          //               subtitle: const Text("Recevoir des alertes"),
          //               value: notificationsEnabled,
          //               onChanged: (value) {
          //                 setState(() => notificationsEnabled = value);
          //                 Get.back();
          //               },
          //             ),
          //           ],
          //         ),
          //       ),
          //     );
          //   },
          // ),
          // _tile(
          //   icon: Icons.dark_mode_outlined,
          //   title: "Thème",
          //   subtitle: darkMode ? "Mode sombre" : "Mode clair",
          //   onTap: () {
          //     setState(() => darkMode = !darkMode);
          //     Get.snackbar(
          //       "Thème",
          //       darkMode ? "Mode sombre activé" : "Mode clair activé",
          //     );
          //   },
          // ),
          Deconnexion_component(context),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // 🔹 SECTION TITLE
  // --------------------------------------------------

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10, top: 10),
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
  // 🔹 TILE AVEC ANIMATION SUBTILE
  // --------------------------------------------------

  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? color,
    VoidCallback? onTap,
  }) {
    final iconColor = color ?? Colors.orange.shade700;

    return AnimatedTap(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),

        // margin: const EdgeInsets.only(bottom: 12),
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.circular(12),
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.black12.withOpacity(0.05),
        //       blurRadius: 8,

        //       offset: const Offset(0, 3),
        //     ),
        //   ],
        // ),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          splashColor: iconColor.withOpacity(0.08),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(icon, color: iconColor),
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
      ),
    );
  }
}

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

Widget _bottomSheetAction({
  required IconData icon,
  required Color iconColor,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(18),
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor),
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
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: Colors.black26,
          ),
        ],
      ),
    ),
  );
}
