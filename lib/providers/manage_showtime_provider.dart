
import 'package:flutter_riverpod/legacy.dart';
import '../models/showtime_model.dart';
import '../services/admin_service.dart';


class ManageShowtimesState {
  final List<ShowtimeModel> showtimes;
  final bool isLoading;
  final String? error;

  const ManageShowtimesState({
    this.showtimes = const [],
    this.isLoading = true,
    this.error,
  });

  ManageShowtimesState copyWith({
    List<ShowtimeModel>? showtimes,
    bool? isLoading,
    String? error,
  }) =>
      ManageShowtimesState(
        showtimes: showtimes ?? this.showtimes,
        isLoading: isLoading ?? this.isLoading,
        error:     error,
      );
}


class ManageShowtimesNotifier extends StateNotifier<ManageShowtimesState> {
  final String theaterId;

  ManageShowtimesNotifier(this.theaterId) : super(const ManageShowtimesState()) {
    fetchShowtimes();
  }

  Future<void> fetchShowtimes() async {
    state = state.copyWith(isLoading: true);
    try {
      final data = await AdminService.getShowtimes(theaterId);
      state = state.copyWith(showtimes: data, isLoading: false);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load showtimes',
      );
    }
  }

  Future<bool> editShowtime(String showtimeId, Map<String, dynamic> data) async {
    try {
      await AdminService.editShowtime(showtimeId, data);
      await fetchShowtimes(); // refresh list like the RN hook
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteShowtime(String showtimeId) async {
    try {
      await AdminService.deleteShowtime(showtimeId);
      state = state.copyWith(
        showtimes: state.showtimes.where((s) => s.id != showtimeId).toList(),
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}


final manageShowtimesProvider = StateNotifierProvider.family<
    ManageShowtimesNotifier, ManageShowtimesState, String>(
  (ref, theaterId) => ManageShowtimesNotifier(theaterId),
);