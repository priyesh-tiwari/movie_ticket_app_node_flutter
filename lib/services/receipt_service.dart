import 'package:dio/dio.dart';
import 'api_service.dart';
import '../models/booking_model.dart';

class ReceiptService {
  final Dio _dio = ApiService.dio;

  Future<List<BookingModel>> fetchMyReceipts() async {
    final response = await _dio.get('/api/receipt/my-receipts');
    print('RECEIPT RESPONSE: ${response.data}');
    final List data = response.data['receipts'];
    return data.map((e) => BookingModel.fromJson(e)).toList();
  }
}