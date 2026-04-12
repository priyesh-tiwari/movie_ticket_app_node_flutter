import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_flutter_app/constants/app_constants.dart';
import 'package:movie_flutter_app/models/showtime_model.dart';

class ShowtimeCard extends StatelessWidget {
  final ShowtimeModel showtime;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ShowtimeCard({super.key, 
    required this.showtime,
    required this.onEdit,
    required this.onDelete, required 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top accent line
          Container(
            height: 2.h,
            color: AppColors.primary.withOpacity(0.38),
          ),

          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Movie info row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Poster
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      child: showtime.moviePoster != null
                          ? Image.network(
                              showtime.moviePoster!,
                              width:  42.w,
                              height: 64.h,
                              fit:    BoxFit.cover,
                              errorBuilder: (_, __, ___) => _posterPlaceholder(),
                            )
                          : _posterPlaceholder(),
                    ),
                    SizedBox(width: AppSpacing.md),

                    // Title + ID
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            showtime.movieTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize:   AppFontSize.md,
                              fontWeight: FontWeight.bold,
                              color:      AppColors.text,
                            ),
                          ),
                          SizedBox(height: AppSpacing.xs),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical:   AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color:        AppColors.surface,
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                              border:       Border.all(color: AppColors.border),
                            ),
                            child: Text(
                              showtime.movieId,
                              style: TextStyle(
                                fontSize: AppFontSize.xs,
                                color:    AppColors.textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.md),

                // Date row
                _infoRow(icon: '📅', value: showtime.date),
                SizedBox(height: AppSpacing.xs),
                // Time row
                _infoRow(icon: '⏰', value: showtime.time),

                SizedBox(height: AppSpacing.md),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onEdit,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                          decoration: BoxDecoration(
                            color:        AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.4),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '✏️  Edit',
                            style: TextStyle(
                              fontSize:   AppFontSize.sm,
                              color:      AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: GestureDetector(
                        onTap: onDelete,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                          decoration: BoxDecoration(
                            color:        AppColors.error.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            border: Border.all(
                              color: AppColors.error.withOpacity(0.4),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '🗑️  Delete',
                            style: TextStyle(
                              fontSize:   AppFontSize.sm,
                              color:      AppColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _posterPlaceholder() => Container(
        width:  42.w,
        height: 64.h,
        decoration: BoxDecoration(
          color:        AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border:       Border.all(color: AppColors.border),
        ),
        alignment: Alignment.center,
        child: const Text('🎬'),
      );

  Widget _infoRow({
    required String icon,
    required String value,
  }) =>
      Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical:   AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color:        AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border:       Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 20.w,
              child: Text(
                '$icon ',
                style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textMuted),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize:   AppFontSize.sm,
                  fontWeight: FontWeight.w600,
                  color:      AppColors.text,
                ),
              ),
            ),
          ],
        ),
      );
}