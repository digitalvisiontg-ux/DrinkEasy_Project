import 'package:drink_eazy/Api/config/env.dart';

class ApiConstants {
  static String get authLogout => "$authBase/logout";
  static String get baseUrl => Env.apiBaseUrl;
  static String get bars => "$baseUrl/bars";
  static String get barsModif => "$baseUrl/bars/modif";

  // ---- Auth endpoints ----
  static String get authBase => "$baseUrl/auth";
  static String get authRegister => "$authBase/register";
  static String get authLogin => "$authBase/login";
  static String get authForgotPassword => "$authBase/forgot-password";
  static String get authResetPassword => "$authBase/reset-password";
  static String get authDeleteAccount => "$authBase/delete-account";
  static String get authVerifyOtp => "$authBase/verify-otp";
  static String get authMe => "$authBase/me";
  static String get baseStorageUrl => "$baseUrl/storage";

  // ---- Produits ----
  static String get produits => "$baseUrl/produits";
  static String get produitsParCategorie => "$baseUrl/produits/categorie";
  static String get produitsEnPromotion => "$baseUrl/produits/promotion";
}