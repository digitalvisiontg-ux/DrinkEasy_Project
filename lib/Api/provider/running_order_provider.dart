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
  Timer? _bannerHideTimer;
  final _service = CommandeService();
  DateTime? _userAllTerminalAt;
  CommandeModel? _userLastOrderSnapshot;
  DateTime? _bannerHideAt;
  bool _bannerForUser = false;

  /* ============================================================
   * GETTERS
   * ============================================================ */

  CommandeModel? get runningOrder => _runningOrder;
  bool get hasRunningOrder => _runningOrder != null;
  CommandeModel? get userCurrentActiveOrder => _userCurrentActiveOrder;
  bool get userHasActiveOrders => _userHasActiveOrders;
  DateTime? get userAllTerminalAt => _userAllTerminalAt;
  CommandeModel? get userLastOrderSnapshot => _userLastOrderSnapshot;
  bool get userShouldShowBanner {
    if (_userHasActiveOrders) return true;
    if (_userAllTerminalAt == null) return false;
    return DateTime.now().difference(_userAllTerminalAt!) <
        const Duration(minutes: 15);
  }
  bool get guestShouldShowBanner {
    if (_runningOrder == null) return false;
    final s = _runningOrder!.status.toLowerCase().trim();
    if (!_isTerminalStatus(s)) return true;
    final completedAt = _runningOrder!.completedAt;
    if (completedAt == null) return false;
    return DateTime.now().difference(completedAt) <
        const Duration(minutes: 15);
  }
  bool get shouldShowBanner => userShouldShowBanner || guestShouldShowBanner;
  CommandeModel? get currentBannerOrder {
    if (userShouldShowBanner) {
      return _userCurrentActiveOrder ?? _userLastOrderSnapshot;
    }
    if (guestShouldShowBanner) {
      return _runningOrder;
    }
    return null;
  }

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
    await prefs.setString(_storageKey, jsonEncode(_runningOrder!.toJson()));
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
      if (_runningOrder != null) {
        final s = _runningOrder!.status.toLowerCase().trim();
        final isTerminal = _isTerminalStatus(s);
        final completedAt = _runningOrder!.completedAt;
        if (isTerminal) {
          final base = completedAt ?? DateTime.now();
          if (completedAt == null) {
            _runningOrder = _runningOrder!.copyWith(completedAt: base);
            await _persist();
          }
          final diff = DateTime.now().difference(base);
          if (diff >= const Duration(minutes: 15)) {
            await prefs.remove(_storageKey);
            _runningOrder = null;
            debugPrint("RunningOrderProvider: guest banner cleared (15m elapsed)");
          } else {
            final remain = const Duration(minutes: 15) - diff;
            _scheduleGuestHide(remain);
            debugPrint("RunningOrderProvider: guest hide scheduled in ${remain.inSeconds}s");
          }
        }
      }
      notifyListeners();
    } catch (e) {
      // Corruption ou changement de schéma → purge
      await prefs.remove(_storageKey);
      _runningOrder = null;
    }

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
        if (_userAllTerminalAt != null) {
          final diff = DateTime.now().difference(_userAllTerminalAt!);
          if (diff >= const Duration(minutes: 15)) {
            _userAllTerminalAt = null;
            _userLastOrderSnapshot = null;
            debugPrint("RunningOrderProvider: user banner cleared on restore (15m elapsed)");
          } else {
            final remain = const Duration(minutes: 15) - diff;
            _scheduleUserHide(remain);
            debugPrint("RunningOrderProvider: user hide scheduled in ${remain.inSeconds}s on restore");
          }
        }
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
    if (willBeTerminal) {
      _cancelBannerTimer();
      _scheduleGuestHide(const Duration(minutes: 15));
      debugPrint("RunningOrderProvider: guest terminal reached, hide in 15m");
    } else {
      _cancelBannerTimer();
      debugPrint("RunningOrderProvider: guest status non-terminal, hide timer canceled");
    }
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
        final actives = models
            .where((m) => !_isTerminalStatus(m.status.toLowerCase().trim()))
            .toList();
        _userHasActiveOrders = actives.isNotEmpty;
        // Choose the most recent active by createdAt
        if (_userHasActiveOrders) {
          actives.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          _userCurrentActiveOrder = actives.first;
          _userAllTerminalAt = null;
          _userLastOrderSnapshot = _userCurrentActiveOrder;
          await _persistUserBannerState();
          _cancelBannerTimer();
          debugPrint("RunningOrderProvider: user has active orders, hide timer canceled");
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
          _cancelBannerTimer();
          _scheduleUserHide(const Duration(minutes: 15));
          debugPrint("RunningOrderProvider: user terminal state, hide in 15m");
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
    _cancelBannerTimer();
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
      await prefs.setString(
        _userTerminalAtKey,
        _userAllTerminalAt!.toIso8601String(),
      );
    } else {
      await prefs.remove(_userTerminalAtKey);
    }
  }

  void _scheduleGuestHide(Duration inDuration) {
    _cancelBannerTimer();
    _bannerForUser = false;
    _bannerHideAt = DateTime.now().add(inDuration);
    _bannerHideTimer = Timer(inDuration, () async {
      await clearRunningOrder();
      debugPrint("RunningOrderProvider: guest banner hidden after scheduled 15m");
    });
  }

  void _scheduleUserHide(Duration inDuration) {
    _cancelBannerTimer();
    _bannerForUser = true;
    _bannerHideAt = DateTime.now().add(inDuration);
    _bannerHideTimer = Timer(inDuration, () async {
      _userLastOrderSnapshot = null;
      _userAllTerminalAt = null;
      await _persistUserBannerState();
      notifyListeners();
      debugPrint("RunningOrderProvider: user banner hidden after scheduled 15m");
    });
  }

  void _cancelBannerTimer() {
    if (_bannerHideTimer != null) {
      _bannerHideTimer!.cancel();
      _bannerHideTimer = null;
      _bannerHideAt = null;
      debugPrint("RunningOrderProvider: hide timer canceled");
    }
  }

  void pauseBannerHideCountdown() {
    if (_bannerHideTimer == null || _bannerHideAt == null) {
      debugPrint("RunningOrderProvider: pause requested but no active hide timer");
      return;
    }
    final remain = _bannerHideAt!.difference(DateTime.now());
    _cancelBannerTimer();
    _bannerHideAt = DateTime.now().add(remain);
    debugPrint("RunningOrderProvider: hide timer paused, remaining ${remain.inSeconds}s");
  }

  void resumeBannerHideCountdown() {
    if (_bannerHideAt == null) {
      debugPrint("RunningOrderProvider: resume requested but no target time");
      return;
    }
    final remain = _bannerHideAt!.difference(DateTime.now());
    if (remain <= Duration.zero) {
      if (_bannerForUser) {
        _userLastOrderSnapshot = null;
        _userAllTerminalAt = null;
        _persistUserBannerState();
        notifyListeners();
        debugPrint("RunningOrderProvider: resume -> user banner cleared immediately");
      } else {
        clearRunningOrder();
        debugPrint("RunningOrderProvider: resume -> guest banner cleared immediately");
      }
      return;
    }
    if (_bannerForUser) {
      _scheduleUserHide(remain);
      debugPrint("RunningOrderProvider: hide timer resumed for user, ${remain.inSeconds}s remaining");
    } else {
      _scheduleGuestHide(remain);
      debugPrint("RunningOrderProvider: hide timer resumed for guest, ${remain.inSeconds}s remaining");
    }
  }

  @override
  void dispose() {
    _userPollTimer?.cancel();
    _bannerHideTimer?.cancel();
    super.dispose();
  }

  /* ============================================================
 * UPDATE COMMANDE (guest ou user)
 * ============================================================ */
