
/* =========================================================
   BOTTOM SHEET – AJOUTER PERSONNEL
   ========================================================= */

import 'package:drink_eazy/Admin_App/Admin_Modules/AdminSettingsPage/AdminSettingsPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddStaffSheet extends StatefulWidget {
  const AddStaffSheet({super.key});

  @override
  State<AddStaffSheet> createState() => _AddStaffSheetState();
}

class _AddStaffSheetState extends State<AddStaffSheet> {
  final controller = Get.find<AdminSettingsController>();
  final primary = const Color(0xFF2F5BEA);
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  String selectedRole = 'Serveur';

  final roles = [
    'Serveur',
    'Barman',
    'Cuisinier',
    'Manager',
    'Caissier',
  ];

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    super.dispose();
  }

  void _addStaff() {
    if (!_formKey.currentState!.validate()) return;

    final parts = nameCtrl.text.split(' ');
    final initials = parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : nameCtrl.text[0].toUpperCase();

    controller.addStaff({
      'id': 'staff${DateTime.now().millisecondsSinceEpoch}',
      'name': nameCtrl.text,
      'email': emailCtrl.text,
      'role': selectedRole,
      'status': 'active',
      'initials': initials,
    });

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final size = media.size;
    final isTablet = size.width > 600;
    final bottomInset = media.viewInsets.bottom;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      minChildSize: 0.65,
      maxChildSize: 0.65,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),

              /// CONTENU SCROLLABLE
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    isTablet ? 24 : 20,
                    16,
                    isTablet ? 24 : 20,
                    bottomInset + 20,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// HEADER
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ajouter un membre',
                              style: TextStyle(
                                fontSize: isTablet ? 18 : 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, size: 20),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        /// NOM COMPLET
                        const Text(
                          'Nom complet',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: nameCtrl,
                          decoration: _inputDecoration('Ex: Marie Martin'),
                          textCapitalization: TextCapitalization.words,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Le nom est requis';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        /// EMAIL
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: emailCtrl,
                          decoration: _inputDecoration('marie@bar.com'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'L\'email est requis';
                            }
                            if (!v.contains('@')) {
                              return 'Email invalide';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        /// RÔLE
                        const Text(
                          'Rôle',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          borderRadius: BorderRadius.circular(12),
                          isDense: true,
                          isExpanded: true,
                          value: selectedRole,
                          items: roles
                              .map((r) => DropdownMenuItem(
                                    value: r,
                                    child: Text(r),
                                  ))
                              .toList(),
                          onChanged: (v) => setState(() => selectedRole = v!),
                          decoration: _inputDecoration('Sélectionner un rôle'),
                        ),
                        const SizedBox(height: 30),

                        /// BOUTONS
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Get.back(),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(52),
                                  side: BorderSide(color: Colors.grey[300]!),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Annuler',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _addStaff,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  minimumSize: const Size.fromHeight(52),
                                  elevation: 2,
                                  shadowColor: primary.withOpacity(0.3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Ajouter',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey[400],
        fontSize: 14,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primary, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
    );
  }
}
