import 'package:drink_eazy/Api/models/commande_produit_model.dart';

class CommandeModel {
  final int id;
  final String status;
  final double total;
  final String tableNumero;
  final DateTime createdAt;
  final List<CommandeProduit> produits;

  CommandeModel({
    required this.id,
    required this.status,
    required this.total,
    required this.tableNumero,
    required this.createdAt,
    required this.produits,
  });

  factory CommandeModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic v) =>
        v is num ? v.toDouble() : double.tryParse(v.toString()) ?? 0.0;

    return CommandeModel(
      id: json['id'],
      status: json['status'],
      total: parseDouble(json['total']),
      tableNumero: json['table'],
      createdAt: DateTime.parse(json['created_at']),
      produits: (json['produits'] as List)
          .map((e) =>
              CommandeProduit.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}
