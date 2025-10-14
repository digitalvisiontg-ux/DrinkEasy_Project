import 'package:drink_eazy/Api/services/bar_service.dart';
import 'package:flutter/material.dart';

class BarTestPage extends StatefulWidget {
  const BarTestPage({super.key});

  @override
  State<BarTestPage> createState() => _BarTestPageState();
}

class _BarTestPageState extends State<BarTestPage> {
  final BarApi barApi = BarApi();
  String result = "";

  Future<void> createBar() async {
    try {
      final data = {
        "name": "Bar du Soleil",
        "address": "Rue de la Mer",
        "description": "Ambiance tropicale et musique live",
      };

      final response = await barApi.createBar(data);
      setState(() {
        result = "✅ Bar créé avec succès: ${response.toString()}";
      });
    } catch (e) {
      setState(() {
        result = "❌ Erreur création: $e";
      });
    }
  }

  Future<void> updateBar() async {
    try {
      final data = {
        "name": "Bar du Soleil Rouge",
        "description": "Ambiance chaude et colorée",
      };

      // id = 1 ici (à remplacer par l’id réel d’un bar existant)
      final response = await barApi.updateBar(data);
      setState(() {
        result = "✅ Bar modifié: ${response.toString()}";
      });
    } catch (e) {
      setState(() {
        result = "❌ Erreur modification: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Bar API")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: createBar,
              child: const Text("Créer un Bar"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: updateBar,
              child: const Text("Modifier un Bar"),
            ),
            const SizedBox(height: 30),
            Text(result, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
