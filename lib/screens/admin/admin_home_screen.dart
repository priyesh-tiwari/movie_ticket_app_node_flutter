import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_flutter_app/widgets/theater_section_widget.dart';
import '../../constants/app_constants.dart';
import '../../providers/admin_provider.dart';

class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  ConsumerState<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen> {
  bool   _modalVisible = false;
  String _name         = '';
  String _location     = '';
  bool   _adding       = false;

  Future<void> _handleAddTheater() async {
    if (_name.isEmpty || _location.isEmpty) return;
    setState(() => _adding = true);
    await ref.read(adminProvider.notifier).createTheater(_name, _location);
    if (mounted) {
      setState(() {
        _adding        = false;
        _modalVisible  = false;
        _name          = '';
        _location      = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state       = ref.watch(adminProvider);
    final totalScreens =
        state.theaters.fold<int>(0, (sum, t) => sum + t.screens.length);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──────────────────────────────────────────────
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.xl,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.border),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Admin Panel',
                                    style: TextStyle(
                                      fontSize:   AppFontSize.xl,
                                      fontWeight: FontWeight.bold,
                                      color:      AppColors.text,
                                    ),
                                  ),
                                  SizedBox(height: AppSpacing.xs),
                                  if (state.isLoading)
                                    Text(
                                      'Loading...',
                                      style: TextStyle(
                                        fontSize: AppFontSize.sm,
                                        color:    AppColors.textSecondary,
                                      ),
                                    )
                                  else
                                    Text(
                                      '${state.theaters.length} theater${state.theaters.length != 1 ? 's' : ''}  ·  $totalScreens screen${totalScreens != 1 ? 's' : ''}',
                                      style: TextStyle(
                                        fontSize: AppFontSize.sm,
                                        color:    AppColors.text,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(width: AppSpacing.md),

                            // + Theater button
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _modalVisible = true),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical:   AppSpacing.sm,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.md),
                                ),
                                child: Text(
                                  '+ Theater',
                                  style: TextStyle(
                                    fontSize:   AppFontSize.sm,
                                    fontWeight: FontWeight.bold,
                                    color:      AppColors.background,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ── Loading ───────────────────────────────────────────
                  if (state.isLoading)
                    Padding(
                      padding: EdgeInsets.only(top: AppSpacing.xxl),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 2,
                        ),
                      ),
                    ),

                  // ── Error ─────────────────────────────────────────────
                  if (state.error != null)
                    Container(
                      margin: EdgeInsets.all(AppSpacing.lg),
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
                            fontSize: AppFontSize.sm, color: AppColors.error),
                      ),
                    ),

                  // ── Theaters list ─────────────────────────────────────
                  if (!state.isLoading && state.error == null)
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.lg,
                        AppSpacing.lg,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section label
                          Row(
                            children: [
                              Container(
                                width:  3.w,
                                height: 20.h,
                                decoration: BoxDecoration(
                                  color:        AppColors.primary,
                                  borderRadius: BorderRadius.circular(2.r),
                                ),
                              ),
                              SizedBox(width: AppSpacing.sm),
                              Text(
                                'YOUR THEATERS',
                                style: TextStyle(
                                  fontSize:      AppFontSize.xs,
                                  fontWeight:    FontWeight.w700,
                                  color:         AppColors.text,
                                  letterSpacing: 3,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.md),

                          if (state.theaters.isEmpty)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: AppSpacing.xxl),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.lg),
                                border: Border.all(color: AppColors.border),
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Text('🏛️',
                                      style: TextStyle(
                                          fontSize: AppFontSize.xxl)),
                                  SizedBox(height: AppSpacing.md),
                                  Text(
                                    'No theaters yet',
                                    style: TextStyle(
                                      fontSize:   AppFontSize.md,
                                      fontWeight: FontWeight.bold,
                                      color:      AppColors.text,
                                    ),
                                  ),
                                  SizedBox(height: AppSpacing.xs),
                                  Text(
                                    'Tap "+ Theater" to add one',
                                    style: TextStyle(
                                      fontSize: AppFontSize.sm,
                                      color:    AppColors.textSecondary,
                                    ),
                                  ),
                                  SizedBox(height: AppSpacing.lg),
                                  GestureDetector(
                                    onTap: () =>
                                        setState(() => _modalVisible = true),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: AppSpacing.xl,
                                        vertical:   AppSpacing.md,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius:
                                            BorderRadius.circular(AppRadius.md),
                                      ),
                                      child: Text(
                                        '+ Add Theater',
                                        style: TextStyle(
                                          fontSize:   AppFontSize.sm,
                                          fontWeight: FontWeight.bold,
                                          color:      AppColors.background,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            ...state.theaters.map(
                              (theater) => TheaterSection(
                                key:     ValueKey(theater.id),
                                theater: theater,
                              ),
                            ),
                        ],
                      ),
                    ),

                  SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),

            // ── Add Theater Modal ─────────────────────────────────────────
            if (_modalVisible) _buildAddTheaterModal(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddTheaterModal() {
    return GestureDetector(
      onTap: () => setState(() => _modalVisible = false),
      child: Container(
        color: Colors.black54,
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () {},
          child: Container(
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  'Add Theater',
                  style: TextStyle(
                    fontSize:   AppFontSize.lg,
                    fontWeight: FontWeight.bold,
                    color:      AppColors.text,
                  ),
                ),
                Text(
                  'Fill in the details below',
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    color:    AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSpacing.lg),

                _modalLabel('THEATER NAME'),
                SizedBox(height: AppSpacing.sm),
                _modalInput(
                  hint:      'e.g. PVR Cinemas',
                  onChanged: (v) => _name = v,
                ),
                SizedBox(height: AppSpacing.md),

                _modalLabel('LOCATION'),
                SizedBox(height: AppSpacing.sm),
                _modalInput(
                  hint:      'e.g. Connaught Place, Delhi',
                  onChanged: (v) => _location = v,
                ),
                SizedBox(height: AppSpacing.lg),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _adding ? null : _handleAddTheater,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor:
                          AppColors.primary.withOpacity(0.5),
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    child: _adding
                        ? CircularProgressIndicator(
                            color:       AppColors.background,
                            strokeWidth: 2,
                          )
                        : Text(
                            'Add Theater',
                            style: TextStyle(
                              fontSize:   AppFontSize.md,
                              fontWeight: FontWeight.bold,
                              color:      AppColors.background,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: AppSpacing.sm),

                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => setState(() => _modalVisible = false),
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
    );
  }

  Widget _modalLabel(String text) => Text(
        text,
        style: TextStyle(
          fontSize:      AppFontSize.xs,
          fontWeight:    FontWeight.w700,
          color:         AppColors.textMuted,
          letterSpacing: 1.5,
        ),
      );

  Widget _modalInput({
    required String hint,
    required ValueChanged<String> onChanged,
  }) =>
      TextField(
        style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.text),
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText:      hint,
          hintStyle:     TextStyle(color: AppColors.textMuted),
          filled:        true,
          fillColor:     AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide:   const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide:   const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide:   const BorderSide(color: AppColors.primary),
          ),
        ),
      );
}