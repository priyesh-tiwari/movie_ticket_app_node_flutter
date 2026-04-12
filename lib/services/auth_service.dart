import 'api_service.dart';
import 'storage_service.dart';
import '../models/user_model.dart';

class AuthService {
  static final _dio = ApiService.dio;

  // ── Send OTP (Signup) ──────────────────────────────────────────────────────

  static Future<void> sendOtp({
    required String name,
    required String email,
    required String password,
  }) async {
    await _dio.post('/api/auth/send-otp', data: {
      'name':     name,
      'email':    email,
      'password': password,
    });
  }

  // ── Verify OTP (Signup) ────────────────────────────────────────────────────

  static Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    await _dio.post('/api/auth/verify-otp', data: {
      'email': email,
      'otp':   otp,
    });
  }

  // ── Login ──────────────────────────────────────────────────────────────────

  static Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post('/api/auth/login', data: {
      'email':    email,
      'password': password,
    });

    final data         = response.data as Map<String, dynamic>;
    final accessToken  = data['accessToken']  as String;
    final refreshToken = data['refreshToken'] as String;
    final user         = UserModel.fromJson(data['user'] as Map<String, dynamic>);

    await StorageService.setAccessToken(accessToken);
    await StorageService.setRefreshToken(refreshToken);
    await StorageService.setUser(
      name:  user.name,
      email: user.email,
      role:  user.role,
    );

    return user;
  }

  // ── Logout ─────────────────────────────────────────────────────────────────

  static Future<void> logout() async {
    final refreshToken = await StorageService.getRefreshToken();
    await _dio.post('/api/auth/logout', data: {'refreshToken': refreshToken});
    await StorageService.clearStorage();
  }

  // ── Forgot Password — Send OTP ─────────────────────────────────────────────

  static Future<void> forgotPassword({required String email}) async {
    await _dio.post('/api/auth/forgot-password', data: {'email': email});
  }

  // ── Forgot Password — Reset ────────────────────────────────────────────────

  static Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    await _dio.post('/api/auth/reset-password', data: {
      'email':       email,
      'otp':         otp,
      'newPassword': newPassword,
    });
  }

  // ── Fetch Profile ──────────────────────────────────────────────────────────

  static Future<UserModel> fetchProfile() async {
    final response = await _dio.get('/api/auth/profile');
    return UserModel.fromJson(
      (response.data as Map<String, dynamic>)['user'] as Map<String, dynamic>,
    );
  }
}