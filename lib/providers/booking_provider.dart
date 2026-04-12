import 'package:flutter_riverpod/legacy.dart';
import '../services/receipt_service.dart';
import '../models/booking_model.dart';

// ─── State ────────────────────────────────────────────────────────────────────

class BookingState {
  final List<BookingModel> bookings;
  final bool isLoading;
  final bool isRefreshing;
  final String? error;

  const BookingState({
    this.bookings     = const [],
    this.isLoading    = true,
    this.isRefreshing = false,
    this.error,
  });

  BookingState copyWith({
    List<BookingModel>? bookings,
    bool? isLoading,
    bool? isRefreshing,
    String? error,
    bool clearError = false,
  }) =>
      BookingState(
        bookings:     bookings     ?? this.bookings,
        isLoading:    isLoading    ?? this.isLoading,
        isRefreshing: isRefreshing ?? this.isRefreshing,
        error:        clearError ? null : error ?? this.error,
      );
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class BookingNotifier extends StateNotifier<BookingState> {
  final ReceiptService _receiptService = ReceiptService();

  BookingNotifier() : super(const BookingState()) {
    fetchBookings(); // same as RN: useEffect(() => { fetchBookings() }, [])
  }

  Future<void> fetchBookings() async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      final data = await _receiptService.fetchMyReceipts();
      state = state.copyWith(bookings: data, isLoading: false);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load bookings',
      );
    }
  }

  // Same as RN: onRefresh — pull to refresh
  Future<void> onRefresh() async {
    try {
      state = state.copyWith(isRefreshing: true, clearError: true);
      final data = await _receiptService.fetchMyReceipts();
      state = state.copyWith(bookings: data, isRefreshing: false);
    } catch (_) {
      state = state.copyWith(
        isRefreshing: false,
        error: 'Failed to load bookings',
      );
    }
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final bookingProvider =
    StateNotifierProvider<BookingNotifier, BookingState>(
  (ref) => BookingNotifier(),
);