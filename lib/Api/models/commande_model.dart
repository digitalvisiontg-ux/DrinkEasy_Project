import 'package:drink_eazy/Api/models/commande_produit_model.dart';

class CommandeModel {
  final int id; // technique
  final String numeroCommande; // métier (ex: T123)
  final String status;
  final double total;
  final String tableLibelle;
  final DateTime createdAt;
  final List<CommandeProduit> produits;

  CommandeModel({
    required this.id,
    required this.numeroCommande,
    required this.status,
    required this.total,
    required this.tableLibelle,
    required this.createdAt,
    required this.produits,
  });

  factory CommandeModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic v) =>
        v is num ? v.toDouble() : double.tryParse(v.toString()) ?? 0.0;

    return CommandeModel(
      id: json['id'],
      numeroCommande: json['numero_commande'], // 👈 clé
      status: json['status'],
      total: parseDouble(json['total']),
      tableLibelle: json['table'],
      createdAt: DateTime.parse(json['created_at']),
      produits: (json['produits'] as List)
          .map((e) =>
              CommandeProduit.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

extension CommandeModelExt on CommandeModel {
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "numero_commande": numeroCommande,
      "status": status,
      "total": total,
      "table": tableLibelle,
      "created_at": createdAt.toIso8601String(),
      "produits": produits.map((e) => e.toJson()).toList(),
    };
  }

  CommandeModel copyWith({
    String? status,
    double? total,
    List<CommandeProduit>? produits,
  }) {
    return CommandeModel(
      id: id,
      numeroCommande: numeroCommande,
      status: status ?? this.status,
      total: total ?? this.total,
      tableLibelle: tableLibelle,
      createdAt: createdAt,
      produits: produits ?? this.produits,
    );
  }
}