Future<void> updateCommande({
  required CommandeModel commande,
  required List<Map<String, dynamic>> items,
  String? commentaire,
}) async {
  try {
    final res = await _service.updateCommande(
      commandeId: commande.id,
      items: items,
      commentaire: commentaire,
      guestToken: commande.isGuest ? commande.guestToken : null,
    );

    final updated =
        CommandeModel.fromJson(res['commande']);

    // Si c’est la runningOrder (guest)
    if (_runningOrder?.id == updated.id) {
      _runningOrder = updated;
      await _persist();
    }

    // Si user actif
    if (_userCurrentActiveOrder?.id == updated.id) {
      _userCurrentActiveOrder = updated;
      _userLastOrderSnapshot = updated;
      await _persistUserBannerState();
    }

    notifyListeners();
  } catch (e) {
    rethrow;
  }
}

/* ============================================================
 * DELETE COMMANDE
 * ============================================================ */
Future<void> deleteCommande(CommandeModel commande) async {
  try {
    await _service.deleteCommande(
      commandeId: commande.id,
      guestToken: commande.isGuest ? commande.guestToken : null,
    );

    // Si guest running order
    if (_runningOrder?.id == commande.id) {
      await clearRunningOrder();
    }

    // Si user active
    if (_userCurrentActiveOrder?.id == commande.id) {
      _userCurrentActiveOrder = null;
      _userHasActiveOrders = false;
      _userAllTerminalAt = DateTime.now();
      _scheduleUserHide(const Duration(minutes: 15));
      await _persistUserBannerState();
    }

    notifyListeners();
  } catch (e) {
    rethrow;
  }
}
}
