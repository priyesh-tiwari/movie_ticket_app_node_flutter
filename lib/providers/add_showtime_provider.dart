
import 'package:flutter_riverpod/legacy.dart';
import '../models/theater_model.dart';
import '../models/movie_model.dart';
import '../services/admin_service.dart';

// ─── State ────────────────────────────────────────────────────────────────────

class AddShowtimeState {
  final MovieModel? selectedMovie;
  final String? selectedScreenId;
  final String? selectedDate;
  final String? selectedTime;
  final bool isLoading;
  final String? error;

  const AddShowtimeState({
    this.selectedMovie,
    this.selectedScreenId,
    this.selectedDate,
    this.selectedTime,
    this.isLoading = false,
    this.error,
  });

  AddShowtimeState copyWith({
    MovieModel? selectedMovie,
    bool clearMovie = false,
    String? selectedScreenId,
    String? selectedDate,
    String? selectedTime,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) =>
      AddShowtimeState(
        selectedMovie:    clearMovie   ? null  : selectedMovie    ?? this.selectedMovie,
        selectedScreenId: selectedScreenId ?? this.selectedScreenId,
        selectedDate:     selectedDate     ?? this.selectedDate,
        selectedTime:     selectedTime     ?? this.selectedTime,
        isLoading:        isLoading        ?? this.isLoading,
        error:            clearError   ? null  : error            ?? this.error,
      );

  static const List<String> predefinedTimes = [
    '09:00 AM',
    '12:00 PM',
    '03:00 PM',
    '06:00 PM',
    '09:00 PM',
  ];
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class AddShowtimeNotifier extends StateNotifier<AddShowtimeState> {
  final TheaterModel theater;

  AddShowtimeNotifier(this.theater) : super(const AddShowtimeState());

  void selectMovie(MovieModel movie) =>
      state = state.copyWith(selectedMovie: movie, clearError: true);

  void clearMovie() =>
      state = state.copyWith(clearMovie: true);

  void selectScreen(String screenId) =>
      state = state.copyWith(selectedScreenId: screenId);

  void selectDate(String date) =>
      state = state.copyWith(selectedDate: date);

  void selectTime(String time) =>
      state = state.copyWith(selectedTime: time);

  // Matches RN parseStartTime logic exactly
  String _parseStartTime(String date, String time) {
    final parts       = time.split(' ');
    final modifier    = parts[1]; // AM / PM
    final timeParts   = parts[0].split(':');
    int hours         = int.parse(timeParts[0]);
    final int minutes = int.parse(timeParts[1]);

    if (modifier == 'PM' && hours != 12) hours += 12;
    if (modifier == 'AM' && hours == 12) hours = 0;

    final dateObj = DateTime.parse(date).copyWith(
      hour:   hours,
      minute: minutes,
      second: 0,
    );
    return dateObj.toUtc().toIso8601String();
  }

  Future<bool> addShowtime() async {
    final s = state;
    if (s.selectedMovie == null ||
        s.selectedScreenId == null ||
        s.selectedDate == null ||
        s.selectedTime == null) {
      state = state.copyWith(error: 'Please fill all fields');
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await AdminService.addShowtime({
        'movieId':     s.selectedMovie!.imdbID,
        'movieTitle':  s.selectedMovie!.title,
        'moviePoster': s.selectedMovie!.poster,
        'theaterId':   theater.id,
        'screenId':    s.selectedScreenId,
        'time':        s.selectedTime,
        'startTime':   _parseStartTime(s.selectedDate!, s.selectedTime!),
        'date':        s.selectedDate,
      });

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to add showtime',
      );
      return false;
    }
  }
}

// ─── Provider (family — one instance per theater) ─────────────────────────────

final addShowtimeProvider = StateNotifierProvider.family<
    AddShowtimeNotifier, AddShowtimeState, TheaterModel>(
  (ref, theater) => AddShowtimeNotifier(theater),
);