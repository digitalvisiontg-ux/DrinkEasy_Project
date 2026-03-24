import 'package:drink_eazy/Api/models/commande_produit_model.dart';

class CommandeModel {
  /// Identifiant technique
  final int id;

  /// Identifiant métier (ex: T4, T5…)
  final String numeroCommande;

  /// Statut (in_progress, served, cancelled…)
  final String status;

  /// Total calculé backend
  final double total;

  /// Libellé lisible de la table
  final String tableLibelle;

  /// ID user si connecté
  final int? userId;

  /// Token guest si invité
  final String? guestToken;

  /// Date de création
  final DateTime createdAt;

  /// Date de passage au statut terminé (local)
  final DateTime? completedAt;

  /// Lignes de commande
  final List<CommandeProduit> produits;

  /// Commentaire client
  final String? commentaireClient;

  CommandeModel({
    required this.id,
    required this.numeroCommande,
    required this.status,
    required this.total,
    required this.tableLibelle,
    required this.createdAt,
    required this.produits,
    this.userId,
    this.guestToken,
    this.completedAt,
    this.commentaireClient,
  });

  /* =======================
   * JSON → MODEL
   * ======================= */
  factory CommandeModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    return CommandeModel(
      id: json['id'] ?? 0,
      numeroCommande: json['numero_commande']?.toString() ?? '',
      status: json['status']?.toString() ?? 'unknown',
      total: parseDouble(json['total']),
      tableLibelle: json['table'] != null
          ? json['table']['libelle']?.toString() ?? ''
          : '',
      userId: json['user_id'],
      guestToken: json['guest_token'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'].toString())
          : null,
      produits: (json['produits'] is List)
          ? (json['produits'] as List)
              .map(
                (e) => CommandeProduit.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList()
          : <CommandeProduit>[],
      commentaireClient: json['commentaire_client']?.toString(),
    );
  }

  /* =======================
   * MODEL → JSON
   * (usage local uniquement)
   * ======================= */
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "numero_commande": numeroCommande,
      "status": status,
      "total": total,
      "table": tableLibelle,
      "user_id": userId,
      "guest_token": guestToken,
      "created_at": createdAt.toIso8601String(),
      "completed_at": completedAt?.toIso8601String(),
      "produits": produits.map((e) => e.toJson()).toList(),
      "commentaire_client": commentaireClient,
    };
  }

  /* =======================
   * COPY
   * ======================= */
  CommandeModel copyWith({
    String? status,
    double? total,
    List<CommandeProduit>? produits,
    DateTime? completedAt,
    String? commentaireClient,
  }) {
    return CommandeModel(
      id: id,
      numeroCommande: numeroCommande,
      status: status ?? this.status,
      total: total ?? this.total,
      tableLibelle: tableLibelle,
      userId: userId,
      guestToken: guestToken,
      createdAt: createdAt,
      produits: produits ?? this.produits,
      completedAt: completedAt ?? this.completedAt,
      commentaireClient: commentaireClient ?? this.commentaireClient,
    );
  }

  /* =======================
   * HELPERS
   * ======================= */
  bool get isGuest => guestToken != null;
  bool get isUser => userId != null;
}
