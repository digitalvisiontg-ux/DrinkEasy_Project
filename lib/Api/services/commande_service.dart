import 'package:dio/dio.dart';
import 'package:drink_eazy/Api/config/api_constants.dart';
import 'package:drink_eazy/Api/services/api_service.dart';

class CommandeService {
  final ApiService _api = ApiService();

  /// Création d'une commande (user ou invité)
Future<Map<String, dynamic>> createCommande({
required int tableId,
    required List<Map<String, dynamic>> items,
    String? commentaire,
}) async {

final response = await _api.dio.post(
ApiConstants.commandes,
data: {
'table_id': tableId,
'commentaire': commentaire,
'items': items,
},
);

return response.data;
}



  /// Récupération d'une commande par ID
  Future<Map<String, dynamic>> getCommandeById(int id) async {
    final response = await _api.get(
      ApiConstants.commandeById(id),
    );

    return response.data as Map<String, dynamic>;
  }

  /// Récupération des commandes d'un invité
  Future<Map<String, dynamic>> getCommandesByGuest(String guestToken) async {
    final response = await _api.dio.get(
      ApiConstants.commandeByGuest(guestToken),
      options: Options(
        headers: {
          'X-Guest-Token': guestToken,
        },
      ),
    );

    return response.data as Map<String, dynamic>;
  }
}