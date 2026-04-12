import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_flutter_app/providers/moviedetails_provider.dart';
import '../../constants/app_constants.dart';
import '../theater/theater_list_screen.dart';

class MovieDetailsScreen extends ConsumerWidget {
  final String imdbID;

  const MovieDetailsScreen({super.key, required this.imdbID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(movieDetailsProvider(imdbID));

    // ── Loading ───────────────────────────────────────────────────────────
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

    // ── Error ─────────────────────────────────────────────────────────────
    if (state.error != null || state.movie == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            state.error ?? 'Something went wrong',
            style: TextStyle(color: AppColors.error, fontSize: AppFontSize.md),
          ),
        ),
      );
    }

    final movie = state.movie!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [

          // ── Background poster with blur — RN blurRadius: 10 ───────────
          SizedBox.expand(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Image.network(
                movie.poster,
                fit:          BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: AppColors.surface),
              ),
            ),
          ),

          // ── Dark overlay ──────────────────────────────────────────────
          Container(color: Colors.black.withOpacity(0.6)),

          // ── Back button — SafeAreaView wrapping, same as RN ───────────
          SafeArea(
            child:                   IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context), iconSize: AppFontSize.xxl,color: AppColors.primary,),

          ),

          // ── Bottom card ───────────────────────────────────────────────
          Positioned(
            left:   0,
            right:  0,
            bottom: 0,
            top:    120.h,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft:  Radius.circular(AppRadius.xl),
                  topRight: Radius.circular(AppRadius.xl),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.xxl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Poster — centered, same as RN
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: Image.network(
                          movie.poster,
                          width:        140.w,
                          height:       200.h,
                          fit:          BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width:  140.w,
                            height: 200.h,
                            color:  AppColors.surface,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),

                    // Title
                    Text(
                      movie.title,
                      style: TextStyle(
                        fontSize:   AppFontSize.xl,
                        fontWeight: FontWeight.bold,
                        color:      AppColors.text,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),

                    // Rating + Released — badgeRow, same as RN
                    Row(
                      children: [
                        _badge('⭐ ${movie.imdbRating}'),
                        SizedBox(width: AppSpacing.sm),
                        _badge('📅 ${movie.released}'),
                      ],
                    ),
                    SizedBox(height: AppSpacing.lg),

                    // Synopsis
                    Text(
                      'Synopsis',
                      style: TextStyle(
                        fontSize:   AppFontSize.md,
                        fontWeight: FontWeight.bold,
                        color:      AppColors.text,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      movie.plot,
                      style: TextStyle(
                        fontSize: AppFontSize.sm,
                        color:    AppColors.textSecondary,
                        height:   1.6,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xl),

                    // Book Tickets button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                TheaterListScreen(movieId: imdbID),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(
                              vertical: AppSpacing.md),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                        child: Text(
                          '🎬  Book Tickets',
                          style: TextStyle(
                            fontSize:   AppFontSize.md,
                            fontWeight: FontWeight.bold,
                            color:      AppColors.background,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text) => Container(
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
          text,
          style: TextStyle(
            fontSize: AppFontSize.sm,
            color:    AppColors.text,
          ),
        ),
      );
}