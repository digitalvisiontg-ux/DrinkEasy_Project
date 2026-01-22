import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'AdminProductsPage.dart';

void showAddProductBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    enableDrag: true,
    isDismissible: true,
    builder: (_) => const _AddProductSheet(),
  );
}

class _AddProductSheet extends StatefulWidget {
  const _AddProductSheet();

  @override
  State<_AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<_AddProductSheet> {
  final controller = Get.find<AdminProductsController>();
  final primary = const Color(0xFF2F5BEA);
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController priceCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();

  String? category;
  int stock = 0;
  bool isLoading = false;

  final categories = [
    'Bière',
    'Cocktail',
    'Vin',
    'Soft',
    'Spiritueux',
    'Promotion',
  ];

  @override
  void dispose() {
    nameCtrl.dispose();
    priceCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  void _addProduct() {
    if (!_formKey.currentState!.validate()) return;
    if (category == null) {
      _showError('Veuillez sélectionner une catégorie');
      return;
    }

    setState(() => isLoading = true);

    // Simulation d'un délai réseau
    Future.delayed(const Duration(milliseconds: 500), () {
      final newProduct = {
        'id': 'p${DateTime.now().millisecondsSinceEpoch}',
        'name': nameCtrl.text,
        'category': category!,
        'boissonType': category!,
        'priceCfa': int.parse(priceCtrl.text),
        'oldPriceCfa': null,
        'promotion': null,
        'stock': stock,
        'status': 'available',
        'image': 'assets/images/boisson2.jpg', // Image par défaut
      };

      controller.addProduct(newProduct);
      Get.back();
    });
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


@override
Widget build(BuildContext context) {
  final media = MediaQuery.of(context);
  final bottomInset = media.viewInsets.bottom;
  final size = media.size;
  final isTablet = size.width > 600;

  return DraggableScrollableSheet(
    expand: false,
    initialChildSize: 0.75,
    minChildSize: 0.75,
    maxChildSize: 0.75,
    builder: (context, scrollController) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            /// Petit handle visuel (optionnel)
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
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Nouveau produit',
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
                              child:
                                  const Icon(Icons.close, size: 20),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      /// NOM PRODUIT
                      TextFormField(
                        controller: nameCtrl,
                        decoration:
                            _decoration('Nom du produit'),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Le nom est requis';
                          }
                          if (v.trim().length < 3) {
                            return 'Le nom doit contenir au moins 3 caractères';
                          }
                          return null;
                        },
                        textCapitalization:
                            TextCapitalization.words,
                      ),
                      const SizedBox(height: 16),

                      /// CATEGORIE
                      
                      DropdownButtonFormField<String>(
                        borderRadius: BorderRadius.circular(12),
                        isDense: true,
                        isExpanded: true,
                        value: category,
                        items: categories
                            .map(
                              (c) => DropdownMenuItem(
                                value: c,
                                child: Text(c, style: TextStyle(fontSize: 15, ),),
                              ),
                            )
                            .toList(),
                        onChanged: (v) =>
                            setState(() => category = v),
                        decoration: _decoration(
                            'Sélectionner une catégorie'),
                        validator: (v) => v == null
                            ? 'Sélectionnez une catégorie'
                            : null,
                        icon: const Icon(
                            Icons.keyboard_arrow_down),
                      ),
                      const SizedBox(height: 16),

                      /// PRIX
                      TextFormField(
                        controller: priceCtrl,
                        decoration:
                            _decoration('Prix (CFA)').copyWith(
                          prefixIcon: const Icon(
                            Icons.attach_money,
                            size: 20,
                          ),
                        ),
                        keyboardType:
                            TextInputType.number,
                        validator: (v) {
                          if (v == null ||
                              v.trim().isEmpty) {
                            return 'Le prix est requis';
                          }
                          final price =
                              int.tryParse(v);
                          if (price == null ||
                              price <= 0) {
                            return 'Entrez un prix valide';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      /// STOCK INITIAL
                      Container(
                        height: 56,
                        padding:
                            const EdgeInsets.symmetric(
                                horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                const Color(0xFFE0E0E0),
                          ),
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.inventory_2_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Stock initial',
                                style:
                                    TextStyle(fontSize: 15),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius:
                                    BorderRadius.circular(
                                        8),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      if (stock > 0) {
                                        setState(
                                            () => stock--);
                                      }
                                    },
                                    padding:
                                        const EdgeInsets
                                            .all(4),
                                    constraints:
                                        const BoxConstraints(),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                                horizontal:
                                                    12),
                                    child: Text(
                                      stock.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                      size: 18,
                                    ),
                                    onPressed: () =>
                                        setState(
                                            () => stock++),
                                    padding:
                                        const EdgeInsets
                                            .all(4),
                                    constraints:
                                        const BoxConstraints(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// DESCRIPTION
                      TextFormField(
                        controller: descCtrl,
                        decoration: _decoration(
                            'Description (facultative)'),
                        maxLines: 3,
                        textCapitalization:
                            TextCapitalization.sentences,
                      ),
                      const SizedBox(height: 24),

                      /// ACTIONS
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isLoading
                                  ? null
                                  : () => Get.back(),
                              style:
                                  OutlinedButton.styleFrom(
                                minimumSize:
                                    const Size.fromHeight(
                                        52),
                                side: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                          12),
                                ),
                              ),
                              child: const Text(
                                'Annuler',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : _addProduct,
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                minimumSize:
                                    const Size.fromHeight(
                                        52),
                                elevation: 2,
                                shadowColor:
                                    primary.withOpacity(
                                        0.3),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                          12),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child:
                                          CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<
                                                Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'Ajouter',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight:
                                            FontWeight.w600,
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
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:
          const BorderSide(color: Colors.red, width: 1.5),
    ),
  );
}


}
