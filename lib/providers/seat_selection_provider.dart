
import 'package:flutter_riverpod/legacy.dart';
import '../services/seat_service.dart';

const int kTotalSeats = 20;
const double kSeatPrice = 10.0;

// ─── State 

class SeatSelectionState {
  final List<String> bookedSeats;
  final List<String> lockedSeats;
  final List<String> selectedSeats;
  final bool isLoading;
  final bool isReserving;
  final String? error;

  const SeatSelectionState({
    this.bookedSeats   = const [],
    this.lockedSeats   = const [],
    this.selectedSeats = const [],
    this.isLoading     = true,
    this.isReserving   = false,
    this.error,
  });

  double get totalAmount => selectedSeats.length * kSeatPrice;

  SeatSelectionState copyWith({
    List<String>? bookedSeats,
    List<String>? lockedSeats,
    List<String>? selectedSeats,
    bool? isLoading,
    bool? isReserving,
    String? error,
    bool clearError = false,
  }) =>
      SeatSelectionState(
        bookedSeats:   bookedSeats   ?? this.bookedSeats,
        lockedSeats:   lockedSeats   ?? this.lockedSeats,
        selectedSeats: selectedSeats ?? this.selectedSeats,
        isLoading:     isLoading     ?? this.isLoading,
        isReserving:   isReserving   ?? this.isReserving,
        error:         clearError ? null : error ?? this.error,
      );
}

// ─── Notifier 

class SeatSelectionNotifier extends StateNotifier<SeatSelectionState> {
  final String showtimeId;

  SeatSelectionNotifier(this.showtimeId) : super(const SeatSelectionState()) {
    fetchSeats();
  }

  Future<void> fetchSeats() async {
    state = state.copyWith(isLoading: true);
    try {
      final showtime = await SeatService.fetchShowtimeDetails(showtimeId);
      state = state.copyWith(
        bookedSeats: List<String>.from(showtime['selectedSeats'] ?? []),
        lockedSeats: List<String>.from(showtime['lockedSeats']   ?? []),
        isLoading:   false,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error:     'Failed to load seats',
      );
    }
  }

  // Toggle seat — same logic as RN toggleSeat
  void toggleSeat(String seat) {
    if (state.bookedSeats.contains(seat) ||
        state.lockedSeats.contains(seat)) return;

    final current = List<String>.from(state.selectedSeats);
    if (current.contains(seat)) {
      current.remove(seat);
    } else {
      current.add(seat);
    }
    state = state.copyWith(selectedSeats: current);
  }

  Future<bool> reserveSeats() async {
    if (state.selectedSeats.isEmpty) return false;
    state = state.copyWith(isReserving: true, clearError: true);
    try {
      await SeatService.reserveSeats(showtimeId, state.selectedSeats);
      state = state.copyWith(isReserving: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isReserving: false,
        error:       'Failed to reserve seats',
      );
      return false;
    }
  }

  // Called on screen dispose — same as RN useEffect cleanup
  Future<void> releaseSeats() async {
    if (state.selectedSeats.isEmpty) return;
    try {
      await SeatService.releaseSeats(showtimeId, state.selectedSeats);
    } catch (_) {
      // silently fail
    }
  }
}

// ─── Provider

final seatSelectionProvider = StateNotifierProvider.family<
    SeatSelectionNotifier, SeatSelectionState, String>(
  (ref, showtimeId) => SeatSelectionNotifier(showtimeId),
);