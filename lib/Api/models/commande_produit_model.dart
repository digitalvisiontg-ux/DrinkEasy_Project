class CommandeProduit {
  final int produitId;
  final String nomProduit;
  final String? taille;
  final int quantite;
  final double prixUnitaire;

  CommandeProduit({
    required this.produitId,
    required this.nomProduit,
    this.taille,
    required this.quantite,
    required this.prixUnitaire,
  });

  factory CommandeProduit.fromJson(Map<String, dynamic> json) {
    final produit = json['produit'] ?? {};

    double parseDouble(dynamic v) =>
        v is num ? v.toDouble() : double.tryParse(v.toString()) ?? 0.0;

    return CommandeProduit(
      produitId: json['produit_id'],
      nomProduit: produit['nomProd'] ?? '',
      taille: produit['taille'],
      quantite: json['quantite'],
      prixUnitaire: parseDouble(json['prix_unitaire']),
    );
  }

  /// ✅ AJOUT OBLIGATOIRE
  Map<String, dynamic> toJson() {
    return {
      "produit_id": produitId,
      "nomProduit": nomProduit,
      "taille": taille,
      "quantite": quantite,
      "prix_unitaire": prixUnitaire,
    };
  }
}