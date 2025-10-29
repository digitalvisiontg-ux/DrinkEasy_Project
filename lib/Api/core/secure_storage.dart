import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final _storage = FlutterSecureStorage();
  static const _keyToken = 'auth_token';
  static const _keyUser = 'auth_user';

  static Future<void> writeToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  static Future<String?> readToken() async {
    return await _storage.read(key: _keyToken);
  }

  static Future<void> writeUser(Map<String, dynamic> user) async {
    try {
      final json = jsonEncode(user);
      await _storage.write(key: _keyUser, value: json);
    } catch (_) {}
  }

  static Future<Map<String, dynamic>?> readUser() async {
    try {
      final json = await _storage.read(key: _keyUser);
      if (json == null) return null;
      final Map<String, dynamic> map = jsonDecode(json);
      return map;
    } catch (_) {
      return null;
    }
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  static Future<void> deleteUser() async {
    await _storage.delete(key: _keyUser);
  }
}