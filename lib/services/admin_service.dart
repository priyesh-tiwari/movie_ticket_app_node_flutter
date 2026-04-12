import '../services/api_service.dart';
import '../models/theater_model.dart';
import '../models/showtime_model.dart';

class AdminService {
  // ── Theaters

  static Future<List<TheaterModel>> fetchMyTheaters() async {
    final response = await ApiService.dio.get('/api/theater/my-theaters');
    final List<dynamic> data = response.data['theaters'] as List<dynamic>;
    return data
        .map((t) => TheaterModel.fromJson(t as Map<String, dynamic>))
        .toList();
  }

  static Future<TheaterModel> createTheater(String name, String location) async {
    final response = await ApiService.dio.post(
      '/api/theater/create',
      data: {'name': name, 'location': location},
    );
    return TheaterModel.fromJson(
      response.data['theater'] as Map<String, dynamic>,
    );
  }

  // ── Showtimes 

  static Future<void> addShowtime(Map<String, dynamic> data) async {
    await ApiService.dio.post('/api/showtime/add', data: data);
  }

  static Future<List<ShowtimeModel>> getShowtimes(String theaterId) async {
    final response = await ApiService.dio.get(
      '/api/showtime/theater/$theaterId',
    );
    final List<dynamic> data = response.data['showtimes'] as List<dynamic>;
    return data
        .map((s) => ShowtimeModel.fromJson(s as Map<String, dynamic>))
        .toList();
  }

  static Future<void> editShowtime(
      String showtimeId, Map<String, dynamic> data) async {
    await ApiService.dio.put('/api/showtime/edit/$showtimeId', data: data);
  }

  static Future<void> deleteShowtime(String showtimeId) async {
    await ApiService.dio.delete('/api/showtime/delete/$showtimeId');
  }
}