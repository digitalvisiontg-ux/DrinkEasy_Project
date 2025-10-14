import 'package:dio/dio.dart';
import 'package:drink_eazy/Api/config/api_constants.dart';
import 'package:drink_eazy/Api/services/api_service.dart';

class BarApi {
  final ApiService _apiService;

  BarApi({ApiService? apiService}) : _apiService = apiService ?? ApiService();

  /// 🔹 Récupérer la liste des bars
  Future<List<dynamic>> fetchBars() async {
    try {
      final response = await _apiService.get(ApiConstants.bars);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Erreur récupération bars: ${e.response?.data ?? e.message}');
    }
  }

  /// 🔹 Créer un bar (POST)
  Future<Map<String, dynamic>> createBar(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(
        ApiConstants.bars,
        data,
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('Erreur création bar: ${e.response?.data ?? e.message}');
    }
  }

  /// 🔹 Modifier un bar existant (PUT)
  Future<Map<String, dynamic>> updateBar(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(
        ApiConstants.barsModif,
        data,
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('Erreur mise à jour bar: ${e.response?.data ?? e.message}');
    }
  }
}