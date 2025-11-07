import 'package:drink_eazy/Api/config/api_constants.dart';

class Produit {
  final int id;
  final String nomProd;
  final String? taille;
  final double prixBase;
  final String? descProd;
  final int qteStock;
  final bool actif;
  final String? imageUrl;
  final String? categorieNom;

  Produit({
    required this.id,
    required this.nomProd,
    this.taille,
    required this.prixBase,
    this.descProd,
    required this.qteStock,
    required this.actif,
    this.imageUrl,
    this.categorieNom,
  });

  factory Produit.fromJson(Map<String, dynamic> json) {
    double parsePrix(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    bool parseActif(dynamic v) {
      if (v == null) return false;
      if (v is bool) return v;
      if (v is num) return v.toInt() == 1;
      final s = v.toString().toLowerCase();
      return s == '1' || s == 'true' || s == 'on';
    }

    // 🔹 On génère le chemin complet vers l'image Laravel
    String? imagePath = json['imageUrl']?.toString();
    String? fullImageUrl;
    if (imagePath != null && imagePath.isNotEmpty) {
      fullImageUrl = imagePath.startsWith('http')
          ? imagePath
          : "${ApiConstants.baseStorageUrl}/$imagePath"; // baseStorageUrl = ex: http://127.0.0.1:8000/storage
    }

    return Produit(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()) ?? 0,
      nomProd: json['nomProd']?.toString() ?? '',
      taille: json['taille']?.toString(),
      prixBase: parsePrix(json['prixBase']),
      descProd: json['descProd']?.toString(),
      qteStock: json['qteStock'] is int
          ? json['qteStock'] as int
          : int.tryParse(json['qteStock']?.toString() ?? '0') ?? 0,
      actif: parseActif(json['actif']),
      imageUrl: fullImageUrl,
      categorieNom: json['categorie']?['nomCat']?.toString(),
    );
  }
}
