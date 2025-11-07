
import 'package:drink_eazy/Api/models/produit.dart';
import 'package:drink_eazy/Api/services/produit_service.dart';
import 'package:flutter/material.dart';

class ProduitProvider with ChangeNotifier {
  final ProduitService _produitService = ProduitService();

  List<Produit> _produits = [];
  List<Produit> get produits => _produits;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  /// 🔹 Charger tous les produits
  Future<void> fetchProduits() async {
    _setLoading(true);
    try {
      final result = await _produitService.getAllProduits();
      _produits = result;
    } catch (e) {
      _error = "Erreur lors du chargement des produits";
      print("Erreur fetchProduits: $e");
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Charger les produits par catégorie
  Future<void> fetchProduitsParCategorie(String nomCategorie) async {
    _setLoading(true);
    try {
      final result = await _produitService.getProduitsParCategorie(nomCategorie);
      _produits = result;
    } catch (e) {
      _error = "Erreur produits catégorie";
      print("Erreur fetchProduitsParCategorie: $e");
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Charger les produits en promotion
  Future<void> fetchProduitsEnPromotion() async {
    _setLoading(true);
    try {
      final result = await _produitService.getProduitsEnPromotion();
      _produits = result;
    } catch (e) {
      _error = "Erreur produits promotion";
      print("Erreur fetchProduitsEnPromotion: $e");
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
