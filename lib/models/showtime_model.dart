class ShowtimeModel {
  final String id;
  final String movieId;
  final String movieTitle;
  final String? moviePoster;
  final String theaterId;
  final String screenId;
  final String time;
  final String date;
  final String startTime;

  const ShowtimeModel({
    required this.id,
    required this.movieId,
    required this.movieTitle,
    this.moviePoster,
    required this.theaterId,
    required this.screenId,
    required this.time,
    required this.date,
    required this.startTime,
  });

  factory ShowtimeModel.fromJson(Map<String, dynamic> json) => ShowtimeModel(
    id:          json['_id'] as String,
    movieId:     json['movieId'] as String,
    movieTitle:  json['movieTitle'] as String,
    moviePoster: json['moviePoster'] as String?,
    theaterId:   json['theaterId'] as String,
    screenId:    json['screenId'] as String,
    time:        json['time'] as String,
    date:        json['date'] as String,
    startTime:   json['startTime'] as String,
  );

  Map<String, dynamic> toJson() => {
    '_id':         id,
    'movieId':     movieId,
    'movieTitle':  movieTitle,
    'moviePoster': moviePoster,
    'theaterId':   theaterId,
    'screenId':    screenId,
    'time':        time,
    'date':        date,
    'startTime':   startTime,
  };
}
