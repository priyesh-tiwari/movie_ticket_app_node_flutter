class MovieModel {
  final String imdbID;
  final String title;
  final String year;
  final String poster;

  const MovieModel({
    required this.imdbID,
    required this.title,
    required this.year,
    required this.poster,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        imdbID: json['imdbID'] as String,
        title:  json['Title']  as String,
        year:   json['Year']   as String,
        poster: json['Poster'] as String,
      );
}