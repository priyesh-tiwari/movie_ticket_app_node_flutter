import 'package:dio/dio.dart';
import 'package:movie_flutter_app/models/theater_with_showtime_model.dart';
import '../constants/app_constants.dart';
import '../models/movie_details_model.dart';
import '../services/api_service.dart';

class MovieDetailsService {
  static final _dio = Dio();

  static Future<MovieDetailsModel> fetchMovieDetails(String imdbID) async {
    final response = await _dio.get(
      ApiConstants.omdbBaseUrl,
      queryParameters: {
        'i':      imdbID,
        'apikey': ApiConstants.omdbApiKey,
      },
    );
    return MovieDetailsModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}

class TheaterListService {
  static Future<List<TheaterWithShowtimesModel>> fetchTheatersForMovie(
      String movieId) async {
    final response =
        await ApiService.dio.get('/api/showtime/movie/$movieId');
    final List<dynamic> data = response.data['theaters'] as List<dynamic>;
    return data
        .map((t) => TheaterWithShowtimesModel.fromJson(
            t as Map<String, dynamic>))
        .toList();
  }
}