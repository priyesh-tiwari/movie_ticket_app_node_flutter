class TheaterInfo {
  final String id;
  final String name;
  final String location;

  const TheaterInfo({
    required this.id,
    required this.name,
    required this.location,
  });

  factory TheaterInfo.fromJson(Map<String, dynamic> json) => TheaterInfo(
        id:       json['_id'] as String,
        name:     json['name'] as String,
        location: json['location'] as String,
      );
}

class ShowtimeInfo {
  final String id;
  final String time;
  final String? startTime;

  const ShowtimeInfo({
    required this.id,
    required this.time,
    this.startTime,
  });

  factory ShowtimeInfo.fromJson(Map<String, dynamic> json) => ShowtimeInfo(
        id:        json['_id'] as String,
        time:      json['time'] as String,
        startTime: json['startTime'] as String?,
      );
}

class BookingModel {
  final String id;
  final String movieId;
  final TheaterInfo theaterId;
  final ShowtimeInfo? showtimeId;   // ← nullable now
  final List<String> selectedSeats;
  final double totalAmount;
  final String paymentStatus;
  final DateTime createdAt;

  const BookingModel({
    required this.id,
    required this.movieId,
    required this.theaterId,
    this.showtimeId,                // ← optional now
    required this.selectedSeats,
    required this.totalAmount,
    required this.paymentStatus,
    required this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        id:            json['_id'] as String,
        movieId:       json['movieId'] as String,
        theaterId:     TheaterInfo.fromJson(json['theaterId']),
        showtimeId:    json['showtimeId'] != null        // ← null check
                           ? ShowtimeInfo.fromJson(json['showtimeId'])
                           : null,
        selectedSeats: List<String>.from(json['selectedSeats']),
        totalAmount:   (json['totalAmount'] as num).toDouble(),
        paymentStatus: json['paymentStatus'] as String,
        createdAt:     DateTime.parse(json['createdAt'] as String),
      );
}