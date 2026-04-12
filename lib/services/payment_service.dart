import 'package:dio/dio.dart';
import 'api_service.dart';

class PaymentService{
  final Dio _dio = ApiService.dio;


  Future<String> createPaymentIntent({
    required double amount,
    required String showtimeId,
    required List<dynamic> selectedSeats,
    required String theaterId,
    required String screenId,
    required String movieId,
  })async{
    final response = await _dio.post('/api/payment/create-payment-intent', data: {
      'amount': (amount * 100).round(),
      'showtimeId': showtimeId,
      'selectedSeats': selectedSeats,
      'theaterId': theaterId,
      'screenId': screenId,
      'movieId': movieId,
    });

    return response.data['clientSecret'] as String;

  }
}