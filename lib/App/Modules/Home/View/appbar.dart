import 'package:drink_eazy/App/Modules/Cart/View/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

Widget buildAppBar(dynamic cartCount) {
  return AppBar(
    backgroundColor: Colors.white,
    centerTitle: false,
    // Mettre le retour sur false
    automaticallyImplyLeading: false,
    titleSpacing: 0,
    title: Row(
      children: [
        const SizedBox(width: 8),
        Text(
          'DrinkEasy',
          style: TextStyle(
            color: Colors.red.shade800,
            fontSize: 26,
            fontFamily: "Agbalumo",
          ),
        ),
      ],
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.person_outline, color: Colors.black87),
        onPressed: () => Get.toNamed('/account'),
      ),
      Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.black87,
            ),
            onPressed: () {
              Get.to(() => CartPage());
            },
          ),
          if (cartCount > 0)
            Positioned(
              right: 0,
              top: -3,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Text(
                  '${cartCount > 9 ? '9+' : cartCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      const SizedBox(width: 8),
    ],
  );
}
