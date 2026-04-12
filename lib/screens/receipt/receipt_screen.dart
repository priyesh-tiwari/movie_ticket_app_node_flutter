import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_flutter_app/main_screen.dart';
import '../../constants/app_constants.dart';
import '../home/home_screen.dart'; // adjust import if needed

class ReceiptScreen extends StatelessWidget {
  final String movieId;
  final String theaterId;
  final String showtimeId;
  final List<dynamic> selectedSeats;
  final double totalAmount;

  const ReceiptScreen({
    super.key,
    required this.movieId,
    required this.theaterId,
    required this.showtimeId,
    required this.selectedSeats,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [

              // ── Success Icon 
              SizedBox(height: AppSpacing.xl),
              Text('✅', style: TextStyle(fontSize: 60.sp)),
              SizedBox(height: AppSpacing.md),
              Text(
                'Booking Confirmed!',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: AppFontSize.xl,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Your tickets are booked successfully',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppFontSize.sm,
                ),
              ),

              SizedBox(height: AppSpacing.lg),

              // ── Receipt Card 
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎬 Booking Details',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: AppFontSize.lg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Divider(color: AppColors.border),
                    SizedBox(height: AppSpacing.sm),

                    _DetailRow(label: 'Movie ID',    value: movieId),
                    _DetailRow(label: 'Theater ID',  value: theaterId),
                    _DetailRow(label: 'Showtime ID', value: showtimeId),
                    _DetailRow(
                      label: 'Seats',
                      value: selectedSeats.join(', '),
                    ),

                    SizedBox(height: AppSpacing.sm),
                    Divider(color: AppColors.border),
                    SizedBox(height: AppSpacing.sm),

                    _DetailRow(
                      label: 'Total Amount',
                      value: '\$${totalAmount.toStringAsFixed(2)}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpacing.lg),

              // ── Go to Home Button 
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: Text(
                    '🏠 Go to Home',
                    style: TextStyle(
                      color: AppColors.background,
                      fontSize: AppFontSize.md,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.sm),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainScreen(initialIndex: 1), // 1 = Bookings tab
                      ),
                      (route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: Text(
                    '📋 My Bookings',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: AppFontSize.md,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reusable Detail Row ────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? AppColors.text : AppColors.textSecondary,
              fontSize: isTotal ? AppFontSize.md : AppFontSize.sm,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isTotal ? AppColors.primary : AppColors.text,
              fontSize: isTotal ? AppFontSize.md : AppFontSize.sm,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}