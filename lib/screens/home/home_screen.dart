import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_flutter_app/screens/movie/movie_details_screen.dart';
import 'package:movie_flutter_app/widgets/carousel_state_widget.dart';
import 'package:movie_flutter_app/widgets/movie_section_widget.dart';
import 'package:movie_flutter_app/widgets/searchbar_widget.dart';
import 'package:movie_flutter_app/widgets/section_label_widget.dart';
import 'package:movie_flutter_app/widgets/trailer_section_widget.dart';
import '../../constants/app_constants.dart';
import '../../models/movie_model.dart';
import '../../providers/home_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _showSearch = false;

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning ☀️';
    if (hour < 17) return 'Good Afternoon 🌤️';
    return 'Good Evening 🌙';
  }

  void _handleMoviePress(MovieModel movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MovieDetailsScreen(imdbID: movie.imdbID),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeProvider);

    return SafeArea(
      child: Column(
        children: [

          // ── Header ───────────────────────────────────────────────────────
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical:   AppSpacing.md,
            ),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // Hamburger
                GestureDetector(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 22, height: 2, decoration: BoxDecoration(color: AppColors.text, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(height: 5),
                      Container(width: 16, height: 2, decoration: BoxDecoration(color: AppColors.text, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(height: 5),
                      Container(width: 22, height: 2, decoration: BoxDecoration(color: AppColors.text, borderRadius: BorderRadius.circular(2))),
                    ],
                  ),
                ),

                // Brand
                Text('CINEMAX',
                    style: TextStyle(
                      fontSize:      AppFontSize.xs,
                      fontWeight:    FontWeight.w700,
                      color:         AppColors.primary,
                      letterSpacing: 5,
                    )),

                // Search toggle
                GestureDetector(
                  onTap: () => setState(() => _showSearch = !_showSearch),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color:  _showSearch ? AppColors.primary : AppColors.surface,
                      shape:  BoxShape.circle,
                      border: Border.all(
                        color: _showSearch ? AppColors.primary : AppColors.border,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _showSearch ? '✕' : '🔍',
                        style: TextStyle(fontSize: AppFontSize.sm),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Search Bar ───────────────────────────────────────────────────
          if (_showSearch) Searchbar(onMoviePress: _handleMoviePress),

          // ── Body ─────────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Loading
                  if (state.isLoading)
                    Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(color: AppColors.primary),
                            SizedBox(height: AppSpacing.md),
                            Text('Loading movies...',
                                style: TextStyle(
                                  fontSize: AppFontSize.xs,
                                  color:    AppColors.textSecondary,
                                )),
                          ],
                        ),
                      ),
                    ),

                  // Error
                  if (state.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Center(
                        child: Column(
                          children: [
                            const Text('😕', style: TextStyle(fontSize: 40)),
                            SizedBox(height: AppSpacing.md),
                            Text(state.error!,
                                style: TextStyle(
                                  fontSize: AppFontSize.md,
                                  color:    AppColors.error,
                                )),
                          ],
                        ),
                      ),
                    ),

                  // Content
                  if (!state.isLoading && state.error == null) ...[

                    // Greeting
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_getGreeting(),
                              style: TextStyle(
                                fontSize:      AppFontSize.xxl,
                                fontWeight:    FontWeight.w300,
                                color:         AppColors.text,
                                letterSpacing: 0.3,
                              )),
                          SizedBox(height: AppSpacing.xs),
                          Text('What are you watching tonight?',
                              style: TextStyle(
                                fontSize: AppFontSize.sm,
                                color:    AppColors.textSecondary,
                              )),
                        ],
                      ),
                    ),

                    // Carousel
                    Carousel(
                      movies:       state.trending,
                      onMoviePress: _handleMoviePress,
                    ),

                    // Trailers
                    TrailerSection(movies: state.trending),

                    // NOW SHOWING
                    SectionLabel(label: 'NOW SHOWING'),
                    MovieSection(
                      title:        'Trending',
                      movies:       state.trending,
                      onMoviePress: _handleMoviePress,
                    ),

                    // CRITICS CHOICE
                    SectionLabel(label: 'CRITICS CHOICE'),
                    MovieSection(
                      title:        'Top Rated',
                      movies:       state.topRated,
                      onMoviePress: _handleMoviePress,
                    ),

                    // BINGE WATCH
                    SectionLabel(label: 'BINGE WATCH'),
                    MovieSection(
                      title:        'TV Shows',
                      movies:       state.tv,
                      onMoviePress: _handleMoviePress,
                    ),

                    SizedBox(height: AppSpacing.xxl),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}