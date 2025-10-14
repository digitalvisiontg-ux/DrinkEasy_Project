import 'package:drink_eazy/Api/config/env.dart';

class ApiConstants {
  static String get baseUrl => Env.apiBaseUrl;
  static String get bars => "$baseUrl/bars";
  static String get barsModif => "$baseUrl/bars/modif";
}