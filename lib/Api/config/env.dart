import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String apiBaseUrl = dotenv.env['API_BASE_URL'] ?? 'http://192.168.1.70:8000/api';
}