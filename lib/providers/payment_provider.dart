import 'package:flutter_riverpod/legacy.dart';
import '../services/payment_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentState {
  final bool isLoading;
  final String? error;

  const PaymentState({
    this.isLoading=false,
    this.error
  });

  PaymentState copyWith({
    bool? isLoading,
    String? error,
    bool clearError=false,
  })=>PaymentState(
    isLoading: isLoading ?? this.isLoading,
        error: clearError ? null : error ?? this.error,
  );
}

class PaymentNotifier extends StateNotifier<PaymentState> {
  final PaymentService _paymentService = PaymentService();

  PaymentNotifier() : super(const PaymentState());

  Future<bool> makePayment({
    required double amount,
    required String showtimeId,
    required List<dynamic> selectedSeats,
    required String theaterId,
    required String screenId,
    required String movieId,
  }) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      // Step 1 — Backend se PaymentIntent create karo
      final clientSecret = await _paymentService.createPaymentIntent(
        amount: amount,
        showtimeId: showtimeId,
        selectedSeats: selectedSeats,
        theaterId: theaterId,
        screenId: screenId,
        movieId: movieId,
      );

      // Step 2 — Payment Sheet initialize karo
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'CineMax 🎬',
        ),
      );

      // Step 3 — Payment Sheet dikhao
      await Stripe.instance.presentPaymentSheet();

      return true;

    } on StripeException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.error.message ?? 'Payment failed',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Payment failed',
      );
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final paymentProvider =
    StateNotifierProvider<PaymentNotifier, PaymentState>(
  (ref) => PaymentNotifier(),
);
