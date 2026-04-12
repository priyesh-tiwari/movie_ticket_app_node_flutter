
import 'package:flutter_riverpod/legacy.dart';
import 'package:movie_flutter_app/services/moviedetails_theaterlist_service.dart';
import '../models/movie_details_model.dart';

// ─── State ────────────────────────────────────────────────────────────────────

class MovieDetailsState {
  final MovieDetailsModel? movie;
  final bool isLoading;
  final String? error;

  const MovieDetailsState({
    this.movie,
    this.isLoading = true,
    this.error,
  });

  MovieDetailsState copyWith({
    MovieDetailsModel? movie,
    bool? isLoading,
    String? error,
  }) =>
      MovieDetailsState(
        movie:     movie     ?? this.movie,
        isLoading: isLoading ?? this.isLoading,
        error:     error,
      );
}

// ─── Notifier 

class MovieDetailsNotifier extends StateNotifier<MovieDetailsState> {
  final String imdbID;

  MovieDetailsNotifier(this.imdbID) : super(const MovieDetailsState()) {
    fetchMovieDetails();
  }

  Future<void> fetchMovieDetails() async {
    state = state.copyWith(isLoading: true);
    try {
      final movie = await MovieDetailsService.fetchMovieDetails(imdbID);
      state = state.copyWith(movie: movie, isLoading: false);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load movie details',
      );
    }
  }
}

// ─── Provider (family — one instance per imdbID) ──────────────────────────────

final movieDetailsProvider = StateNotifierProvider.family<
    MovieDetailsNotifier, MovieDetailsState, String>(
  (ref, imdbID) => MovieDetailsNotifier(imdbID),
);