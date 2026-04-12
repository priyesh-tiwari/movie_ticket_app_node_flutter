import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();

  static const _accessTokenKey  = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';
  static const _userNameKey     = 'userName';
  static const _userEmailKey    = 'userEmail';
  static const _userRoleKey     = 'userRole';

  // ── Access Token ────────────────────────────────────────────────────────────

  static Future<void> setAccessToken(String token) =>
      _storage.write(key: _accessTokenKey, value: token);

  static Future<String?> getAccessToken() =>
      _storage.read(key: _accessTokenKey);

  // ── Refresh Token ───────────────────────────────────────────────────────────

  static Future<void> setRefreshToken(String token) =>
      _storage.write(key: _refreshTokenKey, value: token);

  static Future<String?> getRefreshToken() =>
      _storage.read(key: _refreshTokenKey);

  // ── User ────────────────────────────────────────────────────────────────────

  static Future<void> setUser({
    required String name,
    required String email,
    required String role,
  }) async {
    await Future.wait([
      _storage.write(key: _userNameKey,  value: name),
      _storage.write(key: _userEmailKey, value: email),
      _storage.write(key: _userRoleKey,  value: role),
    ]);
  }

  static Future<Map<String, String?>> getUser() async {
    final results = await Future.wait([
      _storage.read(key: _userNameKey),
      _storage.read(key: _userEmailKey),
      _storage.read(key: _userRoleKey),
    ]);
    return {
      'name':  results[0],
      'email': results[1],
      'role':  results[2],
    };
  }

  // ── Clear All ────────────────────────────────────────────────────────────────

  static Future<void> clearStorage() => _storage.deleteAll();
}