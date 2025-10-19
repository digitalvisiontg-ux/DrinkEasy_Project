import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'package:drink_eazy/Api/core/secure_storage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: user == null
          ? const Center(child: Text('Aucune donnée utilisateur'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nom : ${user['name'] ?? '-'}'),
                  const SizedBox(height: 10),
                  Text('Téléphone : ${user['phone'] ?? '-'}'),
                  const SizedBox(height: 10),
                  Text('Email : ${user['email'] ?? '-'}'),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      await SecureStorage.deleteToken();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Déconnecté')),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Déconnexion'),
                  ),
                ],
              ),
            ),
    );
  }
}
