import 'package:dio/dio.dart';
import 'package:drink_eazy/Api/config/api_constants.dart';
import 'package:drink_eazy/Api/services/api_service.dart';

class AuthApi {
  final ApiService _apiService;

  AuthApi({ApiService? apiService}) : _apiService = apiService ?? ApiService();

  /// Register
  /// data: {name?, email?, phone?, password, password_confirmation}
  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(ApiConstants.authRegister, data);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Erreur register: ${_extractError(e)}');
    }
  }

  /// Login
  /// data: {login, password}
  /// Expected response: { message, token, user }
  Future<Map<String, dynamic>> login(String login, String password) async {
    try {
      final response = await _apiService.post(ApiConstants.authLogin, {
        'login': login,
        'password': password,
      });
      return response.data;
    } on DioException catch (e) {
      throw Exception('Erreur login: ${_extractError(e)}');
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String login) async {
  final response = await _apiService.post(ApiConstants.authForgotPassword, {'login': login});
  return response.data;
}

Future<Map<String, dynamic>> verifyOtp(String login, String otp) async {
  final response = await _apiService.post('${ApiConstants.authBase}/verify-otp', {'login': login, 'otp': otp});
  return response.data;
}

Future<Map<String, dynamic>> resetPassword(Map<String, dynamic> data) async {
  final response = await _apiService.post(ApiConstants.authResetPassword, data);
  return response.data;
}

  /// Delete account (requires token — ApiService injecte Authorization)
  Future<Map<String, dynamic>> deleteAccount() async {
    try {
      final response = await _apiService.delete(ApiConstants.authDeleteAccount);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Erreur deleteAccount: ${_extractError(e)}');
    }
  }

  // Utilitaire pour extraire message d'erreur (dès que possible)
  String _extractError(DioException e) {
    try {
      final data = e.response?.data;
      if (data == null) return e.message ?? 'Erreur inconnue';
      if (data is Map && data['message'] != null)
        return data['message'].toString();
      return data.toString();
    } catch (_) {
      return e.message ?? 'Erreur inconnue';
    }
  }
}
