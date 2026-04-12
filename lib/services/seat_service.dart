import '../services/api_service.dart';

class SeatService {
  static Future<Map<String, dynamic>> fetchShowtimeDetails(
    String showtimeId,
  ) async {
    final response = await ApiService.dio.get('/api/showtime/$showtimeId');

    return response.data['showtime'] as Map<String, dynamic>;
  }

  static Future<void> reserveSeats(
    String showtimeId,
    List<String> seats,
  ) async {
    await ApiService.dio.post(
      '/api/showtime/reserve-seats',
      data: {'showtimeId': showtimeId, 'seats': seats},
    );
  }

  static Future<void> releaseSeats(
      String showtimeId, List<String> seats) async {
    await ApiService.dio.post('/api/showtime/release-seats', data: {
      'showtimeId': showtimeId,
      'seats':      seats,
    });
  }
  
}
