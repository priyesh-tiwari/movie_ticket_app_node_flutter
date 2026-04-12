import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/movie_model.dart';
import '../services/movie_service.dart';

// ─── Home State 

class HomeState {
  final List<MovieModel> trending;
  final List<MovieModel> topRated;
  final List<MovieModel> tv;
  final bool   isLoading;
  final String? error;

  const HomeState({
    this.trending  = const [],
    this.topRated  = const [],
    this.tv        = const [],
    this.isLoading = true,
    this.error,
  });

  HomeState copyWith({
    List<MovieModel>? trending,
    List<MovieModel>? topRated,
    List<MovieModel>? tv,
    bool?    isLoading,
    String?  error,
  }) => HomeState(
    trending:  trending  ?? this.trending,
    topRated:  topRated  ?? this.topRated,
    tv:        tv        ?? this.tv,
    isLoading: isLoading ?? this.isLoading,
    error:     error,
  );
}

// ─── Home Notifier 

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState()) {
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    state = state.copyWith(isLoading: true);
    try {
      final data = await MovieService.loadMovies();
      state = state.copyWith(
        isLoading: false,
        trending:  data['trending']!,
        topRated:  data['topRated']!,
        tv:        data['tv']!,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Failed to load movies');
    }
  }
}

final homeProvider =
    StateNotifierProvider<HomeNotifier, HomeState>((ref) => HomeNotifier());

// ─── Search State 

class SearchState {
  final String           query;
  final List<MovieModel> results;
  final bool             isLoading;

  const SearchState({
    this.query     = '',
    this.results   = const [],
    this.isLoading = false,
  });

  SearchState copyWith({
    String?           query,
    List<MovieModel>? results,
    bool?             isLoading,
  }) => SearchState(
    query:     query     ?? this.query,
    results:   results   ?? this.results,
    isLoading: isLoading ?? this.isLoading,
  );
}

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier() : super(const SearchState());

  Future<void> search(String query) async {
    state = state.copyWith(query: query);

    if (query.trim().isEmpty) {
      state = state.copyWith(results: []);
      return;
    }

    state = state.copyWith(isLoading: true);
    try {
      final movies = await MovieService.fetchMovies(query);
      state = state.copyWith(isLoading: false, results: movies);
    } catch (_) {
      state = state.copyWith(isLoading: false, results: []);
    }
  }
}

final searchProvider =
    StateNotifierProvider.autoDispose<SearchNotifier, SearchState>(
        (ref) => SearchNotifier());

// ─── Trailer State 

// Map of imdbID -> videoKey (null means no trailer found)
final trailerProvider = FutureProvider.family<String?, String>((ref, imdbID) {
  return MovieService.fetchTrailer(imdbID);
});