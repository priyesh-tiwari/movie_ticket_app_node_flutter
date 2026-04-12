import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_flutter_app/screens/payment/payment_screen.dart';
import '../../constants/app_constants.dart';
import '../../providers/seat_selection_provider.dart';

class SeatSelectionScreen extends ConsumerStatefulWidget {
  final String movieId;
  final String theaterId;
  final String screenId;
  final String showtimeId;

  const SeatSelectionScreen({
    super.key,
    required this.movieId,
    required this.theaterId,
    required this.screenId,
    required this.showtimeId,
  });

  @override
  ConsumerState<SeatSelectionScreen> createState() =>
      _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends ConsumerState<SeatSelectionScreen> {

  // Release seats on screen dispose 
  @override
  void dispose() {
    ref
        .read(seatSelectionProvider(widget.showtimeId).notifier)
        .releaseSeats();
    super.dispose();
  }

  Future<void> _handleProceed() async {
  final notifier = ref.read(seatSelectionProvider(widget.showtimeId).notifier);
  final state    = ref.read(seatSelectionProvider(widget.showtimeId));

  final success = await notifier.reserveSeats();
  if (success && mounted) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          movieId:       widget.movieId,
          theaterId:     widget.theaterId,
          screenId:      widget.screenId,
          showtimeId:    widget.showtimeId,
          selectedSeats: state.selectedSeats,
          totalAmount:   state.totalAmount,
        ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(seatSelectionProvider(widget.showtimeId));

    // ── Loading 
    if (state.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
        ),
      );
    }

    // Seats list — S1 to S20,
    final seats = List.generate(kTotalSeats, (i) => 'S${i + 1}');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [

            // ── Header 
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical:   AppSpacing.md,
              ),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                                    IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context), iconSize: AppFontSize.xxl,color: AppColors.primary,),

                  SizedBox(width: AppSpacing.md),
                  Text(
                    'Select Seats',
                    style: TextStyle(
                      fontSize:   AppFontSize.lg,
                      fontWeight: FontWeight.bold,
                      color:      AppColors.text,
                    ),
                  ),
                ],
              ),
            ),

            // ── Screen indicator 
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical:   AppSpacing.md,
              ),
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color:        AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border:       Border.all(color: AppColors.border),
              ),
              alignment: Alignment.center,
              child: Text(
                'SCREEN',
                style: TextStyle(
                  fontSize:      AppFontSize.xs,
                  fontWeight:    FontWeight.w700,
                  color:         AppColors.textMuted,
                  letterSpacing: 4,
                ),
              ),
            ),

            // ── Legend 
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _legendItem('Selected',  AppColors.primary),
                  _legendItem('Booked',    AppColors.error),
                  _legendItem('Locked',    AppColors.warning),
                  _legendItem('Available', AppColors.surface),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.sm),

            // ── Error 
            if (state.error != null)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical:   AppSpacing.sm,
                ),
                child: Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color:        AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border:       Border.all(
                        color: AppColors.error.withOpacity(0.4)),
                  ),
                  child: Text(
                    state.error!,
                    style: TextStyle(
                        fontSize: AppFontSize.sm, color: AppColors.error),
                  ),
                ),
              ),

            // ── Seats grid — FlatList numColumns=4
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(AppSpacing.lg),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:   4,
                  crossAxisSpacing: AppSpacing.sm,
                  mainAxisSpacing:  AppSpacing.sm,
                  childAspectRatio: 1,
                ),
                itemCount: seats.length,
                itemBuilder: (_, index) {
                  final seat      = seats[index];
                  final isBooked  = state.bookedSeats.contains(seat);
                  final isLocked  = state.lockedSeats.contains(seat);
                  final isSelected = state.selectedSeats.contains(seat);

                  return GestureDetector(
                    onTap: () => ref
                        .read(seatSelectionProvider(widget.showtimeId).notifier)
                        .toggleSeat(seat),
                    child: Container(
                      decoration: BoxDecoration(
                        color:        _seatColor(
                            isBooked: isBooked,
                            isLocked: isLocked,
                            isSelected: isSelected),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        border: Border.all(
                          color: _seatBorderColor(
                              isBooked: isBooked,
                              isLocked: isLocked,
                              isSelected: isSelected),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        seat,
                        style: TextStyle(
                          fontSize:   AppFontSize.xs,
                          fontWeight: FontWeight.w600,
                          color:      _seatTextColor(
                              isBooked: isBooked,
                              isLocked: isLocked,
                              isSelected: isSelected),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // ── Bottom panel 
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
                color:  AppColors.card,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // Selected seats info box
                  if (state.selectedSeats.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(bottom: AppSpacing.md),
                      padding: EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color:        AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border:       Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Selected Seats',
                                  style: TextStyle(
                                    fontSize: AppFontSize.xs,
                                    color:    AppColors.textMuted,
                                  ),
                                ),
                                SizedBox(height: AppSpacing.xs),
                                Text(
                                  state.selectedSeats.join(', '),
                                  style: TextStyle(
                                    fontSize:   AppFontSize.sm,
                                    fontWeight: FontWeight.w600,
                                    color:      AppColors.text,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Count badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical:   AppSpacing.sm,
                            ),
                            decoration: BoxDecoration(
                              color:        AppColors.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.4),
                              ),
                            ),
                            child: Text(
                              '${state.selectedSeats.length} Seat${state.selectedSeats.length > 1 ? 's' : ''}',
                              style: TextStyle(
                                fontSize:   AppFontSize.sm,
                                fontWeight: FontWeight.w700,
                                color:      AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Proceed button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.selectedSeats.isEmpty || state.isReserving
                          ? null
                          : _handleProceed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor:
                            AppColors.surface,
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: state.isReserving
                          ? CircularProgressIndicator(
                              color:       AppColors.background,
                              strokeWidth: 2,
                            )
                          : Text(
                              state.selectedSeats.isEmpty
                                  ? 'Select Seats'
                                  : 'Proceed to Payment (\$${state.totalAmount.toStringAsFixed(2)})',
                              style: TextStyle(
                                fontSize:   AppFontSize.md,
                                fontWeight: FontWeight.bold,
                                color: state.selectedSeats.isEmpty
                                    ? AppColors.textMuted
                                    : AppColors.background,
                              ),
                            ),
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

  // ── Seat color helpers

  Color _seatColor({
    required bool isBooked,
    required bool isLocked,
    required bool isSelected,
  }) {
    if (isBooked)   return AppColors.error.withOpacity(0.15);
    if (isLocked)   return AppColors.warning.withOpacity(0.15);
    if (isSelected) return AppColors.primary.withOpacity(0.2);
    return AppColors.surface;
  }

  Color _seatBorderColor({
    required bool isBooked,
    required bool isLocked,
    required bool isSelected,
  }) {
    if (isBooked)   return AppColors.error;
    if (isLocked)   return AppColors.warning;
    if (isSelected) return AppColors.primary;
    return AppColors.border;
  }

  Color _seatTextColor({
    required bool isBooked,
    required bool isLocked,
    required bool isSelected,
  }) {
    if (isBooked)   return AppColors.error;
    if (isLocked)   return AppColors.warning;
    if (isSelected) return AppColors.primary;
    return AppColors.textSecondary;
  }

  Widget _legendItem(String label, Color color) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width:  10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color:        color,
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
          SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: TextStyle(
              fontSize: AppFontSize.xs,
              color:    AppColors.textSecondary,
            ),
          ),
        ],
      );
}