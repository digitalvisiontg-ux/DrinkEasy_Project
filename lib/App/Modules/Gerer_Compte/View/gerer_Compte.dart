import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'package:drink_eazy/App/Component/showMessage_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    
    _emailController.addListener(_onTextChanged);
    _phoneController.addListener(_onTextChanged);

    _loadUserInfo();
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadUserInfo() async {
    final provider = context.read<AuthProvider>();
    setState(() => _loading = true);
    await provider.loadUser();

    if (!mounted) return;

    final user = provider.user;
    if (user != null) {
      _nameController.text = user['name'] ?? '';
      _emailController.text = user['email'] ?? '';
      // Support multiple possible keys for phone
      _phoneController.text = user['phone'] ?? user['telephone'] ?? user['phone_number'] ?? '';
    }
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onTextChanged);
    _phoneController.removeListener(_onTextChanged);
    _nameController.dispose(); 
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
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

  // Construction dynamique du payload
  final Map<String, dynamic> payload = {'name': name};
  payload['email'] = email.isNotEmpty ? email : null;
  payload['phone'] = phone.isNotEmpty ? phone : null;

  final provider = context.read<AuthProvider>();
  final success = await provider.updateProfile(payload);

  if (!mounted) return;

  if (success) {
    // Refresh the user data from the backend to ensure the local cache reflects the changes
    await provider.loadUser();
    if (!mounted) return;
    
    showMessageComponent(
      context,
      'Profil mis à jour',
      'Vos informations ont été mises à jour avec succès.',
      false,
    );
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  } else {
    showMessageComponent(
      context,
      'Vérifier les informations',
      provider.errorMessage ?? 'Impossible de mettre à jour le profil.',
      true,
    );
  }
}

  Future<void> _deleteContact(String type) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer ${type == 'email' ? 'cet email' : 'ce numéro de téléphone'} ?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final provider = context.read<AuthProvider>();
    final success = await provider.deleteContact(type);

    if (!mounted) return;

    if (success) {
      await _loadUserInfo();
      if (!mounted) return;
      
      showMessageComponent(
        context,
        'Succès',
        'Contact supprimé avec succès.',
        false,
      );
    } else {
      showMessageComponent(
        context,
        'Erreur',
        provider.errorMessage ?? 'Impossible de supprimer ce contact.',
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
            _buildTextField(
              "Email",
              _emailController,
              Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              suffixIcon: _emailController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: _phoneController.text.trim().isNotEmpty
                            ? Colors.red
                            : Colors.grey,
                      ),
                      tooltip: "Supprimer l'email",
                      onPressed: _phoneController.text.trim().isNotEmpty
                          ? () {
                              _deleteContact('email');
                            }
                          : () {
                              showMessageComponent(
                                context,
                                'Action impossible',
                                'Vous devez garder au moins le numéro de téléphone pour supprimer l\'email.',
                                true,
                              );
                            },
                    )
                  : null,
            ),
            const SizedBox(height: 14),
            _buildTextField(
              "Téléphone",
              _phoneController,
              Icons.phone,
              keyboardType: TextInputType.phone,
              suffixIcon: _phoneController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: _emailController.text.trim().isNotEmpty
                            ? Colors.red
                            : Colors.grey,
                      ),
                      tooltip: "Supprimer le numéro",
                      onPressed: _emailController.text.trim().isNotEmpty
                          ? () {
                              _deleteContact('phone');
                            }
                          : () {
                              showMessageComponent(
                                context,
                                'Action impossible',
                                'Vous devez garder au moins l\'email pour supprimer le numéro de téléphone.',
                                true,
                              );
                            },
                    )
                  : null,
            ),
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
                ],
              ),
            ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87),
        prefixIcon: Icon(icon, color: Colors.amber.shade800),
        suffixIcon: suffixIcon,
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
