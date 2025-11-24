  import 'package:drink_eazy/Api/config/api_constants.dart';
  import 'package:drink_eazy/Api/models/produit.dart';
  import 'package:drink_eazy/Api/services/api_service.dart';

  class ProduitService {
    final ApiService _apiService = ApiService();

    Future<List<Produit>> getAllProduits() async {
      try {
        final response = await _apiService.get("${ApiConstants.baseUrl}/produits");
        if (response.statusCode == 200) {
          final data = response.data['produits'] ?? response.data;
          if (data is List) {
            return data.map((e) => Produit.fromJson(Map<String, dynamic>.from(e))).toList();
          }
        }
        return [];
      } catch (e) {
        print("Erreur getAllProduits: $e");
        return [];
      }
    }

    Future<List<Produit>> getProduitsParCategorie(String nomCategorie) async {
      try {
        final response = await _apiService.get("${ApiConstants.baseUrl}/produits/categorie/$nomCategorie");
        if (response.statusCode == 200) {
          final data = response.data['produits'] ?? response.data;
          if (data is List) {
            return data.map((e) => Produit.fromJson(Map<String, dynamic>.from(e))).toList();
          }
        }
        return [];
      } catch (e) {
        print("Erreur getProduitsParCategorie: $e");
        return [];
      }
    }

    Future<List<Produit>> getProduitsEnPromotion() async {
      try {
        final response = await _apiService.get("${ApiConstants.baseUrl}/produits/promotion");
        if (response.statusCode == 200) {
          final data = response.data['produits'] ?? response.data;
          if (data is List) {
            return data
                .map((e) => Produit.fromJson(Map<String, dynamic>.from(e)))
                .where((p) => p.promotionActive) // filtre pour promotions actives
                .toList();
          }
        }
        return [];
      } catch (e) {
        print("Erreur getProduitsEnPromotion: $e");
        return [];
      }
    }
  }
