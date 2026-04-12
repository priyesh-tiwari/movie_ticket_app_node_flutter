import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_flutter_app/constants/app_constants.dart';
import 'package:movie_flutter_app/models/showtime_model.dart';
import 'package:movie_flutter_app/models/theater_model.dart';
import 'package:movie_flutter_app/providers/manage_showtime_provider.dart';
import 'package:movie_flutter_app/screens/admin/add_showtime_screen.dart';
import 'package:movie_flutter_app/widgets/showtime_widget.dart';

class TheaterSection extends ConsumerStatefulWidget {
  final TheaterModel theater;

  const TheaterSection({required this.theater, required ValueKey<String> key});

  @override
  ConsumerState<TheaterSection> createState() => TheaterSectionState();
}

class TheaterSectionState extends ConsumerState<TheaterSection> {
  bool   _expanded     = false;
  String? _activeScreen;

  // Edit modal state
  bool   _editModalVisible  = false;
  String? _editingShowtimeId;
  String _editDate          = '';
  String _editTime          = '';

  static const _predefinedTimes = [
    '09:00 AM', '12:00 PM', '03:00 PM', '06:00 PM', '09:00 PM',
  ];

  void _openEdit(ShowtimeModel showtime) {
    setState(() {
      _editingShowtimeId  = showtime.id;
      _editDate           = showtime.date;
      _editTime           = showtime.time;
      _editModalVisible   = true;
    });
  }

  Future<void> _saveEdit() async {
    if (_editingShowtimeId == null) return;
    final success = await ref
        .read(manageShowtimesProvider(widget.theater.id).notifier)
        .editShowtime(_editingShowtimeId!, {
      'date': _editDate,
      'time': _editTime,
    });
    if (success && mounted) setState(() => _editModalVisible = false);
  }

