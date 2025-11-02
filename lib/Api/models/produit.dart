class Produit {
  final int id;
  final String nomProd;
  final double prixBase;
  final String descProd;
  final String categorie;

  Produit({
    required this.id,
    required this.nomProd,
    required this.prixBase,
    required this.descProd,
    required this.categorie,
  });

  factory Produit.fromJson(Map<String, dynamic> json) {
    return Produit(
      id: json['id'],
      nomProd: json['nomProd'],
      prixBase: double.parse(json['prixBase'].toString()),
      descProd: json['descProd'] ?? '',
      categorie: json['categorie']?['nomCat'] ?? '',
    );
  }
}
