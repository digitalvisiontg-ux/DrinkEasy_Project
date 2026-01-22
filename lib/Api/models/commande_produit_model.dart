class CommandeProduit {
  /// ID du produit
  final int produitId;

  /// Nom du produit (depuis relation produit)
  final String nomProduit;

  /// Taille éventuelle (ex: 33cl, 50cl)
  final String? taille;

  /// Quantité commandée
  final int quantite;

  /// Prix unitaire réellement facturé
  final double prixUnitaire;

  CommandeProduit({
    required this.produitId,
    required this.nomProduit,
    this.taille,
    required this.quantite,
    required this.prixUnitaire,
  });

  /* =======================
   * JSON → MODEL
   * ======================= */
  factory CommandeProduit.fromJson(Map<String, dynamic> json) {
    final produit = json['produit'] as Map<String, dynamic>?;

    double parseDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    return CommandeProduit(
      produitId: json['produit_id'] ?? 0,
      nomProduit: produit?['nomProd']?.toString() ?? '',
      taille: produit?['taille'],
      quantite: json['quantite'] ?? 0,
      prixUnitaire: parseDouble(json['prix_unitaire']),
    );
  }

  /* =======================
   * MODEL → JSON
   * (usage local uniquement)
   * ======================= */
  Map<String, dynamic> toJson() {
    return {
      "produit_id": produitId,
      "quantite": quantite,
      "prix_unitaire": prixUnitaire,
      "produit": {
        "nomProd": nomProduit,
        "taille": taille,
      }
    };
  }
}
