import 'package:flutter/material.dart';
import 'package:get/get.dart';

/* =========================================================
   BOTTOM SHEET – CHANGER MOT DE PASSE (VERSION COMPLÈTE)
   ========================================================= */

class ChangePasswordSheet extends StatefulWidget {
  const ChangePasswordSheet({super.key});

  @override
  State<ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
  final primary = const Color(0xFF2F5BEA);
  final _formKey = GlobalKey<FormState>();
  
  final currentPwdCtrl = TextEditingController();
  final newPwdCtrl = TextEditingController();
  final confirmPwdCtrl = TextEditingController();

  bool obscureCurrentPwd = true;
  bool obscureNewPwd = true;
  bool obscureConfirmPwd = true;
  bool isLoading = false;

  @override
  void dispose() {
    currentPwdCtrl.dispose();
    newPwdCtrl.dispose();
    confirmPwdCtrl.dispose();
    super.dispose();
  }

  void _changePassword() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    // Simulation d'un appel API
    Future.delayed(const Duration(seconds: 1), () {
      Get.back();
      Get.snackbar(
        'Succès',
        'Mot de passe modifié avec succès',
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.check_circle, color: Colors.green),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final size = media.size;
    final isTablet = size.width > 600;
    final bottomInset = media.viewInsets.bottom;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.85,
      maxChildSize: 0.85,
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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.lock_outline,
                            color: primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Changer le mot de passe',
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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

                /// MOT DE PASSE ACTUEL
                const Text(
                  'Mot de passe actuel',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: currentPwdCtrl,
                  obscureText: obscureCurrentPwd,
                  decoration: _inputDecoration(
                    'Entrez votre mot de passe actuel',
                    Icons.lock_outline,
                  ).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureCurrentPwd
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                      onPressed: () => setState(() => obscureCurrentPwd = !obscureCurrentPwd),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Mot de passe actuel requis';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                /// NOUVEAU MOT DE PASSE
                const Text(
                  'Nouveau mot de passe',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: newPwdCtrl,
                  obscureText: obscureNewPwd,
                  decoration: _inputDecoration(
                    'Entrez votre nouveau mot de passe',
                    Icons.lock_outline,
                  ).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureNewPwd
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                      onPressed: () => setState(() => obscureNewPwd = !obscureNewPwd),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Nouveau mot de passe requis';
                    }
                    if (v.length < 6) {
                      return 'Au moins 6 caractères requis';
                    }
                    return null;
                  },
                  onChanged: (_) => setState(() {}), 
                ),
                const SizedBox(height: 6),
                Text(
                  'Au moins 6 caractères',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),

                /// CONFIRMER NOUVEAU MOT DE PASSE
                const Text(
                  'Confirmer le nouveau mot de passe',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: confirmPwdCtrl,
                  obscureText: obscureConfirmPwd,
                  decoration: _inputDecoration(
                    'Confirmez votre nouveau mot de passe',
                    Icons.shield_outlined,
                  ).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirmPwd
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                      onPressed: () => setState(() => obscureConfirmPwd = !obscureConfirmPwd),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Confirmation requise';
                    }
                    if (v != newPwdCtrl.text) {
                      return 'Les mots de passe ne correspondent pas';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                /// CONSEILS DE SÉCURITÉ
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 18,
                            color: primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Conseils de sécurité :',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _securityTip('Utilisez au moins 8 caractères'),
                      const SizedBox(height: 6),
                      _securityTip('Mélangez lettres, chiffres et symboles'),
                      const SizedBox(height: 6),
                      _securityTip('Évitez les informations personnelles'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                /// BOUTONS
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isLoading ? null : () => Get.back(),
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
                        onPressed: isLoading ? null : _changePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          minimumSize: const Size.fromHeight(52),
                          elevation: 2,
                          shadowColor: primary.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.save_outlined, size: 18, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Modifier',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
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

  Widget _securityTip(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey[400],
        fontSize: 14,
      ),
      prefixIcon: Icon(icon, size: 20, color: Colors.grey[600]),
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
        borderSide:  BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
    );
  }
}


void showChangePasswordSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const ChangePasswordSheet(),
  );
}