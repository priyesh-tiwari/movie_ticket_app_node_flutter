class MovieDetailsModel {
  final String imdbID;
  final String title;
  final String poster;
  final String imdbRating;
  final String released;
  final String plot;
  final String genre;
  final String director;
  final String actors;
  final String runtime;

  const MovieDetailsModel({
    required this.imdbID,
    required this.title,
    required this.poster,
    required this.imdbRating,
    required this.released,
    required this.plot,
    required this.genre,
    required this.director,
    required this.actors,
    required this.runtime,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) =>
      MovieDetailsModel(
        imdbID:     json['imdbID']     as String,
        title:      json['Title']      as String,
        poster:     json['Poster']     as String,
        imdbRating: json['imdbRating'] as String,
        released:   json['Released']   as String,
        plot:       json['Plot']       as String,
        genre:      json['Genre']      as String,
        director:   json['Director']   as String,
        actors:     json['Actors']     as String,
        runtime:    json['Runtime']    as String,
      );
}