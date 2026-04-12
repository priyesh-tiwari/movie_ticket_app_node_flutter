import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_flutter_app/constants/app_constants.dart';
import 'package:movie_flutter_app/models/movie_model.dart';

class MovieSection extends StatefulWidget {
  final String title;
  final List<MovieModel> movies;
  final void Function(MovieModel) onMoviePress;
  const MovieSection({super.key, 
    required this.title,
    required this.movies,
    required this.onMoviePress,
  });

  @override
  State<MovieSection> createState() => _MovieSectionState();
}

class _MovieSectionState extends State<MovieSection> {
  static const _initialCount = 3;
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final cardWidth    =0.32.sw;
    final cardHeight   =0.22.sh;

    final visible = _showAll
        ? widget.movies
        : widget.movies.take(_initialCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:  EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical:   AppSpacing.md,
          ),
          child: Text(widget.title,
              style:  TextStyle(
                fontSize:   AppFontSize.lg,
                fontWeight: FontWeight.bold,
                color:      AppColors.text,
              )),
        ),

        Stack(
          children: [
            SizedBox(
              height: cardHeight + 52.h, // card + text below
              child: ListView.builder(
                scrollDirection:  Axis.horizontal,
                padding:  EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                itemCount:  visible.length,
                itemBuilder: (_, i) {
                  final movie = visible[i];
                  return GestureDetector(
                    onTap: () => widget.onMoviePress(movie),
                    child: Container(
                      width:  cardWidth,
                      margin:  EdgeInsets.only(right: AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            child: CachedNetworkImage(
                              imageUrl:    movie.poster,
                              width:       cardWidth,
                              height:      cardHeight,
                              fit:         BoxFit.cover,
                              placeholder: (_, __) =>
                                  Container(color: AppColors.surface),
                              errorWidget: (_, __, ___) =>
                                  Container(color: AppColors.surface),
                            ),
                          ),
                           SizedBox(height: AppSpacing.xs),
                          Text(movie.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:  TextStyle(
                                fontSize:   AppFontSize.sm,
                                fontWeight: FontWeight.bold,
                                color:      AppColors.text,
                              )),
                          Text(movie.year,
                              style:  TextStyle(
                                fontSize: AppFontSize.sm,
                                color:    AppColors.textSecondary,
                              )),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Explore More overlay
            if (!_showAll)
              Positioned(
                right: 0, top: 0, bottom: 0,
                child: GestureDetector(
                  onTap: () => setState(() => _showAll = true),
                  child: Container(
                    width: 100,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, AppColors.background],
                      ),
                    ),
                    child:  Center(
                      child: Text('Explore More →',
                          style: TextStyle(
                            fontSize:   AppFontSize.sm,
                            fontWeight: FontWeight.bold,
                            color:      AppColors.primary,
                          )),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
