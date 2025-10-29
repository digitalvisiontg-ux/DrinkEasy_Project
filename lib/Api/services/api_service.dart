import 'package:dio/dio.dart';
import 'package:drink_eazy/Api/config/env.dart';
import 'package:drink_eazy/Api/core/secure_storage.dart';

class ApiService {
  final Dio _dio;

  ApiService._internal(this._dio);

  factory ApiService() {
    final dio = Dio(BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
      },
      contentType: Headers.jsonContentType,
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Ajout du token si disponible (prépare pour l'auth)
        try {
          final token = await SecureStorage.readToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        } catch (_) {}
        return handler.next(options);
      },
      onResponse: (response, handler) => handler.next(response),
      onError: (e, handler) async {
        // Si le backend renvoie 401/403, supprimer le token local (token invalide/expiré)
        try {
          final status = e.response?.statusCode;
          if (status == 401 || status == 403) {
            await SecureStorage.deleteToken();
            await SecureStorage.deleteUser();
          }
        } catch (_) {}
        return handler.next(e);
      },
    ));

    return ApiService._internal(dio);
  }

  Future<Response> get(String path, {Map<String, dynamic>? params}) => _dio.get(path, queryParameters: params);
  Future<Response> post(String path, Map<String, dynamic> data) => _dio.post(path, data: data);
  Future<Response> put(String path, Map<String, dynamic> data) => _dio.put(path, data: data);
  Future<Response> delete(String path) => _dio.delete(path);
}