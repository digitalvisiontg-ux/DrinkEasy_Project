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
  // removed _loading flag: bottom area now depends on auth state
  late AnimationController _controller;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoScale;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller and animations immediately so the
    // build phase can safely reference them, but don't start the animation
    // until after the first frame and assets are preloaded.
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

    // Précharger l'image de fond avant de lancer les animations pour éviter
    // le saut visuel lorsque l'image arrive après le rendu initial.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await precacheImage(const AssetImage('assets/images/bgimage2.jpg'), context);
      } catch (_) {}
      // Après préchargement, démarrer les animations et vérifier la session.
      _controller.forward();
      _checkSession();
    });
  }

  Future<void> _checkSession() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    // Si l'utilisateur est déjà connecté, afficher le splash un court instant
    // (sans bouton) puis rediriger vers Home.
    if (auth.user != null) {
      // afficher le splash ~700ms pour l'animation puis naviguer
      await Future.delayed(const Duration(milliseconds: 700));
      if (mounted) Get.offAll(() => const Home());
    } else {
      // L'utilisateur n'est pas connecté : laisser un court délai pour les animations
      await Future.delayed(const Duration(milliseconds: 200));
      // pas de changement d'état local nécessaire : le bouton s'affiche via Provider
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
      // Use a dark background while the image is loading so we don't show white
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // --- Background ---
          Positioned.fill(
            child: Container(
              // Use a decoration image rather than Image.asset to ensure the
              // background covers the whole screen (including under system bars)
              // and to avoid layout reflow during image load.
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bgimage2.jpg'),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
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
                      child: Builder(builder: (ctx) {
                        final auth = Provider.of<AuthProvider>(ctx);
                        // Si l'utilisateur est connecté, ne rien afficher en bas.
                        if (auth.user != null) {
                          // Keep a transparent placeholder with the same height as
                          // the 'Commencer' button so the layout spacing remains
                          // identical between connected and non-connected states.
                          return const SizedBox(
                            width: double.infinity,
                            height: 45,
                          );
                        }
                        // Si non connecté, afficher le bouton "Commencer" (pas de loader en bas).
                        return ButtonComponent(
                          textButton: 'Commencer',
                          onPressed: () {
                            Get.offAll(() => const Home());
                          },
                        );
                      }),
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
