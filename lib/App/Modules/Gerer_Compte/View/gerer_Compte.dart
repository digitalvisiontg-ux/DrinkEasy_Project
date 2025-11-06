import 'dart:io';
import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'package:drink_eazy/App/Component/confirm_component.dart';
import 'package:drink_eazy/App/Component/error_popup_component.dart';
import 'package:drink_eazy/App/Component/showMessage_component.dart';
import 'package:drink_eazy/App/Modules/Home/View/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class GererComptePage extends StatefulWidget {
  const GererComptePage({super.key});

  @override
  State<GererComptePage> createState() => _GererComptePageState();
}

class _GererComptePageState extends State<GererComptePage> {
  File? _profileImage;
  final _nameController = TextEditingController(text: "Medard ");
  final _emailController = TextEditingController(text: "medard@email.com");
  final _phoneController = TextEditingController(text: "+228 97 34 56 78");

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _saveChanges() {
    showMessageComponent(
      context,
      'Modifications enregistrées',
      'Vos modifications ont été enregistrées avec succès.',
      false,
    );
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Gérer mon compte",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 255, 240, 202),
                    Color(0xFFFFF8E1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.amber.shade700,
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 48,
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : const AssetImage(
                                        'assets/images/DrinkEasyLogoIcone.png',
                                      )
                                      as ImageProvider,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.black87,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _nameController.text,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _emailController.text,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // --- Formulaire d'édition ---
            _buildTextField("Nom complet", _nameController, Icons.person),
            const SizedBox(height: 14),
            _buildTextField("Email", _emailController, Icons.email_outlined),
            const SizedBox(height: 14),
            _buildTextField("Téléphone", _phoneController, Icons.phone),
            const SizedBox(height: 14),
            _buildPasswordField("Mot de passe actuel", obscure: true),
            const SizedBox(height: 14),
            _buildPasswordField("Nouveau mot de passe", obscure: true),
            const SizedBox(height: 30),
            // --- Bouton sauvegarde ---
            ElevatedButton.icon(
              onPressed: _saveChanges,
              icon: const Icon(Icons.save, color: Colors.black),
              label: const Text(
                "Enregistrer les modifications",
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                elevation: 0.1,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- Déconnexion ---
            OutlinedButton.icon(
              onPressed: () async {
                final confirm = await showConfirmComponent(
                  context,
                  title: 'Déconnexion',
                  message: 'Voulez-vous vraiment vous déconnecter ?',
                  confirmText: 'Déconnecter',
                  cancelText: 'Annuler',
                  confirmColor: Colors.red,
                  cancelColor: Colors.grey.shade200,
                  // icon: Icons.logout_rounded,
                  // iconColor: Colors.red,
                  // iconBgColor: Colors.redAccent.withOpacity(0.1),
                );

                if (confirm == true) {
                  try {
                    final auth = Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    );
                    await auth.logout();
                    Get.offAll(const Home());
                    showMessageComponent(
                      context,
                      'Déconnexion réussie',
                      'Vous avez été déconnecté avec succès.',
                      false,
                    );
                  } catch (e) {
                    debugPrint('Erreur de déconnexion : $e');
                    showErrorPopupComponent(
                      context,
                      title: 'Erreur',
                      message:
                          'Une erreur est survenue lors de la déconnexion.',
                    );
                  }
                }
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                "Déconnexion",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red.shade300),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        // Label focus text color change
        labelStyle: TextStyle(color: Colors.black87),
        prefixIcon: Icon(icon, color: Colors.amber.shade800),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.amber.shade700, width: 1),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, {bool obscure = true}) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        // Label focus text color change
        labelStyle: TextStyle(color: Colors.black87),
        prefixIcon: Icon(Icons.lock_outline, color: Colors.amber.shade800),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.amber.shade700, width: 1),
        ),
      ),
    );
  }
}
