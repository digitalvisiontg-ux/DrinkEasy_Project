import 'package:drink_eazy/App/Component/button_component.dart';
import 'package:drink_eazy/App/Modules/Home/View/home.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/bgimage2.jpg', fit: BoxFit.cover),
          ),
          Positioned.fill(
            // ignore: deprecated_member_use
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),

          // Contenu principal
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 20),
                  Column(
                    children: const [
                      Text(
                        'DrinkEazy',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontFamily: 'Agbalumo',
                        ),
                      ),
                      Text(
                        'Commandez en toute simplicité',
                        style: TextStyle(
                          color: Color.fromARGB(255, 232, 232, 232),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  // Section du bas : bouton
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: GestureDetector(
                      onTap: () {
                        Get.offAll(Home());
                      },
                      child: ButtonComponent(textButton: 'Commencer'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
