import 'package:flutter/material.dart';
import 'package:movie_flutter_app/constants/app_constants.dart';
import 'package:movie_flutter_app/models/booking_model.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onPress;

  const BookingCard({super.key, required this.booking, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin:  EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color:        const Color.fromARGB(255, 52, 51, 51),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border:       Border.all(color: AppColors.text),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [

            // ── Card Top
            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    width:  44,
                    height: 44,
                    decoration: BoxDecoration(
                      color:        AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    alignment: Alignment.center,
                    child: const Text('🎬', style: TextStyle(fontSize: 20)),
                  ),

                  SizedBox(width: AppSpacing.md),

                  // Movie ID + date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.movieId,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize:   AppFontSize.md,
                            fontWeight: FontWeight.bold,
                            color:      const Color.fromARGB(255, 208, 203, 203),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '${booking.createdAt.day} '
                          '${_month(booking.createdAt.month)} '
                          '${booking.createdAt.year}',
                          style: TextStyle(
                            fontSize: AppFontSize.xs,
                            color:    AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical:   AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color:        AppColors.success.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.4),
                      ),
                    ),
                    child: Text(
                      booking.paymentStatus,
                      style: TextStyle(
                        fontSize:   AppFontSize.xs,
                        fontWeight: FontWeight.w600,
                        color:      AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Divider(color: AppColors.border, height: 1),

            // ── Card Bottom
            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Seats',
                          style: TextStyle(
                            fontSize: AppFontSize.xs,
                            color:    AppColors.text,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          booking.selectedSeats.join(', '),
                          style: TextStyle(
                            fontSize:   AppFontSize.sm,
                            fontWeight: FontWeight.bold,
                            color:      AppColors.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: AppFontSize.xs,
                          color:    AppColors.text,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '\$${booking.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize:   AppFontSize.md,
                          fontWeight: FontWeight.bold,
                          color:      AppColors.text,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Tap hint
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical:   AppSpacing.sm,
              ),
              color: booking.showtimeId == null
                  ? Colors.orange.withOpacity(0.12)
                  : AppColors.surface,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (booking.showtimeId == null) ...[
                    Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 13),
                    SizedBox(width: 5),
                    Text(
                      'Showtime removed by admin',
                      style: TextStyle(
                        fontSize: AppFontSize.xs,
                        color:    Colors.orange,
                      ),
                    ),
                  ] else
                    Text(
                      'Tap to view receipt →',
                      style: TextStyle(
                        fontSize: AppFontSize.xs,
                        color:    AppColors.primary,
                      ),
                    ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  String _month(int m) => const [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m];
}