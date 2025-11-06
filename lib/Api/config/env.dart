import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String apiBaseUrl =
      dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:8000/api';
}
