import 'package:drink_eazy/Admin_App/Admin_Modules/AdminPromotionsPage/AdminPromotionsPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPromotionSheet extends StatefulWidget {
  const AddPromotionSheet();

  @override
  State<AddPromotionSheet> createState() => AddPromotionSheetState();
}

class AddPromotionSheetState extends State<AddPromotionSheet> {
  final controller = Get.find<AdminPromotionsController>();
  final primary = const Color(0xFF2F5BEA);
  final _formKey = GlobalKey<FormState>();

  String? selectedProduct;
  String promoType = 'percentage';
  String reductionType = 'percentage';

  final TextEditingController reductionCtrl = TextEditingController();
  final TextEditingController buyQtyCtrl = TextEditingController(text: '2');
  final TextEditingController freeQtyCtrl = TextEditingController(text: '1');
  final TextEditingController startDateCtrl = TextEditingController();
  final TextEditingController endDateCtrl = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  final products = [
    'Heineken',
    'Castel',
    'Mojito',
    'Bordeaux Rouge',
    'Coca-Cola',
    'Sprite',
  ];

  @override
  void dispose() {
    reductionCtrl.dispose();
    buyQtyCtrl.dispose();
    freeQtyCtrl.dispose();
    startDateCtrl.dispose();
    endDateCtrl.dispose();
    super.dispose();
  }

  void _createPromotion() {
    if (!_formKey.currentState!.validate()) return;
    if (selectedProduct == null) {
      _showError('Veuillez sélectionner un produit');
      return;
    }
    if (startDate == null || endDate == null) {
      _showError('Veuillez sélectionner les dates');
      return;
    }

    String description = '';
    if (promoType == 'percentage') {
      description = '${reductionCtrl.text}% de réduction';
    } else {
      description =
          'Achetez ${buyQtyCtrl.text}, obtenez ${freeQtyCtrl.text} gratuit';
    }

    final newPromo = {
      'id': 'promo${DateTime.now().millisecondsSinceEpoch}',
      'productName': selectedProduct!,
      'type': promoType,
      'status': 'active',
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

    controller.addPromotion(newPromo);
    Get.back();
  }

  void _showError(String message) {
    Get.snackbar(
      'Erreur',
      message,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade900,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> _selectDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context)
              .copyWith(colorScheme: ColorScheme.light(primary: primary)),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
          startDateCtrl.text =
              '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
        } else {
          endDate = picked;
          endDateCtrl.text =
              '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
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
                              'Nouvelle promotion',
                              style: TextStyle(
                                fontSize: isTablet ? 18 : 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: Get.back,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  shape: BoxShape.circle,
                                ),
                                child:
                                    const Icon(Icons.close, size: 20),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        /// PRODUIT
                        const Text(
                          'Produit concerné',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          borderRadius: BorderRadius.circular(12),
                          isDense: true,
                          isExpanded: true,
                          value: selectedProduct,
                          items: products
                              .map((p) => DropdownMenuItem(
                                    value: p,
                                    child: Text(p),
                                  ))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => selectedProduct = v),
                          decoration:
                              _decoration('Sélectionner un produit'),
                          validator: (v) =>
                              v == null ? 'Sélectionnez un produit' : null,
                        ),
                        const SizedBox(height: 20),

                        /// TYPE PROMO
                        const Text(
                          'Type de promotion',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
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

                        /// CONFIGURATION
                        if (promoType == 'percentage') ...[
                          const Text(
                            'Type de réduction',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
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
                            onChanged: (v) =>
                                setState(() => reductionType = v!),
                            decoration:
                                _decoration('Type de réduction'),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: reductionCtrl,
                            decoration:
                                _decoration('Valeur de la réduction')
                                    .copyWith(
                              suffixText: reductionType == 'percentage'
                                  ? '%'
                                  : 'CFA',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Requis';
                              final val = int.tryParse(v);
                              if (val == null || val <= 0) {
                                return 'Valeur invalide';
                              }
                              return null;
                            },
                          ),
                        ] else ...[
                          const SizedBox(height: 8),
                          _specialOfferSection(),
                        ],

                        const SizedBox(height: 20),

                        /// DATES
                        _datesSection(),

                        const SizedBox(height: 24),

                        /// ACTIONS
                        _actionsRow(),
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

  Widget _specialOfferSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: Row(
            children: const [
              Icon(Icons.info_outline,
                  color: Color(0xFF2563EB), size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Définissez les quantités pour l’offre spéciale',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: buyQtyCtrl,
                decoration: _decoration('À acheter'),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Requis' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: freeQtyCtrl,
                decoration: _decoration('Gratuit'),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Requis' : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _datesSection() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: startDateCtrl,
            decoration: _decoration('Date début').copyWith(
              suffixIcon: const Icon(Icons.calendar_today, size: 18),
            ),
            readOnly: true,
            onTap: () => _selectDate(true),
            validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: endDateCtrl,
            decoration: _decoration('Date fin').copyWith(
              suffixIcon: const Icon(Icons.calendar_today, size: 18),
            ),
            readOnly: true,
            onTap: () => _selectDate(false),
            validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
          ),
        ),
      ],
    );
  }

  Widget _actionsRow() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: Get.back,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Annuler'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _createPromotion,
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Créer',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
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
            Icon(icon,
                color: isSelected ? primary : Colors.grey[600],
                size: 28),
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
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }
}