  void _confirmDelete(String showtimeId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          'Delete Showtime',
          style: TextStyle(color: AppColors.text, fontSize: AppFontSize.md),
        ),
        content: Text(
          'Are you sure?',
          style: TextStyle(color: AppColors.textSecondary, fontSize: AppFontSize.sm),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: AppColors.textMuted, fontSize: AppFontSize.sm)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(manageShowtimesProvider(widget.theater.id).notifier)
                  .deleteShowtime(showtimeId);
            },
            child: Text('Delete',
                style: TextStyle(color: AppColors.error, fontSize: AppFontSize.sm)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final showtimesState = ref.watch(manageShowtimesProvider(widget.theater.id));

    // Group showtimes by screenId
    final Map<String, List<ShowtimeModel>> byScreen = {};
    for (final s in showtimesState.showtimes) {
      byScreen.putIfAbsent(s.screenId, () => []).add(s);
    }

    // Merge screen IDs from theater model + fetched showtimes
    final theaterScreenIds =
        widget.theater.screens.map((s) => s.id).toSet();
    final allScreenIds = {
      ...theaterScreenIds,
      ...byScreen.keys,
    }.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Theater name + location label (above card, like RN)
        Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.theater.name,
                style: TextStyle(
                  fontSize:   AppFontSize.md,
                  fontWeight: FontWeight.bold,
                  color:      AppColors.text,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                '📍 ${widget.theater.location}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppFontSize.xs,
                  color:    AppColors.text,
                ),
              ),
            ],
          ),
        ),

        // Theater card
        Container(
          margin: EdgeInsets.only(bottom: AppSpacing.md),
          decoration: BoxDecoration(
            color:        AppColors.background,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: _expanded
                  ? AppColors.primary.withOpacity(0.38)
                  : AppColors.border,
            ),
          ),
          child: Column(
            children: [
              // Top accent bar
              // Container(
              //   height: 3.5.h,
              //   decoration: BoxDecoration(
              //     color: AppColors.primary,
              //     borderRadius: BorderRadius.only(
              //       topLeft:  Radius.circular(AppRadius.lg),
              //       topRight: Radius.circular(AppRadius.lg),
              //     ),
              //   ),
              // ),

              // Header row — tap to expand/collapse
              GestureDetector(
                onTap: () => setState(() {
                  _expanded = !_expanded;
                  if (!_expanded) _activeScreen = null;
                }),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      // Screen count badge
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical:   AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.25),
                              ),
                            ),
                            child: Text(
                              '${widget.theater.screens.length} screens',
                              style: TextStyle(
                                fontSize:   AppFontSize.xs,
                                color:      AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Chevron
                      Container(
                        width:  28.w,
                        height: 28.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _expanded
                              ? AppColors.primary.withOpacity(0.12)
                              : AppColors.surface,
                          border: Border.all(
                            color: _expanded
                                ? AppColors.primary.withOpacity(0.38)
                                : AppColors.border,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _expanded ? '▲' : '▼',
                          style: TextStyle(
                            fontSize: AppFontSize.xs,
                            color: _expanded
                                ? AppColors.primary
                                : AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Expanded body
              if (_expanded) ...[
                Container(height: 1, color: AppColors.border),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // + Add Showtime button
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AddShowtimeScreen(theater: widget.theater),
                          ),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(bottom: AppSpacing.lg),
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical:   AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.38),
                            ),
                          ),
                          child: Text(
                            '+ Add Showtime',
                            style: TextStyle(
                              fontSize:   AppFontSize.sm,
                              color:      AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      // Section label
                      _sectionLabel('SCREENS — TAP TO VIEW SHOWTIMES'),
                      SizedBox(height: AppSpacing.sm),

                      if (showtimesState.isLoading)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      else ...[
                        // Screen radio list
                        ...allScreenIds.asMap().entries.map((entry) {
                          final idx      = entry.key;
                          final screenId = entry.value;
                          final count    = byScreen[screenId]?.length ?? 0;
                          final isActive = _activeScreen == screenId;

                          return GestureDetector(
                            onTap: () => setState(() =>
                                _activeScreen = isActive ? null : screenId),
                            child: Container(
                              margin: EdgeInsets.only(bottom: AppSpacing.sm),
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical:   AppSpacing.md,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.primary.withOpacity(0.08)
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(AppRadius.md),
                                border: Border.all(
                                  color: isActive
                                      ? AppColors.primary
                                      : AppColors.border,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Radio circle
                                  Container(
                                    width:  18.w,
                                    height: 18.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isActive
                                            ? AppColors.primary
                                            : AppColors.textMuted,
                                        width: 2,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: isActive
                                        ? Container(
                                            width:  9.w,
                                            height: 9.w,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.primary,
                                            ),
                                          )
                                        : null,
                                  ),
                                  SizedBox(width: AppSpacing.md),

                                  // Screen label
                                  Expanded(
                                    child: Text(
                                      'Screen ${idx + 1}',
                                      style: TextStyle(
                                        fontSize:   AppFontSize.sm,
                                        fontWeight: isActive
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        color: isActive
                                            ? AppColors.primary
                                            : AppColors.text,
                                      ),
                                    ),
                                  ),

                                  // Count badge
                                  if (count > 0)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: AppSpacing.sm,
                                        vertical:   AppSpacing.xs,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? AppColors.primary
                                            : AppColors.border,
                                        borderRadius: BorderRadius.circular(10.r),
                                      ),
                                      child: Text(
                                        '$count',
                                        style: TextStyle(
                                          fontSize:   AppFontSize.xs,
                                          fontWeight: FontWeight.w700,
                                          color: isActive
                                              ? AppColors.background
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),

                        // Showtimes for selected screen
                        if (_activeScreen != null) ...[
                          SizedBox(height: AppSpacing.sm),
                          _sectionLabel('SHOWTIMES'),
                          SizedBox(height: AppSpacing.sm),

                          if ((byScreen[_activeScreen] ?? []).isEmpty)
                            Container(
                              padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                              decoration: BoxDecoration(
                                color:        AppColors.surface,
                                borderRadius: BorderRadius.circular(AppRadius.md),
                                border: Border.all(
                                  color: AppColors.border,
                                  // dashed not natively supported; styled border
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Text('🎬',
                                      style: TextStyle(fontSize: AppFontSize.xl)),
                                  SizedBox(height: AppSpacing.sm),
                                  Text(
                                    'No showtimes for this screen',
                                    style: TextStyle(
                                      fontSize: AppFontSize.md,
                                      color:    AppColors.textSecondary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          else
                            ...(byScreen[_activeScreen] ?? []).map(
                              (showtime) => ShowtimeCard(
                                key:      ValueKey(showtime.id),
                                showtime: showtime,
                                onEdit:   () => _openEdit(showtime),
                                onDelete: () => _confirmDelete(showtime.id),
                              ),
                            ),
                        ],
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),

        // Edit modal
        if (_editModalVisible) _buildEditModal(),
      ],
    );
  }

  Widget _sectionLabel(String text) => Row(
        children: [
          Container(
            width:  3.w,
            height: 14.h,
            decoration: BoxDecoration(
              color:        AppColors.primary,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Text(
            text,
            style: TextStyle(
              fontSize:      AppFontSize.xs,
              fontWeight:    FontWeight.w700,
              color:         AppColors.text,
              letterSpacing: 2,
            ),
          ),
        ],
      );

  Widget _buildEditModal() {
    return GestureDetector(
      onTap: () => setState(() => _editModalVisible = false),
      child: Container(
        color: Colors.black54,
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () {}, // absorb taps inside modal
          child: Container(
            margin: EdgeInsets.only(top: 60.h),
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.only(
                topLeft:  Radius.circular(AppRadius.xl),
                topRight: Radius.circular(AppRadius.xl),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width:  40.w,
                      height: 4.h,
                      margin: EdgeInsets.only(bottom: AppSpacing.lg),
                      decoration: BoxDecoration(
                        color:        AppColors.border,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),

                  // Brand
                  Text(
                    'CINEMAX',
                    style: TextStyle(
                      fontSize:      AppFontSize.sm,
                      fontWeight:    FontWeight.w900,
                      color:         AppColors.primary,
                      letterSpacing: 4,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    height: 1,
                    color: AppColors.primary.withOpacity(0.4),
                  ),
                  Text(
                    'Edit Showtime',
                    style: TextStyle(
                      fontSize:   AppFontSize.lg,
                      fontWeight: FontWeight.bold,
                      color:      AppColors.text,
                    ),
                  ),
                  Text(
                    'Update date or time below',
                    style: TextStyle(
                      fontSize: AppFontSize.sm,
                      color:    AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),

                  // Date input
                  Text(
                    'DATE',
                    style: TextStyle(
                      fontSize:      AppFontSize.xs,
                      fontWeight:    FontWeight.w700,
                      color:         AppColors.textMuted,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: TextEditingController(text: _editDate)
                      ..selection = TextSelection.collapsed(
                          offset: _editDate.length),
                    style: TextStyle(
                        fontSize: AppFontSize.sm, color: AppColors.text),
                    decoration: InputDecoration(
                      hintText:        'YYYY-MM-DD',
                      hintStyle:       TextStyle(color: AppColors.textMuted),
                      filled:          true,
                      fillColor:       AppColors.surface,
                      border:          OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide:   const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder:   OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide:   const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder:   OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide:
                            const BorderSide(color: AppColors.primary),
                      ),
                    ),
                    onChanged: (v) => _editDate = v,
                  ),
                  SizedBox(height: AppSpacing.lg),

                  // Time chips
                  Text(
                    'TIME',
                    style: TextStyle(
                      fontSize:      AppFontSize.xs,
                      fontWeight:    FontWeight.w700,
                      color:         AppColors.textMuted,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing:   AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: _predefinedTimes.map((time) {
                      final isActive = _editTime == time;
                      return GestureDetector(
                        onTap: () => setState(() => _editTime = time),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical:   AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primary
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(AppRadius.md),
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
                  SizedBox(height: AppSpacing.lg),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveEdit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize:   AppFontSize.md,
                          fontWeight: FontWeight.bold,
                          color:      AppColors.background,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),

                  // Cancel
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () =>
                          setState(() => _editModalVisible = false),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: AppFontSize.sm,
                          color:    AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}