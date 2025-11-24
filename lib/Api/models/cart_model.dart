import 'dart:convert';

import 'package:drink_eazy/Api/models/produit.dart';

class CartItem {
  final Produit produit;
  int quantite;

  CartItem({required this.produit, required this.quantite});

  double get subtotal => produit.prixFinal * quantite;

  Map<String, dynamic> toMap() {
    return {
      'produit': {
        'id': produit.id,
        'nomProd': produit.nomProd,
        'prixFinal': produit.prixFinal,
        'imageUrl': produit.imageUrl,
        'taille': produit.taille,
        // ajoute d'autres champs si nécessaire
      },
      'quantite': quantite,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    final p = map['produit'] as Map<String, dynamic>;
    // créer un Produit minimal — on n'utilise que les champs nécessaires
    final produit = Produit.fromJson({
      'id': p['id'],
      'nomProd': p['nomProd'],
      'prixFinal': p['prixFinal'],
      'imageUrl': p['imageUrl'],
      'taille': p['taille'],
      // valeurs par défaut pour les champs requis du constructeur Produit
      'prixBase': p['prixFinal'] ?? 0,
      'qteStock': 0,
      'actif': true,
      'categorieId': 0,
      'promotion_active': false,
      'promotions_details': [],
    });

    return CartItem(
      produit: produit,
      quantite: (map['quantite'] is int) ? map['quantite'] : int.tryParse(map['quantite'].toString()) ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItem.fromJson(String source) => CartItem.fromMap(json.decode(source));
}