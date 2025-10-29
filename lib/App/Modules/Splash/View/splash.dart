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

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  bool _loading = true;
  late AnimationController _controller;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoScale;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _checkSession();
  }

  void _initAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.1, 0.6)),
    );

    _logoScale = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0)),
    );

    _controller.forward();
  }

  Future<void> _checkSession() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    // La restauration de session est maintenant lancée à l'initialisation du provider
    // (dans main). Ici on vérifie simplement si l'utilisateur est déjà chargé.
    if (auth.user != null) {
      Get.offAll(() => const Home());
    } else {
      // Donnons un petit délai pour laisser la restauration asynchrone démarrer
      await Future.delayed(const Duration(milliseconds: 200));
      if (auth.user != null) {
        Get.offAll(() => const Home());
      } else {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // --- Background ---
          Positioned.fill(
            child: Image.asset('assets/images/bgimage2.jpg', fit: BoxFit.cover),
          ),
          // --- Overlay ---
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),

          // --- Animated Glass Overlay (subtle moving light effect) ---
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(
                        0.03 + (0.02 * (1 - _controller.value)),
                      ),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // --- Content ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 20),

                  // --- Animated logo + text ---
                  FadeTransition(
                    opacity: _logoOpacity,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: Column(
                        children: [
                          const Text(
                            'DrinkEazy',
                            style: TextStyle(
                              fontSize: 42,
                              color: Colors.white,
                              fontFamily: 'Agbalumo',
                              letterSpacing: 1.5,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 2),
                                  blurRadius: 8,
                                  color: Colors.black38,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          FadeTransition(
                            opacity: _textOpacity,
                            child: const Text(
                              'Commandez en toute simplicité',
                              style: TextStyle(
                                color: Color.fromARGB(255, 232, 232, 232),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- Animated Button / Loader ---
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: _loading
                          ? const CircularProgressIndicator(
                              key: ValueKey('loader'),
                              color: Colors.amber,
                              strokeWidth: 3,
                            )
                          : ButtonComponent(
                              textButton: 'Commencer',
                              onPressed: () {
                                Get.offAll(() => const Home());
                              },
                            ),
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
