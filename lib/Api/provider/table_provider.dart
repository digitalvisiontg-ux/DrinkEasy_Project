import 'package:flutter/material.dart';
import 'package:drink_eazy/Api/models/table_model.dart';
import 'package:drink_eazy/Api/services/table_service.dart';

class TableProvider with ChangeNotifier {
  final TableService _service = TableService();

  TableModel? _table;
  bool _loading = false;
  String? _error;

  TableModel? get table => _table;
  bool get isLoading => _loading;
  String? get error => _error;

  bool get isValidated => _table != null;

  /// --- Vérification QR ---
  Future<bool> verifyByQr(String token) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _service.verifyByQr(token);

      if (data['success'] == true) {
        _table = TableModel.fromJson(data);
        _loading = false;
        notifyListeners();
        return true; // Succès
      } else {
        _table = null;
        _error = data['message'] ?? 'QR invalide';
        _loading = false;
        notifyListeners();
        return false; // Échec
      }
    } catch (e) {
      _table = null;
      _error = 'Erreur serveur';
      _loading = false;
      notifyListeners();
      return false;
    }
  }
  /// --- Vérification manuelle ---
  Future<bool> verifyByManual(String numeroTable) async {
  _loading = true;
  _error = null;
  notifyListeners();

  try {
    final data = await _service.verifyByManual(numeroTable);

    // Si le JSON contient success=false → table invalide
    if (data['success'] == true) {
      _table = TableModel.fromJson(data);
      _loading = false;
      notifyListeners();
      return true;
    } else if (data['success'] == false) {
      _table = null;
      _error = data['message'] ?? 'Numéro de table invalide';
      _loading = false;
      notifyListeners();
      return false;
    } else {
      // Cas où le JSON est incomplet ou inattendu
      _table = null;
      _error = 'Numéro de table invalide';
      _loading = false;
      notifyListeners();
      return false;
    }
  } catch (e) {
    // Catch = problème serveur ou réseau
    _table = null;
    _error = 'Erreur serveur, réessayez';
    _loading = false;
    notifyListeners();
    return false;
  }
}
  void clearTable() {
    _table = null;
    notifyListeners();
  }
}
