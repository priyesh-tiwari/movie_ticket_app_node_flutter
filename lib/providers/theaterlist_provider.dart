import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:movie_flutter_app/models/theater_with_showtime_model.dart';
import 'package:movie_flutter_app/services/moviedetails_theaterlist_service.dart';

// ─── State ────────────────────────────────────────────────────────────────────

class TheaterListState {
  final List<TheaterWithShowtimesModel> theaters;         // full list
  final List<TheaterWithShowtimesModel> filteredTheaters; // after location search
  final String searchLocation;
  final bool isLoading;
  final String? error;

  const TheaterListState({
    this.theaters         = const [],
    this.filteredTheaters = const [],
    this.searchLocation   = '',
    this.isLoading        = true,
    this.error,
  });

  TheaterListState copyWith({
    List<TheaterWithShowtimesModel>? theaters,
    List<TheaterWithShowtimesModel>? filteredTheaters,
    String? searchLocation,
    bool? isLoading,
    String? error,
  }) =>
      TheaterListState(
        theaters:         theaters         ?? this.theaters,
        filteredTheaters: filteredTheaters ?? this.filteredTheaters,
        searchLocation:   searchLocation   ?? this.searchLocation,
        isLoading:        isLoading        ?? this.isLoading,
        error:            error,
      );
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class TheaterListNotifier extends StateNotifier<TheaterListState> {
  final String movieId;

  TheaterListNotifier(this.movieId) : super(const TheaterListState()) {
    fetchTheaters();
  }

  Future<void> fetchTheaters() async {
    state = state.copyWith(isLoading: true);
    try {
      final data = await TheaterListService.fetchTheatersForMovie(movieId);
      state = state.copyWith(
        theaters:         data,
        filteredTheaters: data,
        isLoading:        false,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load theaters',
      );
    }
  }

  // Matches RN useTheaterList filter logic exactly
  void updateSearch(String query) {
    final filtered = query.trim().isEmpty
        ? state.theaters
        : state.theaters
            .where((t) =>
                t!.location.toLowerCase().contains(query.toLowerCase()))
            .toList();

    state = state.copyWith(
      searchLocation:   query,
      filteredTheaters: filtered,
    );
  }
}

// ─── Provider (family — one instance per movieId) ────────────────────────────

final theaterListProvider = StateNotifierProvider.family<
    TheaterListNotifier, TheaterListState, String>(
  (ref, movieId) => TheaterListNotifier(movieId),
);