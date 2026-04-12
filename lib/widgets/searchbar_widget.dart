import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movie_flutter_app/constants/app_constants.dart';
import 'package:movie_flutter_app/models/movie_model.dart';
import 'package:movie_flutter_app/providers/home_provider.dart';

class Searchbar extends ConsumerStatefulWidget {
  final void Function(MovieModel) onMoviePress;
  const Searchbar({super.key, required this.onMoviePress});

  @override
  ConsumerState<Searchbar> createState() => _SearchbarState();
}

class _SearchbarState extends ConsumerState<Searchbar> {
  final _ctrl  = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _ctrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchProvider.notifier).search(value);
    });
  }

  // ── Fixed constants — device independent ────────────────────────────────────
  static const double _imageHeight = 160.0;
  static const double _textHeight  = 44.0; // title + year fixed
  static const double _topPadding  = 12.0;
  static const double _totalHeight = _imageHeight + _textHeight + _topPadding;

  @override
  Widget build(BuildContext context) {
    final state      = ref.watch(searchProvider);
    final cardWidth  = MediaQuery.of(context).size.width * 0.32;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical:   AppSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // ── Input ──────────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color:        AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border:       Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: AppSpacing.md),
                  child: Text('🔍',
                      style: TextStyle(fontSize: AppFontSize.md)),
                ),
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    autofocus:  true,
                    onChanged:  _onChanged,
                    style: TextStyle(
                      fontSize: AppFontSize.md,
                      color:    AppColors.text,
                    ),
                    decoration: InputDecoration(
                      hintText:       'Search movies...',
                      hintStyle:      TextStyle(color: AppColors.textMuted),
                      border:         InputBorder.none,
                      contentPadding: EdgeInsets.all(AppSpacing.md),
                    ),
                  ),
                ),
                if (state.isLoading)
                  Padding(
                    padding: EdgeInsets.only(right: AppSpacing.md),
                    child: SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color:       AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Results ────────────────────────────────────────────────────
          if (state.results.isNotEmpty)
            SizedBox(
              height: _totalHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding:     EdgeInsets.only(top: _topPadding),
                itemCount:   state.results.length,
                itemBuilder: (_, i) {
                  final movie = state.results[i];
                  return GestureDetector(
                    onTap: () => widget.onMoviePress(movie),
                    child: SizedBox(
                      width: cardWidth,
                      child: Padding(
                        padding: EdgeInsets.only(right: AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // ── Image — fixed height ───────────────────
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              child: CachedNetworkImage(
                                imageUrl: movie.poster,
                                width:    cardWidth,
                                height:   _imageHeight, // ← fixed
                                fit:      BoxFit.cover,
                                placeholder: (_, __) => Container(
                                  width:  cardWidth,
                                  height: _imageHeight,
                                  color:  AppColors.surface,
                                ),
                                errorWidget: (_, __, ___) => Container(
                                  width:  cardWidth,
                                  height: _imageHeight,
                                  color:  AppColors.surface,
                                ),
                              ),
                            ),

                            // ── Title — fixed height ───────────────────
                            SizedBox(
                              height: 20,
                              child: Text(
                                movie.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize:   AppFontSize.sm,
                                  fontWeight: FontWeight.bold,
                                  color:      AppColors.text,
                                ),
                              ),
                            ),

                            // ── Year — fixed height ────────────────────
                            SizedBox(
                              height: 20,
                              child: Text(
                                movie.year,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: AppFontSize.sm,
                                  color:    AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}