// ─── Theater Card

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_flutter_app/constants/app_constants.dart';
import 'package:movie_flutter_app/models/theater_with_showtime_model.dart';
import 'package:movie_flutter_app/screens/seat/seat_selection_screen.dart';

class TheaterCard extends StatelessWidget {
  final TheaterWithShowtimesModel theater;
  final String movieId;

  const TheaterCard({required this.theater, required this.movieId});

  void _handleShowtimePress(
      BuildContext context, ShowtimeItemModel showtime) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => SeatSelectionScreen(
        movieId:    movieId,
        theaterId:  theater.id,
        screenId:   showtime.screenId,
        showtimeId: showtime.id,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color:        AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border:       Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top accent
          Container(
            height: 3.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft:  Radius.circular(AppRadius.lg),
                topRight: Radius.circular(AppRadius.lg),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Theater name
                Text(
                  '🎬  ${theater.name}',
                  style: TextStyle(
                    fontSize:   AppFontSize.md,
                    fontWeight: FontWeight.bold,
                    color:      AppColors.text,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),

                // Location
                Text(
                  '📍  ${theater.location}',
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    color:    AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSpacing.md),

                // Showtimes label
                Text(
                  'Showtimes:',
                  style: TextStyle(
                    fontSize:   AppFontSize.xs,
                    fontWeight: FontWeight.w700,
                    color:      AppColors.textMuted,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),

                // Showtime chips
                Wrap(
                  spacing:   AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: theater.showtimes.map((showtime) {
                    return GestureDetector(
                      onTap: () =>
                          _handleShowtimePress(context, showtime),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical:   AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color:        AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.4),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              showtime.date,
                              style: TextStyle(
                                fontSize: AppFontSize.xs,
                                color:    AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              showtime.time,
                              style: TextStyle(
                                fontSize:   AppFontSize.sm,
                                fontWeight: FontWeight.bold,
                                color:      AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}