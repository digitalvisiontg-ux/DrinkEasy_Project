/* =========================================================
   BOTTOM SHEET – MODIFIER PROMOTION
   ========================================================= */

import 'package:drink_eazy/Admin_App/Admin_Modules/AdminPromotionsPage/AdminPromotionsPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart' show SnackPosition;

class EditPromotionSheet extends StatefulWidget {
  final Map<String, dynamic> promo;
  const EditPromotionSheet({required this.promo});

  @override
  State<EditPromotionSheet> createState() => EditPromotionSheetState();
}

class EditPromotionSheetState extends State<EditPromotionSheet> {
  final controller = Get.find<AdminPromotionsController>();
  final primary = const Color(0xFF2F5BEA);
  final _formKey = GlobalKey<FormState>();

  late String selectedProduct;
  late String promoType;
  late String reductionType;

  late TextEditingController reductionCtrl;
  late TextEditingController buyQtyCtrl;
  late TextEditingController freeQtyCtrl;
  late TextEditingController startDateCtrl;
  late TextEditingController endDateCtrl;

  DateTime? startDate;
  DateTime? endDate;

  late List<String> products;

  @override
  void initState() {
    super.initState();

    // Initialiser la liste des produits
    products = [
      'Heineken',
      'Castel',
      'Mojito',
      'Bordeaux Rouge',
      'Coca-Cola',
      'Sprite',
      'Café Expresso',
      'Pizza Margherita',
    ];

    // S'assurer que le produit de la promotion est dans la liste
    final promoProductName = widget.promo['productName'];
    if (!products.contains(promoProductName)) {
      products.add(promoProductName);
    }

    selectedProduct = promoProductName;
    promoType = widget.promo['type'];
    reductionType = widget.promo['reductionType'] ?? 'percentage';

    reductionCtrl = TextEditingController(
      text: widget.promo['reductionValue']?.toString() ?? '',
    );
    buyQtyCtrl = TextEditingController(
      text: widget.promo['buyQuantity']?.toString() ?? '2',
    );
    freeQtyCtrl = TextEditingController(
      text: widget.promo['freeQuantity']?.toString() ?? '1',
    );

    startDate = widget.promo['startDate'];
    endDate = widget.promo['endDate'];

    startDateCtrl = TextEditingController(
      text: _formatDateForInput(startDate!),
    );
    endDateCtrl = TextEditingController(text: _formatDateForInput(endDate!));
  }

  @override
  void dispose() {
    reductionCtrl.dispose();
    buyQtyCtrl.dispose();
    freeQtyCtrl.dispose();
    startDateCtrl.dispose();
    endDateCtrl.dispose();
    super.dispose();
  }

  String _formatDateForInput(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _updatePromotion() {
    if (!_formKey.currentState!.validate()) return;

    String description = '';
    if (promoType == 'percentage') {
      description = '${reductionCtrl.text}% de réduction';
    } else {
      description =
          'Achetez ${buyQtyCtrl.text}, obtenez ${freeQtyCtrl.text} gratuit';
    }

    final index = controller.promotions.indexWhere(
      (p) => p['id'] == widget.promo['id'],
    );
    if (index != -1) {
      controller.promotions[index] = {
        'id': widget.promo['id'],
        'productName': selectedProduct,
        'type': promoType,
        'status': widget.promo['status'],
        'description': description,
        'startDate': startDate!,
        'endDate': endDate!,
        if (promoType == 'percentage') ...{
          'reductionType': reductionType,
          'reductionValue': int.parse(reductionCtrl.text),
          'buyQuantity': null,
          'freeQuantity': null,
        } else ...{
          'buyQuantity': int.parse(buyQtyCtrl.text),
          'freeQuantity': int.parse(freeQtyCtrl.text),
          'reductionType': null,
          'reductionValue': null,
        },
      };

      controller.promotions.refresh();

      Get.snackbar(
        'Succès',
        'Promotion modifiée avec succès',
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );

      Get.back();
    }
  }

  Future<void> _selectDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate! : endDate!,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(colorScheme: ColorScheme.light(primary: primary)),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
          startDateCtrl.text = _formatDateForInput(picked);
        } else {
          endDate = picked;
          endDateCtrl.text = _formatDateForInput(picked);
        }
      });
    }
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
              /// HANDLE
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
                      'Modifier la promotion',
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
                const SizedBox(height: 20),

                /// PRODUIT CONCERNÉ
                const Text(
                  'Produit concerné',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  borderRadius: BorderRadius.circular(12),
                  isDense: true,
                  isExpanded: true,
                  value: selectedProduct,
                  items: products
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedProduct = v!),
                  decoration: _decoration(selectedProduct),
                ),
                const SizedBox(height: 20),

                /// TYPE DE PROMOTION
                const Text(
                  'Type de promotion',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _promoTypeButton(
                        'Prix réduit',
                        Icons.percent,
                        'percentage',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _promoTypeButton(
                        'Offre spéciale',
                        Icons.card_giftcard,
                        'special_offer',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                /// CONFIGURATION SELON TYPE
                if (promoType == 'percentage') ...[
                  const Text(
                    'Type de réduction',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    borderRadius: BorderRadius.circular(12),
                    isDense: true,
                    isExpanded: true,
                    value: reductionType,
                    items: const [
                      DropdownMenuItem(
                        value: 'percentage',
                        child: Text('Pourcentage (%)'),
                      ),
                      DropdownMenuItem(
                        value: 'fixed',
                        child: Text('Montant fixe (CFA)'),
                      ),
                    ],
                    onChanged: (v) => setState(() => reductionType = v!),
                    decoration: _decoration('Type de réduction'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Valeur de la réduction',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: reductionCtrl,
                    decoration: _decoration('0').copyWith(
                      suffixText: reductionType == 'percentage' ? '%' : 'CFA',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Requis';
                      final val = int.tryParse(v);
                      if (val == null || val <= 0) return 'Valeur invalide';
                      return null;
                    },
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Color(0xFF2563EB),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Configuration de l\'offre spéciale',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Définissez combien le client doit acheter pour obtenir des articles gratuits',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Quantité à acheter',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: buyQtyCtrl,
                              decoration: _decoration(''),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Requis';
                                final val = int.tryParse(v);
                                if (val == null || val <= 0) return 'Invalide';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Quantité gratuite',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: freeQtyCtrl,
                              decoration: _decoration(''),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Requis';
                                final val = int.tryParse(v);
                                if (val == null || val <= 0) return 'Invalide';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Aperçu : Achetez ${buyQtyCtrl.text}, obtenez ${freeQtyCtrl.text} gratuit',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                /// DATES
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Date de début',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: startDateCtrl,
                            decoration: _decoration('jj/mm/aaaa').copyWith(
                              suffixIcon: const Icon(
                                Icons.calendar_today,
                                size: 18,
                              ),
                            ),
                            readOnly: true,
                            onTap: () => _selectDate(true),
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Requis' : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Date de fin',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: endDateCtrl,
                            decoration: _decoration('jj/mm/aaaa').copyWith(
                              suffixIcon: const Icon(
                                Icons.calendar_today,
                                size: 18,
                              ),
                            ),
                            readOnly: true,
                            onTap: () => _selectDate(false),
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Requis' : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// ACTIONS
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
                        onPressed: _updatePromotion,
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
                          'Enregistrer',
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

  Widget _promoTypeButton(String label, IconData icon, String type) {
    final isSelected = promoType == type;
    return GestureDetector(
      onTap: () => setState(() => promoType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primary : const Color(0xFFE0E0E0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? primary : Colors.grey[600],
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? primary : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}
