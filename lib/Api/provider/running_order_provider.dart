import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:drink_eazy/Api/models/commande_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drink_eazy/Api/services/commande_service.dart';

/// ============================================================
/// RUNNING ORDER PROVIDER
/// Gère la dernière commande active validée côté backend
/// ============================================================
class RunningOrderProvider extends ChangeNotifier {
  static const _storageKey = 'running_order';
  static const _userSnapshotKey = 'user_banner_snapshot';
  static const _userTerminalAtKey = 'user_all_terminal_at';

  CommandeModel? _runningOrder;
  CommandeModel? _userCurrentActiveOrder;
  bool _userHasActiveOrders = false;
  Timer? _userPollTimer;
  final _service = CommandeService();
  DateTime? _userAllTerminalAt;
  CommandeModel? _userLastOrderSnapshot;

  /* ============================================================
   * GETTERS
   * ============================================================ */

  CommandeModel? get runningOrder => _runningOrder;
  bool get hasRunningOrder => _runningOrder != null;
  CommandeModel? get userCurrentActiveOrder => _userCurrentActiveOrder;
  bool get userHasActiveOrders => _userHasActiveOrders;
  DateTime? get userAllTerminalAt => _userAllTerminalAt;
  CommandeModel? get userLastOrderSnapshot => _userLastOrderSnapshot;
  bool get userShouldShowBanner =>
      _userHasActiveOrders ||
      (_userAllTerminalAt != null &&
          DateTime.now().difference(_userAllTerminalAt!) <
              const Duration(minutes: 30));
  CommandeModel? get currentBannerOrder =>
      _userCurrentActiveOrder ?? _userLastOrderSnapshot ?? _runningOrder;

  int? get id => _runningOrder?.id;
  String get numeroCommande => _runningOrder?.numeroCommande ?? '';
  String get status => _runningOrder?.status ?? '';
  double get total => _runningOrder?.total ?? 0.0;
  String get tableLibelle => _runningOrder?.tableLibelle ?? '';
  DateTime? get createdAt => _runningOrder?.createdAt;

  /* ============================================================
   * SET / UPDATE
   * ============================================================ */

  /// Appelé UNIQUEMENT après succès API
  Future<void> setRunningOrder(CommandeModel commande) async {
    _runningOrder = commande;
    notifyListeners();
    await _persist();
  }

  /// Mise à jour partielle (ex: status changé via websocket)
  Future<void> updateRunningOrder(CommandeModel updated) async {
    if (_runningOrder == null) return;

    _runningOrder = updated;
    notifyListeners();
    await _persist();
  }

  /* ============================================================
   * CLEAR
   * ============================================================ */

  Future<void> clearRunningOrder() async {
    _runningOrder = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  /* ============================================================
   * PERSISTENCE
   * ============================================================ */

  Future<void> _persist() async {
    if (_runningOrder == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(_runningOrder!.toJson()),
    );
  }

  /* ============================================================
   * RESTORE
   * ============================================================ */

  Future<void> restoreFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);

    if (raw == null) return;

    try {
      final decoded = jsonDecode(raw);
      _runningOrder = CommandeModel.fromJson(
        Map<String, dynamic>.from(decoded),
      );
      // Logique d'expiration: garder 1h après statut terminé
      if (_runningOrder != null) {
        final s = _runningOrder!.status.toLowerCase().trim();
        final isTerminal = _isTerminalStatus(s);
        final completedAt = _runningOrder!.completedAt;
        if (isTerminal && completedAt == null) {
          // Inconnu: initialiser maintenant pour une fenêtre de 1h
          _runningOrder = _runningOrder!.copyWith(completedAt: DateTime.now());
          await _persist();
        } else if (isTerminal && completedAt != null) {
          final diff = DateTime.now().difference(completedAt);
          if (diff > const Duration(hours: 1)) {
            await prefs.remove(_storageKey);
            _runningOrder = null;
          }
        }
      }
      notifyListeners();
    } catch (e) {
      // Corruption ou changement de schéma → purge
      await prefs.remove(_storageKey);
      _runningOrder = null;
    }

    // Restaurer aussi le snapshot USER (bannière 30min)
    try {
      final snapRaw = prefs.getString(_userSnapshotKey);
      final terminalAtIso = prefs.getString(_userTerminalAtKey);
      if (snapRaw != null) {
        _userLastOrderSnapshot = CommandeModel.fromJson(
          Map<String, dynamic>.from(jsonDecode(snapRaw)),
        );
      }
      if (terminalAtIso != null) {
        _userAllTerminalAt = DateTime.tryParse(terminalAtIso);
      }
    } catch (_) {}
  }

  /// Définir le statut et marquer completed_at si terminal
  Future<void> updateStatus(String newStatus) async {
    if (_runningOrder == null) return;
    final old = _runningOrder!;
    final wasTerminal = _isTerminalStatus(old.status.toLowerCase().trim());
    final willBeTerminal = _isTerminalStatus(newStatus.toLowerCase().trim());

    final now = DateTime.now();
    _runningOrder = old.copyWith(
      status: newStatus,
      completedAt: willBeTerminal && !wasTerminal ? now : old.completedAt,
    );
    notifyListeners();
    await _persist();
  }

  bool _isTerminalStatus(String s) {
    return [
      'completed',
      'paid',
      'servi',
      'terminee',
      'livrée',
      'livree',
      'delivered',
      'served',
    ].contains(s);
  }

  /// ===============================
  /// USER ACTIVE ORDERS POLLING
  /// ===============================
  void startUserOrdersPolling() {
    _userPollTimer?.cancel();
    _userPollTimer = Timer.periodic(const Duration(seconds: 6), (_) async {
      try {
        final list = await _service.getUserCommandes();
        // Map into models
        final models = list.map((e) => CommandeModel.fromJson(e)).toList();
        // Filter non-terminal statuses
        final actives = models.where((m) => !_isTerminalStatus(m.status.toLowerCase().trim())).toList();
        _userHasActiveOrders = actives.isNotEmpty;
        // Choose the most recent active by createdAt
        if (_userHasActiveOrders) {
          actives.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          _userCurrentActiveOrder = actives.first;
          _userAllTerminalAt = null;
          _userLastOrderSnapshot = _userCurrentActiveOrder;
          await _persistUserBannerState();
        } else {
          _userCurrentActiveOrder = null;
          if (_userAllTerminalAt == null) {
            _userAllTerminalAt = DateTime.now();
          }
          if (models.isNotEmpty) {
            models.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            _userLastOrderSnapshot = models.first;
          } else {
            _userLastOrderSnapshot = null;
          }
          await _persistUserBannerState();
        }
        notifyListeners();
      } catch (_) {
        // On erreur, ne change pas l'état pour éviter flicker
      }
    });
  }

  void stopUserOrdersPolling() {
    _userPollTimer?.cancel();
    _userPollTimer = null;
  }

  Future<void> _persistUserBannerState() async {
    final prefs = await SharedPreferences.getInstance();
    if (_userLastOrderSnapshot != null) {
      await prefs.setString(
        _userSnapshotKey,
        jsonEncode(_userLastOrderSnapshot!.toJson()),
      );
    } else {
      await prefs.remove(_userSnapshotKey);
    }
    if (_userAllTerminalAt != null) {
      await prefs.setString(_userTerminalAtKey, _userAllTerminalAt!.toIso8601String());
    } else {
      await prefs.remove(_userTerminalAtKey);
    }
  }
}
