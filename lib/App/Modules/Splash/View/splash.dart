import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drink_eazy/App/Component/button_component.dart';
import 'package:drink_eazy/App/Modules/Home/View/home.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'dart:async';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoScale;
  late Animation<double> _textOpacity;

  bool _isOffline = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  @override
  void initState() {
    super.initState();

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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await precacheImage(
            const AssetImage('assets/images/bgimage2.jpg'), context);
      } catch (_) {}
      _controller.forward();
      _checkConnectivity();
    });
  }

  void _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    // result est maintenant une List<ConnectivityResult>
    final hasConnection = result.isNotEmpty && !result.contains(ConnectivityResult.none);
    
    if (!hasConnection) {
      setState(() => _isOffline = true);
      return;
    }

    _connectivitySub =
        Connectivity().onConnectivityChanged.listen((resultList) async {
      if (!mounted) return;
      final hasConnNow = resultList.isNotEmpty && !resultList.contains(ConnectivityResult.none);
      if (hasConnNow && _isOffline) {
        setState(() => _isOffline = false);
        _checkSession();
      }
    });

    _checkSession();
  }

  Future<void> _checkSession() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.user != null) {
      await Future.delayed(const Duration(milliseconds: 700));
      if (mounted) Get.offAll(() => const Home());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _connectivitySub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // --- Background ---
          Positioned.fill(
            child: Container(
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
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.4))),
          // --- Animated Glass Overlay ---
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
                  // --- Animated Button / Offline Message ---
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: _isOffline
                          ? Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Vous êtes hors connexion. Impossible d’accéder à l’app.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : Builder(builder: (ctx) {
                              final auth = Provider.of<AuthProvider>(ctx);
                              if (auth.user != null) {
                                return const SizedBox(
                                  width: double.infinity,
                                  height: 45,
                                );
                              }
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
