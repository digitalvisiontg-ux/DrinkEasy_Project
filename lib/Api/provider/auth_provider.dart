import 'package:flutter/material.dart';
import 'package:drink_eazy/Api/services/auth_api.dart';
import 'package:drink_eazy/Api/core/secure_storage.dart';

class AuthProvider extends ChangeNotifier {
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
    _errorMessage = message;
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
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // 🔹 REGISTER
  Future<bool> register(Map<String, dynamic> userData) async {
    _setLoading(true);
    _setError(null);
    try {
      final data = await _authApi.register(userData);

      final token = data['token'];
      final user = data['user'];

      if (token is String && token.isNotEmpty) await SecureStorage.writeToken(token);
      if (user is Map<String, dynamic>) _setUser(user);

      final ok = (token is String && token.isNotEmpty) || (user is Map<String, dynamic>);

      _setLoading(false);
      return ok;
    } catch (e) {
      _setError(e.toString());
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
    await SecureStorage.deleteToken();
    _setUser(null);
    notifyListeners();
  }
}
