import 'package:drink_eazy/Api/config/env.dart';

class ApiConstants {
  // ---- Base ----
  static String get baseUrl => Env.apiBaseUrl;
  // On enlève '/api' de la baseUrl pour que le chemin vers le storage pointe au bon endroit
  // au lieu de pointer vers http://.../api/storage/
  static String get baseStorageUrl => baseUrl.replaceAll(RegExp(r'/api$'), '') + "/storage";

  // ---- Auth ----
  static String get authBase => "$baseUrl/auth";
  static String get authRegister => "$authBase/register";
  static String get authLogin => "$authBase/login";
  static String get authLogout => "$authBase/logout";
  static String get authForgotPassword => "$authBase/forgot-password";
  static String get authResetPassword => "$authBase/reset-password";
  static String get authDeleteContact => "$authBase/delete-contact";
  static String get authDeleteAccount => "$authBase/delete-account";
  static String get authVerifyOtp => "$authBase/verify-otp";
  static String get authMe => "$authBase/me";
  static String get profile => "$authBase/profile";

  // ---- Bars ----
  static String get bars => "$baseUrl/bars";
  static String get barsModif => "$baseUrl/bars/modif";

  // ---- Tables (scan) ----
  static String get verifyTableByQr => "$baseUrl/tables/verify/qr";
  static String get verifyTableManual => "$baseUrl/tables/verify/manual";

  // ---- Produits ----
  static String get produits => "$baseUrl/produits";
  static String get produitsParCategorie => "$baseUrl/produits/categorie";
  static String get produitsEnPromotion => "$baseUrl/produits/promotion";

  // ---- Commandes USER ----
  static String get commandes => "$baseUrl/commandes";
  static String commandeById(int id) => "$baseUrl/commandes/$id";

  // ---- Commandes GUEST ----
  static String get commandesGuest => "$baseUrl/commandes/guest";
  static String commandeByGuest(String token) =>
      "$baseUrl/commandes/guest/$token";
  static String commandeUpdateGuest(int id) => "$baseUrl/commandes/$id/guest";
  static String commandeDeleteGuest(int id) => "$baseUrl/commandes/$id/guest";

  static String commandeUpdate(int id) => "$baseUrl/commandes/$id";
  static String commandeDelete(int id) => "$baseUrl/commandes/$id";
}
