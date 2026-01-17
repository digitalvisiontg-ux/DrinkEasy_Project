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

  late TextEditingController nameCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController descCtrl;

  late String category;
  late int stock;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.product['name']);
    priceCtrl = TextEditingController(
      text: widget.product['priceCfa'].toString(),
    );
    descCtrl = TextEditingController();
    category = widget.product['category'];
    stock = widget.product['stock'];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Modifier le produit',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: Get.back,
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _input(nameCtrl, 'Nom du produit'),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: category,
              items: [
                'Bière',
                'Cocktail',
                'Vin',
                'Soft',
                'Promotion',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => category = v!),
              decoration: _decoration('Catégorie'),
            ),

            const SizedBox(height: 12),
            _input(priceCtrl, 'Prix (€)', keyboard: TextInputType.number),
            const SizedBox(height: 12),

            /// STOCK
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE0E0E0)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Stock initial',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => stock++),
                        child: const Icon(Icons.keyboard_arrow_up, size: 18),
                      ),
                      Text(stock.toString()),
                      GestureDetector(
                        onTap: () {
                          if (stock > 0) setState(() => stock--);
                        },
                        child: const Icon(Icons.keyboard_arrow_down, size: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                controller.updateProduct(widget.product['id'], {
                  'name': nameCtrl.text,
                  'priceCfa': int.parse(priceCtrl.text),
                  'category': category,
                  'stock': stock,
                });
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Enregistrer',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(
    TextEditingController c,
    String hint, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: c,
      keyboardType: keyboard,
      decoration: _decoration(hint),
    );
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
