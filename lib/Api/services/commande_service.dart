import 'package:dio/dio.dart';
import 'package:drink_eazy/Api/config/api_constants.dart';
import 'package:drink_eazy/Api/services/api_service.dart';

class CommandeService {
  final ApiService _api = ApiService();

  /* ============================================================
   * CREATE COMMANDE
   * - USER : POST /commandes (Authorization auto)
   * - GUEST: POST /commandes/guest + X-Guest-Token
   * ============================================================ */
  Future<Map<String, dynamic>> createCommande({
    required int tableId,
    required List<Map<String, dynamic>> items,
    String? commentaireClient,
    String? guestToken,
  }) async {
    final bool isGuest = guestToken != null;

    final response = await _api.dio.post(
      isGuest ? ApiConstants.commandesGuest : ApiConstants.commandes,
      data: {'table_id': tableId, 'commentaire_client': commentaireClient, 'items': items},
      options: isGuest ? Options(headers: {'X-Guest-Token': guestToken}) : null,
    );

    return Map<String, dynamic>.from(response.data);
  }

  /* ============================================================
   * SHOW COMMANDE
   * ============================================================ */
  Future<Map<String, dynamic>> getCommandeById(int id) async {
    final response = await _api.get(ApiConstants.commandeById(id));

    return Map<String, dynamic>.from(response.data);
  }

  /* ============================================================
   * LIST COMMANDES USER
   * GET /commandes (auth:sanctum)
   * ============================================================ */
  Future<List<Map<String, dynamic>>> getUserCommandes() async {
    final response = await _api.get(ApiConstants.commandes);
    final data = response.data;

    if (data is Map && data['commandes'] is List) {
      return List<Map<String, dynamic>>.from(data['commandes']);
    }

    return [];
  }

  /* ============================================================
   * LIST COMMANDES GUEST
   * GET /commandes/guest/{token}
   * ============================================================ */
  Future<List<Map<String, dynamic>>> getGuestCommandes(
    String guestToken,
  ) async {
    final response = await _api.dio.get(
      ApiConstants.commandeByGuest(guestToken),
      options: Options(headers: {'X-Guest-Token': guestToken}),
    );

    final data = response.data;

    if (data is Map && data['commandes'] is List) {
      return List<Map<String, dynamic>>.from(data['commandes']);
    }

    return [];
  }

  Future<Map<String, dynamic>> updateCommande({
    required int commandeId,
    required List<Map<String, dynamic>> items,
    String? commentaireClient,
    String? guestToken,
  }) async {
    final bool isGuest = guestToken != null;

    final response = await _api.dio.post(
      isGuest
          ? ApiConstants.commandeUpdateGuest(commandeId)
          : ApiConstants.commandeUpdate(commandeId),
      data: {'commentaire_client': commentaireClient, 'items': items},
      options: isGuest ? Options(headers: {'X-Guest-Token': guestToken}) : null,
    );

    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> deleteCommande({
    required int commandeId,
    String? guestToken,
  }) async {
    final bool isGuest = guestToken != null;

    final response = await _api.dio.delete(
      isGuest
          ? ApiConstants.commandeDeleteGuest(commandeId)
          : ApiConstants.commandeDelete(commandeId),
      options: isGuest ? Options(headers: {'X-Guest-Token': guestToken}) : null,
    );

    return Map<String, dynamic>.from(response.data);
  }
}
