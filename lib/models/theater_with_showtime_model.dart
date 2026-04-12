class ShowtimeItemModel {
  final String id;
  final String screenId;
  final String date;
  final String time;

  const ShowtimeItemModel({
    required this.id,
    required this.screenId,
    required this.date,
    required this.time,
  });

  factory ShowtimeItemModel.fromJson(Map<String, dynamic> json) =>
      ShowtimeItemModel(
        id:       json['_id']      as String,
        screenId: json['screenId'] as String,
        date:     json['date']     as String,
        time:     json['time']     as String,
      );
}

class TheaterWithShowtimesModel {
  final String id;
  final String name;
  final String location;
  final List<ShowtimeItemModel> showtimes;

  const TheaterWithShowtimesModel({
    required this.id,
    required this.name,
    required this.location,
    required this.showtimes,
  });

  factory TheaterWithShowtimesModel.fromJson(Map<String, dynamic> json) =>
      TheaterWithShowtimesModel(
        id:       json['_id']      as String,
        name:     json['name']     as String,
        location: json['location'] as String,
        showtimes: (json['showtimes'] as List<dynamic>)
            .map((s) => ShowtimeItemModel.fromJson(s as Map<String, dynamic>))
            .toList(),
      );
}