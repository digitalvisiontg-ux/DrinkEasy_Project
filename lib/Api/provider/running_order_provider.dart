import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:drink_eazy/Api/models/commande_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider pour gérer la commande en cours (Running Order)
class RunningOrderProvider extends ChangeNotifier {
  CommandeModel? _runningOrder;

  /// ===============================
  /// GETTERS
  /// ===============================
  CommandeModel? get runningOrder => _runningOrder;
  bool get hasRunningOrder => _runningOrder != null;

  /// Pour accéder directement au numéro de commande
  String get numeroCommande => _runningOrder?.numeroCommande ?? '';

  /// Pour accéder à la table de la commande
  String get tableLibelle => _runningOrder?.tableLibelle ?? '';

  /// Pour accéder au statut de la commande
  String get status => _runningOrder?.status ?? '';

  /// ===============================
  /// SETTER après validation de commande
  /// ===============================
  Future<void> setRunningOrder(CommandeModel cmd) async {
    _runningOrder = cmd;
    notifyListeners();
    await _saveToLocal(cmd);
  }

  /// ===============================
  /// UPDATE du statut de la commande
  /// ===============================
  Future<void> updateStatus(String newStatus) async {
    if (_runningOrder == null) return;

    _runningOrder = _runningOrder!.copyWith(status: newStatus);
    notifyListeners();
    await _saveToLocal(_runningOrder!);
  }

  /// ===============================
  /// CLEAR / fin de commande
  /// ===============================
  Future<void> clearRunningOrder() async {
    _runningOrder = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('running_order');
  }

  /// ===============================
  /// Persistance locale
  /// ===============================
  Future<void> _saveToLocal(CommandeModel cmd) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('running_order', jsonEncode(cmd.toJson()));
  }

  /// ===============================
  /// Restauration au démarrage
  /// ===============================
  Future<void> restoreFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('running_order');
    if (raw != null) {
      _runningOrder = CommandeModel.fromJson(jsonDecode(raw));
      notifyListeners();
    }
  }
}
