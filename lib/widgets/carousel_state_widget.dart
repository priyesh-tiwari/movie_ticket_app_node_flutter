import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_flutter_app/constants/app_constants.dart';
import 'package:movie_flutter_app/models/movie_model.dart';

class Carousel extends StatefulWidget {
  final List<MovieModel> movies;
  final void Function(MovieModel) onMoviePress;
  const Carousel({super.key, required this.movies, required this.onMoviePress});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final _controller  = PageController(viewportFraction: 0.88);
  int   _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (widget.movies.isEmpty) return;
      final next = (_currentIndex + 1) % widget.movies.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) return const SizedBox();

    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(
          height: 0.30.sh,
          child: PageView.builder(
            controller:  _controller,
            itemCount:   widget.movies.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
              _startAutoScroll();
            },
            itemBuilder: (_, index) {
              final movie = widget.movies[index];
              return GestureDetector(
                onTap: () => widget.onMoviePress(movie),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Poster
                      CachedNetworkImage(
                        imageUrl:   movie.poster,
                        fit:        BoxFit.cover,
                        placeholder: (_, __) => Container(color: AppColors.surface),
                        errorWidget: (_, __, ___) => Container(color: AppColors.surface),
                      ),

                      // Gradient overlay
                      Positioned(
                        bottom: 0, left: 0, right: 0,
                        child: Container(
                          height: screenHeight * 0.15,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end:   Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black87],
                            ),
                          ),
                        ),
                      ),

                      // Title + year overlay
                      Positioned(
                        bottom: 0, left: 0, right: 0,
                        child: Padding(
                          padding:  EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:  EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical:   2,
                                ),
                                decoration: BoxDecoration(
                                  color:        AppColors.primary,
                                  borderRadius: BorderRadius.circular(AppRadius.sm),
                                ),
                                child: const Text('TRENDING',
                                    style: TextStyle(
                                      fontSize:   10,
                                      fontWeight: FontWeight.w700,
                                      color:      AppColors.background,
                                      letterSpacing: 1,
                                    )),
                              ),
                               SizedBox(height: AppSpacing.xs),
                              Text(movie.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style:  TextStyle(
                                    fontSize:   AppFontSize.lg,
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
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Dots
         SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.movies.length, (index) {
            final isActive = index == _currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width:  isActive ? 20 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color:        isActive ? AppColors.primary : AppColors.border,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}