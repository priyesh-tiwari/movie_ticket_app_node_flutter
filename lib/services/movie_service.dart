import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../models/movie_model.dart';

class MovieService {
  static final _dio = Dio();

  // ── Search movies (OMDB) 
  static Future<List<MovieModel>> fetchMovies(String query) async {
    final response = await _dio.get(ApiConstants.omdbBaseUrl, queryParameters: {
      's':      query,
      'apikey': ApiConstants.omdbApiKey,
    });

    final data = response.data as Map<String, dynamic>;
    if (data['Response'] == 'True') {
      return (data['Search'] as List)
          .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  // ── Load trending/topRated/tv with cache 
  static Map<String, List<MovieModel>>? _cache;

  static Future<Map<String, List<MovieModel>>> loadMovies() async {
    if (_cache != null) return _cache!;

    final results = await Future.wait([
      fetchMovies('star'),
      fetchMovies('batman'),
      fetchMovies('marvel'),
    ]);

    _cache = {
      'trending': results[0],
      'topRated': results[1],
      'tv':       results[2],
    };

    return _cache!;
  }

  // ── Fetch trailer key (TMDB) 
  static Future<String?> fetchTrailer(String imdbID) async {
    try {
      // Step 1 — find TMDB movie id from imdbID
      final findRes = await _dio.get(
        '${ApiConstants.tmdbBaseUrl}/find/$imdbID',
        queryParameters: {
          'api_key':         ApiConstants.tmdbApiKey,
          'external_source': 'imdb_id',
        },
      );

      final movieId =
          (findRes.data['movie_results'] as List).firstOrNull?['id'];
      if (movieId == null) return null;

      // Step 2 — fetch videos for that movie
      final videoRes = await _dio.get(
        '${ApiConstants.tmdbBaseUrl}/movie/$movieId/videos',
        queryParameters: {'api_key': ApiConstants.tmdbApiKey},
      );

      final trailer = (videoRes.data['results'] as List).firstWhere(
        (v) => v['type'] == 'Trailer' && v['site'] == 'YouTube',
        orElse: () => null,
      );

      return trailer?['key'] as String?;
    } catch (_) {
      return null;
    }
  }
}