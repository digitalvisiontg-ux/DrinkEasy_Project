import 'package:drink_eazy/Api/config/api_constants.dart';
import 'package:drink_eazy/Api/services/api_service.dart';

class TableService {
  final ApiService _api = ApiService();

  /// Verification auto (QR) 
  Future<Map<String, dynamic>> verifyByQr(String token) async {
    final response = await _api.get(
      "${ApiConstants.baseUrl}/table/verify/$token",
    );
    return response.data;
  }

  /// Verification manual
  Future<Map<String, dynamic>> verifyByManual(String tableNumber) async {
  final encoded = Uri.encodeComponent(tableNumber.trim().toUpperCase());

  final response = await _api.get(
    "${ApiConstants.baseUrl}/table/verify-manual/$encoded",
  );

  return response.data;
}
}
