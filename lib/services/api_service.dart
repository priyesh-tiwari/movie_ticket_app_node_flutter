import 'package:dio/dio.dart';
import 'storage_service.dart';
import '../constants/app_constants.dart';

class ApiService {
  static bool _isRetrying = false;
  static final Dio _dio = _createDio();

  static Dio get dio => _dio;

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl:        ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        // ── Request — token attach ─────────────────────────────────────────
        onRequest: (options, handler) async {
          final token = await StorageService.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },

        // ── Error — 401 handle + token refresh ─────────────────────────────
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 && !_isRetrying) {
            _isRetrying = true;

            try {
              final refreshToken = await StorageService.getRefreshToken();

              // Plain Dio — no interceptors, infinite loop avoid karne ke liye
              final refreshDio = Dio();
              final refreshResponse = await refreshDio.post(
                '${ApiConstants.baseUrl}/api/auth/refresh-token',
                data: {'refreshToken': refreshToken},
              );

              final newAccessToken =
                  refreshResponse.data['accessToken'] as String;
              await StorageService.setAccessToken(newAccessToken);

              // Original request retry with new token
              final requestOpts = error.requestOptions;
              requestOpts.headers['Authorization'] = 'Bearer $newAccessToken';
              final retryResponse = await dio.fetch(requestOpts);
              handler.resolve(retryResponse);
            } catch (_) {
              await StorageService.clearStorage();
              handler.reject(error);
            } finally {
              _isRetrying = false;
            }
          } else {
            handler.next(error);
          }
        },
      ),
    );

    return dio;
  }
}