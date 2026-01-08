class TableModel {
  final int id;
  final String numeroTable;
  final String? qrUrl;

  TableModel({
    required this.id,
    required this.numeroTable,
    this.qrUrl,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    // Si Laravel renvoie { "success": true, "data": { "table_id": 1, ... } }
    // On extrait d'abord la map 'data'
    final data = json['data'] ?? json; 

    return TableModel(
      id: data['table_id'], // On utilise bien 'table_id' comme dans ton Controller
      numeroTable: data['numero_table'],
      qrUrl: data['qr_url'], // Optionnel si tu en as besoin
    );
  }
}