import 'package:flutter/material.dart';
import 'package:movie_flutter_app/constants/app_constants.dart';
import 'package:movie_flutter_app/models/movie_model.dart';
import 'package:movie_flutter_app/services/movie_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


// ─── Trailer Section ──────────────────────────────────────────────────────────

class TrailerSection extends StatefulWidget {
  final List<MovieModel> movies;
  const TrailerSection({required this.movies});

  @override
  State<TrailerSection> createState() => _TrailerSectionState();
}

class _TrailerSectionState extends State<TrailerSection> {
  static const _maxMovies = 6;

  List<Map<String, String>>  _trailers      = [];
  YoutubePlayerController?   _controller;
  bool                       _isLoading     = true;
  int                        _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchTrailers();
  }

  Future<void> _fetchTrailers() async {
    final subset  = widget.movies.take(_maxMovies).toList();
    final results = await Future.wait(
      subset.map((m) async {
        final key = await MovieService.fetchTrailer(m.imdbID);
        if (key == null) return null;
        return {
          'imdbID':   m.imdbID,
          'title':    m.title,
          'year':     m.year,
          'videoKey': key,
        };
      }),
    );

    if (!mounted) return;

    final trailers = results.whereType<Map<String, String>>().toList();
    if (trailers.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    // Sirf ek controller — pehle trailer ke liye
    _controller = YoutubePlayerController(
      initialVideoId: trailers[0]['videoKey']!,
      flags: const YoutubePlayerFlags(
        autoPlay:        false,
        hideControls:    false,
        disableDragSeek: true,
        forceHD:         false,
      ),
    );

    setState(() {
      _trailers  = trailers;
      _isLoading = false;
    });
  }

  void _selectTrailer(int index) {
    if (_controller == null) return;
    setState(() => _selectedIndex = index);
    _controller!.load(_trailers[index]['videoKey']!);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        height: 160,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
              SizedBox(height: AppSpacing.sm),
              Text('Loading trailers…',
                  style: TextStyle(
                    fontSize:      AppFontSize.xs,
                    color:         AppColors.textMuted,
                    letterSpacing: 1,
                  )),
            ],
          ),
        ),
      );
    }

    if (_trailers.isEmpty || _controller == null) return const SizedBox();

    final current = _trailers[_selectedIndex];

    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Section Label ──────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  width: 3, height: 16,
                  decoration: BoxDecoration(
                    color:        AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Text('TRAILERS',
                    style: TextStyle(
                      fontSize:      AppFontSize.xs,
                      fontWeight:    FontWeight.w700,
                      color:         AppColors.primaryDark,
                      letterSpacing: 3,
                    )),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.sm),

          // ── Player ────────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Column(
                children: [

                  // YouTube Player
                  YoutubePlayer(
                    controller: _controller!,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: AppColors.primary,
                  ),

                  // Now Playing Footer
                  Container(
                    color: AppColors.card,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical:   AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28, height: 28,
                          decoration: BoxDecoration(
                            shape:  BoxShape.circle,
                            color:  AppColors.primary.withOpacity(0.2),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.55),
                            ),
                          ),
                          child: const Center(
                            child: Text('▶',
                                style: TextStyle(
                                  fontSize: 10,
                                  color:    AppColors.primary,
                                )),
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(current['title']!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize:   AppFontSize.sm,
                                    fontWeight: FontWeight.w700,
                                    color:      AppColors.text,
                                  )),
                              Text(current['year']!,
                                  style: TextStyle(
                                    fontSize: AppFontSize.xs,
                                    color:    AppColors.textMuted,
                                  )),
                            ],
                          ),
                        ),
                        Text('${_selectedIndex + 1}/${_trailers.length}',
                            style: TextStyle(
                              fontSize: AppFontSize.xs,
                              color:    AppColors.textMuted,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSpacing.sm),

          // ── Trailer List ───────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Container(
              decoration: BoxDecoration(
                color:        const Color(0xFF302e2e),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.35),
                ),
              ),
              child: Column(
                children: List.generate(_trailers.length, (i) {
                  final t          = _trailers[i];
                  final isSelected = i == _selectedIndex;

                  return GestureDetector(
                    onTap: () => _selectTrailer(i),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical:   AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.15)
                            : Colors.transparent,
                        border: Border(
                          bottom: BorderSide(
                            color: i == _trailers.length - 1
                                ? Colors.transparent
                                : AppColors.border,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [

                          // Play / Active icon
                          Container(
                            width: 28, height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.primary.withOpacity(0.2),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.55),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                isSelected ? '▶' : '▷',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isSelected
                                      ? AppColors.background
                                      : AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: AppSpacing.sm),

                          // Title + Year
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t['title']!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize:   AppFontSize.sm,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.text,
                                    )),
                                Text(t['year']!,
                                    style: TextStyle(
                                      fontSize: AppFontSize.xs,
                                      color:    AppColors.textMuted,
                                    )),
                              ],
                            ),
                          ),

                          // Index
                          Text('${i + 1}',
                              style: TextStyle(
                                fontSize: AppFontSize.xs,
                                color:    AppColors.textMuted,
                              )),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}