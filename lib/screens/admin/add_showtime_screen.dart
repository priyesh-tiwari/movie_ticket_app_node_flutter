import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/app_constants.dart';
import '../../models/theater_model.dart';
import '../../providers/add_showtime_provider.dart';
import '../../providers/home_provider.dart';

class AddShowtimeScreen extends ConsumerWidget {
  final TheaterModel theater;

  const AddShowtimeScreen({super.key, required this.theater});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state       = ref.watch(addShowtimeProvider(theater));
    final searchState = ref.watch(searchProvider);
    final notifier    = ref.read(addShowtimeProvider(theater).notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────────────────
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
                    'Add Showtime',
                    style: TextStyle(
                      fontSize:   AppFontSize.lg,
                      fontWeight: FontWeight.bold,
                      color:      AppColors.text,
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ─────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: AppSpacing.xxl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Theater info banner
                    Container(
                      margin: EdgeInsets.all(AppSpacing.lg),
                      padding: EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                            color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Text('🏛️',
                              style: TextStyle(fontSize: AppFontSize.xl)),
                          SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  theater.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize:   AppFontSize.md,
                                    fontWeight: FontWeight.bold,
                                    color:      AppColors.text,
                                  ),
                                ),
                                Text(
                                  '📍 ${theater.location}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: AppFontSize.xs,
                                    color:    AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Step 1: Choose Movie ───────────────────────────
                    _SectionLabel(step: '1', label: 'CHOOSE MOVIE'),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Column(
                        children: [
                          // Search input
                          Container(
                            decoration: BoxDecoration(
                              color:        AppColors.surface,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              border:       Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    style: TextStyle(
                                      fontSize: AppFontSize.sm,
                                      color:    AppColors.text,
                                    ),
                                    decoration: InputDecoration(
                                      hintText:        'Search movie...',
                                      hintStyle: TextStyle(
                                          color: AppColors.textMuted),
                                      border:          InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: AppSpacing.md,
                                        vertical:   AppSpacing.md,
                                      ),
                                    ),
                                    onChanged: (v) => ref
                                        .read(searchProvider.notifier)
                                        .search(v),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: AppSpacing.sm),
                                  child: searchState.isLoading
                                      ? SizedBox(
                                          width:  16.w,
                                          height: 16.w,
                                          child: CircularProgressIndicator(
                                            color:       AppColors.primary,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text('🔍',
                                          style: TextStyle(
                                              fontSize: AppFontSize.sm)),
                                ),
                              ],
                            ),
                          ),

                          // Search results dropdown
                          if (searchState.results.isNotEmpty &&
                              state.selectedMovie == null)
                            Container(
                              margin:
                                  EdgeInsets.only(top: AppSpacing.xs),
                              decoration: BoxDecoration(
                                color: AppColors.card,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.md),
                                border:
                                    Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                children: searchState.results
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final idx   = entry.key;
                                  final movie = entry.value;
                                  return GestureDetector(
                                    onTap: () {
                                      notifier.selectMovie(movie);
                                      ref
                                          .read(searchProvider.notifier)
                                          .search('');
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(AppSpacing.md),
                                      decoration: BoxDecoration(
                                        border: idx !=
                                                searchState.results.length - 1
                                            ? const Border(
                                                bottom: BorderSide(
                                                    color: AppColors.border))
                                            : null,
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(
                                                    AppRadius.sm),
                                            child: Image.network(
                                              movie.poster != 'N/A'
                                                  ? movie.poster
                                                  : 'https://via.placeholder.com/44x64?text=N%2FA',
                                              width:  44.w,
                                              height: 64.h,
                                              fit:    BoxFit.cover,
                                              errorBuilder:
                                                  (_, __, ___) => Container(
                                                width:  44.w,
                                                height: 64.h,
                                                color:
                                                    AppColors.surface,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: AppSpacing.md),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  movie.title,
                                                  maxLines:  2,
                                                  overflow:  TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize:   AppFontSize.md,
                                                    fontWeight: FontWeight.bold,
                                                    color:      AppColors.text,
                                                  ),
                                                ),
                                                Text(
                                                  movie.year,
                                                  style: TextStyle(
                                                    fontSize: AppFontSize.xs,
                                                    color:    AppColors.textMuted,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                          // Selected movie card
                          if (state.selectedMovie != null)
                            Container(
                              margin: EdgeInsets.only(top: AppSpacing.sm),
                              padding: EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.md),
                                border: Border.all(
                                    color: AppColors.primary.withOpacity(0.4)),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.sm),
                                    child: Image.network(
                                      state.selectedMovie!.poster != 'N/A'
                                          ? state.selectedMovie!.poster
                                          : 'https://via.placeholder.com/44x64?text=N%2FA',
                                      width:  44.w,
                                      height: 64.h,
                                      fit:    BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.selectedMovie!.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize:   AppFontSize.md,
                                            fontWeight: FontWeight.bold,
                                            color:      AppColors.text,
                                          ),
                                        ),
                                        Text(
                                          state.selectedMovie!.year,
                                          style: TextStyle(
                                            fontSize: AppFontSize.xs,
                                            color:    AppColors.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: notifier.clearMovie,
                                    child: Padding(
                                      padding: EdgeInsets.all(AppSpacing.sm),
                                      child: Text(
                                        '✕',
                                        style: TextStyle(
                                          fontSize: AppFontSize.xs,
                                          color:    AppColors.error,
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

                    // ── Step 2: Screen ─────────────────────────────────
                    _SectionLabel(step: '2', label: 'SELECT SCREEN'),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Wrap(
                        spacing:   AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: theater.screens.map((screen) {
                          final isActive =
                              state.selectedScreenId == screen.id;
                          return GestureDetector(
                            onTap: () => notifier.selectScreen(screen.id),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical:   AppSpacing.sm,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.primary
                                    : AppColors.surface,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.md),
                                border: Border.all(
                                  color: isActive
                                      ? AppColors.primary
                                      : AppColors.border,
                                ),
                              ),
                              child: Text(
                                'Screen ${screen.screenNumber}',
                                style: TextStyle(
                                  fontSize:   AppFontSize.sm,
                                  fontWeight: FontWeight.w600,
                                  color: isActive
                                      ? AppColors.background
                                      : AppColors.text,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // ── Step 3: Date ───────────────────────────────────
                    _SectionLabel(step: '3', label: 'SELECT DATE'),
                    SizedBox(
                      height: 72.h,
                      child: ListView.builder(
                        scrollDirection:  Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg),
                        itemCount: 7,
                        itemBuilder: (_, i) {
                          final date    = DateTime.now().add(Duration(days: i));
                          final dateStr =
                              date.toIso8601String().split('T')[0];
                          final dayName = _shortDay(date.weekday);
                          final isActive = state.selectedDate == dateStr;

                          return GestureDetector(
                            onTap: () => notifier.selectDate(dateStr),
                            child: Container(
                              width:  48.w,
                              margin: EdgeInsets.only(right: AppSpacing.sm),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.primary
                                    : AppColors.surface,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.md),
                                border: Border.all(
                                  color: isActive
                                      ? AppColors.primary
                                      : AppColors.border,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    dayName,
                                    style: TextStyle(
                                      fontSize: AppFontSize.xs,
                                      color: isActive
                                          ? AppColors.background
                                              .withOpacity(0.8)
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    '${date.day}',
                                    style: TextStyle(
                                      fontSize:   AppFontSize.md,
                                      fontWeight: FontWeight.bold,
                                      color: isActive
                                          ? AppColors.background
                                          : AppColors.text,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // ── Step 4: Time ───────────────────────────────────
                    _SectionLabel(step: '4', label: 'SELECT TIME'),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Wrap(
                        spacing:   AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: AddShowtimeState.predefinedTimes.map((time) {
                          final isActive = state.selectedTime == time;
                          return GestureDetector(
                            onTap: () => notifier.selectTime(time),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical:   AppSpacing.sm,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.primary
                                    : AppColors.surface,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.md),
                                border: Border.all(
                                  color: isActive
                                      ? AppColors.primary
                                      : AppColors.border,
                                ),
                              ),
                              child: Text(
                                time,
                                style: TextStyle(
                                  fontSize:   AppFontSize.sm,
                                  fontWeight: FontWeight.w600,
                                  color: isActive
                                      ? AppColors.background
                                      : AppColors.text,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // ── Error ─────────────────────────────────────────
                    if (state.error != null)
                      Container(
                        margin: EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.md,
                          AppSpacing.lg,
                          0,
                        ),
                        padding: EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                              color: AppColors.error.withOpacity(0.4)),
                        ),
                        child: Text(
                          state.error!,
                          style: TextStyle(
                              fontSize: AppFontSize.sm,
                              color:    AppColors.error),
                        ),
                      ),

                    // ── Add Button ────────────────────────────────────
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.lg,
                        AppSpacing.lg,
                        0,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () async {
                                  final success =
                                      await ref
                                          .read(addShowtimeProvider(theater)
                                              .notifier)
                                          .addShowtime();
                                  if (success && context.mounted) {
                                    Navigator.pop(context);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            disabledBackgroundColor:
                                AppColors.primary.withOpacity(0.5),
                            padding: EdgeInsets.symmetric(
                                vertical: AppSpacing.md),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.md),
                            ),
                          ),
                          child: state.isLoading
                              ? SizedBox(
                                  width:  20.w,
                                  height: 20.w,
                                  child: CircularProgressIndicator(
                                    color:       AppColors.background,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Add Showtime',
                                  style: TextStyle(
                                    fontSize:   AppFontSize.md,
                                    fontWeight: FontWeight.bold,
                                    color:      AppColors.background,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _shortDay(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
}

// ─── SectionLabel ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String step;
  final String label;

  const _SectionLabel({required this.step, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          Container(
            width:  22.w,
            height: 22.w,
            decoration: BoxDecoration(
              color:        AppColors.primary,
              borderRadius: BorderRadius.circular(6.r),
            ),
            alignment: Alignment.center,
            child: Text(
              step,
              style: TextStyle(
                fontSize:   AppFontSize.xs,
                fontWeight: FontWeight.bold,
                color:      AppColors.background,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: TextStyle(
              fontSize:      AppFontSize.xs,
              fontWeight:    FontWeight.w700,
              color:         AppColors.textSecondary,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}