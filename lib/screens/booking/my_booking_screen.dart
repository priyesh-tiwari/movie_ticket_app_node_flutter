import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_flutter_app/screens/receipt/receipt_screen.dart';
import 'package:movie_flutter_app/widgets/my_booking_card.dart';
import '../../constants/app_constants.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking_model.dart';

class MyBookingScreen extends ConsumerStatefulWidget {
  const MyBookingScreen({super.key});

  @override
  ConsumerState<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends ConsumerState<MyBookingScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookingProvider.notifier).fetchBookings();
    });
  }

  void _handleBookingPress(BuildContext context, BookingModel booking) {
    if (booking.showtimeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Showtime for this booking was removed by admin.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReceiptScreen(
          movieId:       booking.movieId,
          theaterId:     booking.theaterId.name,
          showtimeId:    booking.showtimeId!.time,
          selectedSeats: booking.selectedSeats,
          totalAmount:   booking.totalAmount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical:   AppSpacing.md,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'My Bookings 🎟️',
                  style: TextStyle(
                    fontSize:   AppFontSize.xl,
                    fontWeight: FontWeight.bold,
                    color:      AppColors.text,
                  ),
                ),
              ),
            ),

            Divider(color: AppColors.card, height: 3),

            if (state.isLoading)
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )

            else if (state.error != null)
              Expanded(
                child: Center(
                  child: Text(
                    state.error!,
                    style: TextStyle(
                      color:    AppColors.error,
                      fontSize: AppFontSize.sm,
                    ),
                  ),
                ),
              )

            else
              Expanded(
                child: RefreshIndicator(
                  color:     AppColors.primary,
                  onRefresh: () => ref.read(bookingProvider.notifier).onRefresh(),
                  child: state.bookings.isEmpty
                      ? ListView(
                          children: [
                            SizedBox(height: AppSpacing.xxl),
                            Center(
                              child: Column(
                                children: [
                                  Text('🎬', style: TextStyle(fontSize: 48)),
                                  SizedBox(height: AppSpacing.md),
                                  Text(
                                    'No bookings yet',
                                    style: TextStyle(
                                      color:    AppColors.textSecondary,
                                      fontSize: AppFontSize.md,
                                    ),
                                  ),
                                  SizedBox(height: AppSpacing.sm),
                                  Text(
                                    'Pull down to refresh',
                                    style: TextStyle(
                                      color:    AppColors.textMuted,
                                      fontSize: AppFontSize.sm,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(
                            vertical:   AppSpacing.md,
                            horizontal: AppSpacing.md,
                          ),
                          itemCount: state.bookings.length,
                          itemBuilder: (_, index) {
                            final booking = state.bookings[index];
                            return BookingCard(
                              booking:  booking,
                              onPress:  () => _handleBookingPress(context, booking),
                            );
                          },
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}