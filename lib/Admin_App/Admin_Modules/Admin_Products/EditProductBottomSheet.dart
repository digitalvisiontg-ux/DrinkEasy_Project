import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'AdminProductsPage.dart';

void showEditProductBottomSheet(
  BuildContext context,
  Map<String, dynamic> product,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _EditProductSheet(product: product),
  );
}

class _EditProductSheet extends StatefulWidget {
  final Map<String, dynamic> product;
  const _EditProductSheet({required this.product});

  @override
  State<_EditProductSheet> createState() => _EditProductSheetState();
}

class _EditProductSheetState extends State<_EditProductSheet> {
  final controller = Get.find<AdminProductsController>();
  final primary = const Color(0xFF2F5BEA);
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController descCtrl;

  late String category;
  late int stock;
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
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.product['name']);
    priceCtrl =
        TextEditingController(text: widget.product['priceCfa'].toString());
    descCtrl = TextEditingController();
    category = widget.product['category'];
    stock = widget.product['stock'];
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    priceCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  void _updateProduct() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    Future.delayed(const Duration(milliseconds: 500), () {
      controller.updateProduct(widget.product['id'], {
        'name': nameCtrl.text,
        'priceCfa': int.parse(priceCtrl.text),
        'category': category,
        'stock': stock,
      });
      Get.back();
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final size = media.size;
    final bottomInset = media.viewInsets.bottom;
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
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              /// Handle visuel
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
                              'Modifier le produit',
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
                                child: const Icon(Icons.close, size: 20),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        /// NOM
                        TextFormField(
                          controller: nameCtrl,
                          decoration: _decoration('Nom du produit'),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Le nom est requis';
                            }
                            if (v.trim().length < 3) {
                              return 'Le nom doit contenir au moins 3 caractères';
                            }
                            return null;
                          },
                          textCapitalization: TextCapitalization.words,
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
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: 15, ),)),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => category = v!),
                          decoration: _decoration('Catégorie'),
                          validator: (v) => v == null
                              ? 'Sélectionnez une catégorie'
                              : null,
                          icon: const Icon(Icons.keyboard_arrow_down),
                        ),
                        const SizedBox(height: 16),

                        /// PRIX
                        TextFormField(
                          controller: priceCtrl,
                          decoration: _decoration('Prix (CFA)').copyWith(
                            prefixIcon:
                                const Icon(Icons.attach_money, size: 20),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Le prix est requis';
                            }
                            final price = int.tryParse(v);
                            if (price == null || price <= 0) {
                              return 'Entrez un prix valide';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        /// STOCK
                        Container(
                          height: 56,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFFE0E0E0)),
                            borderRadius: BorderRadius.circular(12),
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
                                  'Stock actuel',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove, size: 18),
                                      onPressed: () {
                                        if (stock > 0) {
                                          setState(() => stock--);
                                        }
                                      },
                                      padding: const EdgeInsets.all(4),
                                      constraints: const BoxConstraints(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Text(
                                        stock.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: stock < 10
                                              ? Colors.orange
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add, size: 18),
                                      onPressed: () =>
                                          setState(() => stock++),
                                      padding: const EdgeInsets.all(4),
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        /// ALERTE STOCK FAIBLE
                        if (stock < 10)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.orange.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.orange[700],
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Stock faible : Pensez à réapprovisionner',
                                    style: TextStyle(
                                      color: Colors.orange[900],
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (stock < 10) const SizedBox(height: 16),

                        /// DESCRIPTION
                        TextFormField(
                          controller: descCtrl,
                          decoration:
                              _decoration('Description (facultative)'),
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
                                onPressed:
                                    isLoading ? null : Get.back,
                                style: OutlinedButton.styleFrom(
                                  minimumSize:
                                      const Size.fromHeight(52),
                                  side: BorderSide(
                                      color: Colors.grey[300]!),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12),
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
                                onPressed: isLoading
                                    ? null
                                    : _updateProduct,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  minimumSize:
                                      const Size.fromHeight(52),
                                  elevation: 2,
                                  shadowColor:
                                      primary.withOpacity(0.3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12),
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
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                    : const Text(
                                        'Enregistrer',
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
