import 'package:drink_eazy/Api/core/secure_storage.dart';
import 'package:drink_eazy/Api/services/auth_api.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthApi _authApi = AuthApi();

  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _user; // 👤 Infos de l'utilisateur connecté

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
      await SecureStorage.writeToken(data['token']);
      _setUser(data['user']); // ✅ Stocke les infos utilisateur
      _setLoading(false);
      return true;
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
      await _authApi.register(userData);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // 🔹 FORGOT PASSWORD (envoi OTP)
  Future<bool> forgotPassword(String login) async {
    _setLoading(true);
    _setError(null);
    try {
      await _authApi.forgotPassword(login);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // 🔹 VERIFY OTP
  Future<Map<String, dynamic>?> verifyOtp(String login, String otp) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await _authApi.verifyOtp(login, otp);
      _setUser(response['user']); // ✅ Stocke aussi le user après vérif OTP
      _setLoading(false);
      return response;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return null;
    }
  }

  // 🔹 RESET PASSWORD avec OTP
  Future<bool> resetPassword(
    String login,
    String otp,
    String password,
    String passwordConfirmation,
  ) async {
    _setLoading(true);
    _setError(null);
    try {
      await _authApi.resetPassword({
        'login': login,
        'otp': otp,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // 🔹 RESET PASSWORD avec Token (après OTP validé)
  Future<bool> resetPasswordWithToken(
    String login,
    String password,
    String confirm,
    String token,
  ) async {
    _setLoading(true);
    _setError(null);
    try {
      await _authApi.resetPassword({
        'login': login,
        'password': password,
        'password_confirmation': confirm,
        'token': token, // token de vérification OTP
      });
      _setLoading(false);
      return true;
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
