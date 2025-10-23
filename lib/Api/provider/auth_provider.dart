import 'package:flutter/material.dart';
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

  // 🔹 RESTORE SESSION (auto-login)
  Future<void> restoreSession() async {
    final token = await SecureStorage.readToken();
    if (token != null && token.isNotEmpty) {
      try {
        final data = await _authApi.getMe();
        if (data['user'] != null && data['user'] is Map<String, dynamic>) {
          _setUser(data['user']);
        }
      } catch (e) {
        await SecureStorage.deleteToken();
        _setUser(null);
      }
    } else {
      _setUser(null);
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
      if (user is Map<String, dynamic>) _setUser(user);

      final ok = (token is String && token.isNotEmpty) || (user is Map<String, dynamic>) || (data['message'] != null && data['message'].toString().isNotEmpty);

      _setLoading(false);
      return {
        'success': ok,
        'message': data['message'],
        'error': ok ? null : _errorMessage,
      };
    } catch (e) {
      _setError(e.toString());
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
    } else if (message.contains('email') && message.contains('invalide')) {
      _errorMessage = "L'adresse e-mail est invalide.";
    } else if (message.contains('mot de passe') && message.contains('incorrect')) {
      _errorMessage = "Le mot de passe est incorrect.";
    } else if (message.contains('already') || message.contains('existe déjà') || message.contains('existe deja')) {
      _errorMessage = "Ce numéro ou e-mail est déjà inscrit.";
    } else if (message.contains('not found') || message.contains('introuvable')) {
      _errorMessage = "Aucun compte trouvé avec ces informations.";
    } else if (message.contains('token')) {
      _errorMessage = "Session expirée, veuillez vous reconnecter.";
    } else if (message.contains('OTP') || message.contains('otp')) {
      _errorMessage = "Le code reçu est invalide ou expiré.";
    } else if (message.contains('register')) {
      _errorMessage = "Votre inscription n'a pas pu aboutir. Veuillez vérifier vos informations.";
    } else if (message.contains('login')) {
      _errorMessage = "Connexion impossible. Vérifiez vos identifiants ou réessayez.";
    } else if (message.contains('Erreur inconnue') || message.contains('Exception')) {
      _errorMessage = "Une erreur est survenue. Veuillez réessayer.";
    } else if (message.toLowerCase().contains('server') || message.toLowerCase().contains('500')) {
      _errorMessage = "Le serveur ne répond pas. Veuillez réessayer plus tard.";
    } else {
      // Message générique si non reconnu
      _errorMessage = "Une erreur est survenue. Veuillez recommencer.";
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
      if (user is Map<String, dynamic>) _setUser(user);

      final ok = (token is String && token.isNotEmpty) || (user is Map<String, dynamic>);

      _setLoading(false);
      return ok;
    } catch (error) {
      _setError(error.toString());
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
      _setError(e.toString());
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
        }
        _setLoading(false);
        return true;
      } else {
        _setError(response['message'] ?? 'Code OTP invalide');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
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
      _setError(e.toString());
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
}
