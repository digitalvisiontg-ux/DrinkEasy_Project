import 'package:drink_eazy/Api/config/api_constants.dart';

class Promotion {
  final String type;
  final String? typeReduction;
  final double? valeurReduction;
  final int? quantiteAchat;
  final int? quantiteOfferte;
  final String? heureDebut;
  final String? heureFin;
  final String texteBadge;
  final String texteDescription;

  Promotion({
    required this.type,
    this.typeReduction,
    this.valeurReduction,
    this.quantiteAchat,
    this.quantiteOfferte,
    this.heureDebut,
    this.heureFin,
    required this.texteBadge,
    required this.texteDescription,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    return Promotion(
      type: json['type']?.toString() ?? '',
      typeReduction: json['type_reduction']?.toString(),
      valeurReduction: parseDouble(json['valeur_reduction']),
      quantiteAchat: parseInt(json['quantite_achat']),
      quantiteOfferte: parseInt(json['quantite_offerte']),
      heureDebut: json['heure_debut']?.toString(),
      heureFin: json['heure_fin']?.toString(),
      texteBadge: json['texte_badge']?.toString() ?? '',
      texteDescription: json['texte_description']?.toString() ?? '',
    );
  }
}

class Categorie {
  final int id;
  final String nomCat;
  final String? descCat;
  final bool actif;

  Categorie({
    required this.id,
    required this.nomCat,
    this.descCat,
    required this.actif,
  });

  factory Categorie.fromJson(Map<String, dynamic> json) {
    bool parseActif(dynamic v) {
      if (v == null) return false;
      if (v is bool) return v;
      if (v is num) return v.toInt() == 1;
      final s = v.toString().toLowerCase();
      return s == '1' || s == 'true' || s == 'on';
    }

    return Categorie(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      nomCat: json['nomCat']?.toString() ?? '',
      descCat: json['descCat']?.toString(),
      actif: parseActif(json['actif']),
    );
  }
}

class Produit {
  final int id;
  final String nomProd;
  final String? taille;
  final double prixBase;
  final String? descProd;
  final int qteStock;
  final bool actif;
  final String? imageUrl;
  final int categorieId;
  final Categorie? categorie;
  final bool promotionActive;
  final double prixFinal;
  final List<Promotion> promotionsDetails;

  Produit({
    required this.id,
    required this.nomProd,
    this.taille,
    required this.prixBase,
    this.descProd,
    required this.qteStock,
    required this.actif,
    this.imageUrl,
    required this.categorieId,
    this.categorie,
    required this.promotionActive,
    required this.promotionsDetails,
    required this.prixFinal,
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

    String? imagePath = json['imageUrl']?.toString() ?? json['image_url']?.toString();
    String? fullImageUrl;
    if (imagePath != null && imagePath.isNotEmpty) {
      fullImageUrl = imagePath.startsWith('http')
          ? imagePath
          : "${ApiConstants.baseStorageUrl}/$imagePath";
    }

    List<Promotion> promotions = [];
    if (json['promotions_details'] != null && json['promotions_details'] is List) {
      promotions = (json['promotions_details'] as List)
          .map((p) => Promotion.fromJson(Map<String, dynamic>.from(p)))
          .toList();
    }

    bool promoActive = json['promotion_active'] == true || json['promotion_active'] == 1;

    double prixFinal = parsePrix(json['prixFinal'] ?? json['prix_final'] ?? json['prixBase']);

    return Produit(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      nomProd: json['nomProd']?.toString() ?? '',
      taille: json['taille']?.toString(),
      prixBase: parsePrix(json['prixBase'] ?? json['prix_base']),
      descProd: json['descProd']?.toString() ?? json['desc_prod']?.toString(),
      qteStock: json['qteStock'] is int
          ? json['qteStock'] as int
          : int.tryParse(json['qteStock']?.toString() ?? '0') ?? 0,
      actif: parseActif(json['actif']),
      imageUrl: fullImageUrl,
      categorieId: json['categorieId'] is int ? json['categorieId'] : int.tryParse(json['categorieId'].toString()) ?? 0,
      categorie: json['categorie'] != null
          ? Categorie.fromJson(Map<String, dynamic>.from(json['categorie']))
          : null,
      promotionsDetails: promotions,
      promotionActive: promoActive,
      prixFinal: prixFinal,
    );
  }
}
