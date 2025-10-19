import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/Api/core/secure_storage.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'login_test_page.dart';
import 'register_test_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  Future<void> checkToken() async {
    final token = await SecureStorage.readToken();
    setState(() {
      isLoggedIn = token != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Accueil')),
      body: Center(
        child: isLoggedIn
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Bonjour, ${auth.user?['name'] ?? 'Utilisateur'} 👋'),
                  const SizedBox(height: 10),
                  Text(auth.user?['phone'] ?? auth.user?['email'] ?? ''),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfilePage()),
                      );
                    },
                    child: const Text('Voir mon profil'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await SecureStorage.deleteToken();
                      setState(() {
                        isLoggedIn = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Déconnecté avec succès')),
                      );
                    },
                    child: const Text('Déconnexion'),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Bienvenue sur DrinkEazy 👋'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginTestPage()),
                      );
                    },
                    child: const Text('Connexion'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterTestPage()),
                      );
                    },
                    child: const Text('Inscription'),
                  ),
                ],
              ),
      ),
    );
  }
}
