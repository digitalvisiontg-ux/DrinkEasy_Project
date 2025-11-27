import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:drink_eazy/Api/services/auth_api.dart';
import 'package:drink_eazy/Api/core/secure_storage.dart';



class AuthProvider extends ChangeNotifier {
  /// Indique si un utilisateur est connecté
  bool get isAuthenticated => _user != null;

  /// Structure attendue pour _user :
  /// {
  ///   'id': int,
  ///   'name': String,
  ///   'email': String,
  ///   ...
  /// }
  /// 
  /// 
  /// 

  // 🔹 RESTORE SESSION (auto-login)
  Future<void> restoreSession() async {
    final token = await SecureStorage.readToken();
    if (token != null && token.isNotEmpty) {
      // 1) Restaurer l'utilisateur localement si disponible (permet affichage immédiat)
      final localUser = await SecureStorage.readUser();
      if (localUser != null) {
        _setUser(localUser);
      }

      // 2) Valider le token en arrière-plan (ne pas bloquer l'UI)
      Future.microtask(() async {
        try {
          final data = await _authApi.getMe();
          if (data['user'] != null && data['user'] is Map<String, dynamic>) {
            _setUser(data['user']);
            // Mettre à jour le user stocké localement
            await SecureStorage.writeUser(Map<String, dynamic>.from(data['user']));
          } else {
            // backend ne retourne pas d'user — conserver local jusqu'à confirmation explicite
          }
        } on DioException catch (e) {
          final status = e.response?.statusCode;
          if (status == 401 || status == 403) {
            // token invalide : supprimer token et user local
            await SecureStorage.deleteToken();
            await SecureStorage.deleteUser();
            _setUser(null);
          } else {
            // erreur réseau : ne pas supprimer le token/localUser, on reste connecté localement
          }
        } catch (_) {
          // parsing ou autre erreur : ne rien supprimer, on garde le user local
        }
      });
    } else {
      _setUser(null);
      await SecureStorage.deleteUser();
    }
  }

