import 'dart:io';
import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'package:drink_eazy/App/Component/deconnexion_component.dart';
import 'package:drink_eazy/App/Component/showMessage_component.dart';
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
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final provider = context.read<AuthProvider>();
    setState(() => _loading = true);
    await provider.loadUser();
    final user = provider.user;
    if (user != null) {
      _nameController.text = user['name'] ?? '';
      _emailController.text = user['email'] ?? '';
      _phoneController.text = user['phone'] ?? '';
    }
    setState(() => _loading = false);
  }

  Future<void> _saveChanges() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    if (email.isEmpty && phone.isEmpty) {
      showMessageComponent(
        context,
        'Erreur',
        'Veuillez renseigner au moins un contact : email ou téléphone.',
        true,
      );
      return;
    }

    final provider = context.read<AuthProvider>();
    final success = await provider.updateProfile({
      'name': name,
      'email': email.isNotEmpty ? email : null,
      'phone': phone.isNotEmpty ? phone : null,
    });

    if (success) {
      showMessageComponent(
        context,
        'Profil mis à jour',
        'Vos informations ont été mises à jour avec succès.',
        false,
      );
      Navigator.of(context).pop();
    } else {
      showMessageComponent(
        context,
        'Vérifier les informations',
        provider.errorMessage ?? 'Impossible de mettre à jour le profil.',
        true,
      );
    }
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: const AssetImage(
                        'assets/images/DrinkEasyLogoIcone.png'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _nameController.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _emailController.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
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
                  Deconnexion_component(context),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87),
        prefixIcon: Icon(icon, color: Colors.amber.shade800),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        labelStyle: const TextStyle(color: Colors.black87),
        prefixIcon: Icon(Icons.lock, color: Colors.amber.shade800),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
