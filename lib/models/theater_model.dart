class ScreenModel {
  final String id;
  final int screenNumber;

  const ScreenModel({required this.id, required this.screenNumber});

  factory ScreenModel.fromJson(Map<String, dynamic> json) => ScreenModel(
        id:           json['_id'] as String,
        screenNumber: json['screenNumber'] as int,
      );

  Map<String, dynamic> toJson() => {
        '_id':          id,
        'screenNumber': screenNumber,
      };
}

class TheaterModel {
  final String id;
  final String name;
  final String location;
  final List<ScreenModel> screens;

  const TheaterModel({
    required this.id,
    required this.name,
    required this.location,
    required this.screens,
  });

  factory TheaterModel.fromJson(Map<String, dynamic> json) => TheaterModel(
        id:       json['_id'] as String,
        name:     json['name'] as String,
        location: json['location'] as String,
        screens:  (json['screens'] as List<dynamic>)
            .map((s) => ScreenModel.fromJson(s as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        '_id':      id,
        'name':     name,
        'location': location,
        'screens':  screens.map((s) => s.toJson()).toList(),
      };
}