  // 🔹 REGISTER
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    _setLoading(true);
    _setError(null);
    try {
      final data = await _authApi.register(userData);

      final token = data['token'];
      final user = data['user'];

      if (token is String && token.isNotEmpty) await SecureStorage.writeToken(token);
      if (user is Map<String, dynamic>) {
        _setUser(user);
        await SecureStorage.writeUser(Map<String, dynamic>.from(user));
      }

      final ok = (token is String && token.isNotEmpty) || (user is Map<String, dynamic>) || (data['message'] != null && data['message'].toString().isNotEmpty);

      _setLoading(false);
      return {
        'success': ok,
        'message': data['message'],
        'error': ok ? null : _errorMessage,
      };
    } catch (e) {
      final msg = e is Exception
          ? e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '')
          : e.toString();
      _setError(msg);
      _setLoading(false);
      return {
        'success': false,
        'message': null,
        'error': _errorMessage,
      };
    }
  }
  final AuthApi _authApi = AuthApi();

  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get user => _user;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    // Gestion professionnelle des erreurs pour l'utilisateur final
    if (message == null) {
      _errorMessage = null;
    } else {
      // Normalize for matching but keep original message for display when
      // we don't want to override backend text.
      final low = message.toLowerCase();

      // Exact/backend French messages mapping -> user-friendly French
      if (low.contains('email ou téléphone') || low.contains('email ou telephone') || low.contains('email ou numéro') || low.contains('email ou numero')) {
        _errorMessage = "Veuillez fournir un email ou un numéro de téléphone.";
      } else if (low.contains('numéro invalide') || low.contains('numero invalide')) {
        _errorMessage = "Numéro de téléphone invalide.";
      } else if (low.contains('Utilisateur introuvable') || low.contains('utilisateur non trouvé') || low.contains('utilisateur non trouve')) {
        _errorMessage = "Utilisateur introuvable.";
      } else if (low.contains('Email introuvable') || low.contains('email introuvable')) {
        _errorMessage = "Email introuvable. Veuillez vous inscrire d'abord.";
      } else if (low.contains('Numéro introuvable') || low.contains('Numero introuvable')) {
        _errorMessage = "Numéro introuvable. Veuillez vous inscrire d'abord.";
      } else if (low.contains('mot de passe incorrect') || (low.contains('mot de passe') && low.contains('incorrect'))) {
        _errorMessage = "Mot de passe incorrect.";
      } else if (low.contains('otp invalide') || low.contains('code otp invalide') || low.contains('aucun otp') || low.contains('otp expir')) {
        _errorMessage = "Code OTP invalide ou expiré.";
      } else if (low.contains('nombre maximum de tentatives') || low.contains('maximum de tentatives')) {
        _errorMessage = "Nombre maximum de tentatives atteint. Veuillez réessayer plus tard.";
      } else if (low.contains('format de l') && low.contains('email')) {
        _errorMessage = "Format de l'email invalide.";
      } else if (low.contains('erreur serveur') || low.contains('server') || low.contains('500')) {
        // Keep a friendly message for server-side errors
        _errorMessage = "Le serveur a rencontré une erreur. Veuillez réessayer plus tard.";
      } else if (low.contains('already') || low.contains('has already been taken') || low.contains('existe déjà') || low.contains('existe deja')) {
        _errorMessage = "Ce numéro ou e-mail est déjà inscrit.";
      } else if (low.contains('token')) {
        _errorMessage = "Session expirée, veuillez vous reconnecter.";
      } else {
        // Pour tous les autres cas, privilégier le message renvoyé par le backend
        // (plus précis et possibly contains accents). On le renvoie tel quel.
        _errorMessage = message;
      }
    }
    notifyListeners();
  }

  void _setUser(Map<String, dynamic>? data) {
    _user = data;
    notifyListeners();
  }

  // 🔹 LOGIN
  Future<bool> login(String login, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      final data = await _authApi.login(login, password);

      final token = data['token'];
      final user = data['user'];

      if (token is String && token.isNotEmpty) await SecureStorage.writeToken(token);
      if (user is Map<String, dynamic>) {
        _setUser(user);
        await SecureStorage.writeUser(Map<String, dynamic>.from(user));
      }

      final ok = (token is String && token.isNotEmpty) || (user is Map<String, dynamic>);

      _setLoading(false);
      return ok;
    } catch (error) {
      final msg = error is Exception
          ? error.toString().replaceFirst(RegExp(r'^Exception:\s*'), '')
          : error.toString();
      _setError(msg);
      _setLoading(false);
      return false;
    }
  }

  // 🔹 FORGOT PASSWORD (send OTP)
  Future<bool> forgotPassword(String login) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await _authApi.forgotPassword(login);

      // backend doit renvoyer success ou message
      if (response['success'] == true) {
        _setLoading(false);
        return true;
      } else {
        _setError(response['message'] ?? 'Erreur lors de l’envoi de l’OTP');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      final msg = e is Exception
          ? e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '')
          : e.toString();
      _setError(msg);
      _setLoading(false);
      return false;
    }
  }

  // 🔹 VERIFY OTP
  Future<bool> verifyOtp(String login, String otp) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await _authApi.verifyOtp(login, otp);

      if (response['success'] == true) {
        if (response['user'] != null && response['user'] is Map<String, dynamic>) {
          _setUser(response['user']);
          await SecureStorage.writeUser(Map<String, dynamic>.from(response['user']));
        }
        _setLoading(false);
        return true;
      } else {
        _setError(response['message'] ?? 'Code OTP invalide');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      final msg = e is Exception
          ? e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '')
          : e.toString();
      _setError(msg);
      _setLoading(false);
      return false;
    }
  }

  // 🔹 RESET PASSWORD avec OTP
  Future<bool> resetPassword(String login, String otp, String password, String confirm) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await _authApi.resetPassword({
        'login': login,
        'otp': otp,
        'password': password,
        'password_confirmation': confirm,
      });

      if (response['success'] == true) {
        _setLoading(false);
        return true;
      } else {
        _setError(response['message'] ?? 'Erreur lors de la réinitialisation');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      final msg = e is Exception
          ? e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '')
          : e.toString();
      _setError(msg);
      _setLoading(false);
      return false;
    }
  }

  // modification
  Future<bool> updateProfile(Map<String, dynamic> data, {File? avatar}) async {
  _setLoading(true);
  _setError(null);
  try {
    final response = await _authApi.updateProfile(data, avatar: avatar);

    if (response['success'] == true || response['user'] != null) {
      if (response['user'] != null && response['user'] is Map<String, dynamic>) {
        _setUser(response['user']);
        await SecureStorage.writeUser(Map<String, dynamic>.from(response['user']));
      }
      _setLoading(false);
      return true;
    } else {
      _setError(response['message'] ?? 'Erreur lors de la mise à jour du profil');
      _setLoading(false);
      return false;
    }
  } catch (e) {
    final msg = e is Exception
        ? e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '')
        : e.toString();
    _setError(msg);
    _setLoading(false);
    return false;
  }
}

  // 🔹 LOGOUT
  Future<void> logout() async {
    try {
      await _authApi.logout();
    } catch (_) {
      // On ignore l'erreur pour garantir la déconnexion locale
    }
    await SecureStorage.deleteToken();
    _setUser(null);
    notifyListeners();
  }

  Future<void> loadUser() async {
  try {
    final res = await _authApi.getMe();
    if (res['user'] != null && res['user'] is Map<String, dynamic>) {
      _setUser(Map<String, dynamic>.from(res['user']));
    } else {
      _setUser(null);
    }
  } catch (e) {
    _setError(e.toString()); // Utilise le setter pour notifier l'UI
  }
}

}