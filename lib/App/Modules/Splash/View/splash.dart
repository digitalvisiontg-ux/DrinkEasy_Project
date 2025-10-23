import 'package:drink_eazy/App/Component/button_component.dart';
import 'package:drink_eazy/App/Modules/Home/View/home.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.restoreSession();
    if (auth.user != null) {
      // Utilisateur déjà connecté, on saute le splash
      Get.offAll(() => const Home());
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/bgimage2.jpg', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.amber)
                        : GestureDetector(
                            onTap: () {
                              Get.offAll(() => const Home());
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
