import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_flutter_app/providers/theaterlist_provider.dart';
import 'package:movie_flutter_app/widgets/theater_card_widget.dart';
import '../../constants/app_constants.dart';

class TheaterListScreen extends ConsumerWidget {
  final String movieId;

  const TheaterListScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state    = ref.watch(theaterListProvider(movieId));
    final notifier = ref.read(theaterListProvider(movieId).notifier);

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
                    'Select Theater 🎭',
                    style: TextStyle(
                      fontSize:   AppFontSize.lg,
                      fontWeight: FontWeight.bold,
                      color:      AppColors.text,
                    ),
                  ),
                ],
              ),
            ),

            // ── Search 
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Container(
                decoration: BoxDecoration(
                  color:        AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border:       Border.all(color: AppColors.border),
                ),
                child: TextField(
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    color:    AppColors.text,
                  ),
                  decoration: InputDecoration(
                    hintText:       'Search by location...',
                    hintStyle:      TextStyle(color: AppColors.textMuted),
                    prefixIcon:     Icon(
                      Icons.location_on_outlined,
                      color: AppColors.textMuted,
                      size: 20.sp,
                    ),
                    border:         InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                  ),
                  onChanged: notifier.updateSearch,
                ),
              ),
            ),

            // ── Body 
            Expanded(
              child: state.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color:       AppColors.primary,
                        strokeWidth: 2,
                      ),
                    )
                  : state.error != null
                      ? Center(
                          child: Text(
                            state.error!,
                            style: TextStyle(
                              fontSize: AppFontSize.md,
                              color:    AppColors.error,
                            ),
                          ),
                        )
                      : state.filteredTheaters.isEmpty
                          ? Center(
                              child: Text(
                                'No theaters available',
                                style: TextStyle(
                                  fontSize: AppFontSize.md,
                                  color:    AppColors.textSecondary,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                              ),
                              itemCount: state.filteredTheaters.length,
                              itemBuilder: (_, index) => TheaterCard(
                                theater: state.filteredTheaters[index],
                                movieId: movieId,
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

