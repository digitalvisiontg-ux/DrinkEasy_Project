class TableModel {
  final int id;
  final String numeroTable;
  final String libelle;     
  final String? qrUrl;

  TableModel({
    required this.id,
    required this.numeroTable,
    required this.libelle,
    this.qrUrl,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    return TableModel(
      id: data['table_id'],
      numeroTable: data['numero_table'],
      libelle: data['libelle'],
      qrUrl: data['qr_url'],
    );
  }
}
