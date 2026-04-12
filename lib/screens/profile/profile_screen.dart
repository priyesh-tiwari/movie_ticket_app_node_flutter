import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/app_constants.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _handleLogout(BuildContext context, WidgetRef ref) {

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          'Logout',
          style: TextStyle(color: AppColors.text, fontSize: AppFontSize.lg),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: AppColors.textSecondary, fontSize: AppFontSize.sm),
        ),
        actions: [
          // Cancel
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textMuted, fontSize: AppFontSize.sm),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authProvider.notifier).logout();
            },
            child: Text(
              'Logout',
              style: TextStyle(
                color:      AppColors.error,
                fontSize:   AppFontSize.sm,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [

            // ── Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical:   AppSpacing.md,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Profile 👤',
                  style: TextStyle(
                    fontSize:   AppFontSize.xl,
                    fontWeight: FontWeight.bold,
                    color:      AppColors.text,
                  ),
                ),
              ),
            ),

            Divider(color: AppColors.border, height: 1),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [

                    SizedBox(height: AppSpacing.lg),

                    // ── User Card
                    Column(
                      children: [
                        Container(
                          width:  90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            user?.name.isNotEmpty == true
                                ? user!.name[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              fontSize:   AppFontSize.xxl,
                              fontWeight: FontWeight.bold,
                              color:      AppColors.background,
                            ),
                          ),
                        ),
                    
                        SizedBox(height: AppSpacing.md),
                    
                        Text(
                          user?.name ?? '',
                          style: TextStyle(
                            fontSize:   AppFontSize.lg,
                            fontWeight: FontWeight.bold,
                            color:      AppColors.text,
                          ),
                        ),
                    
                        SizedBox(height: AppSpacing.xs),
                    
                        
                      ],
                    ),

                    SizedBox(height: AppSpacing.lg),
                    Container(
                      width:   double.infinity,
                      padding: EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color:        Color.fromARGB(255, 52, 51, 51),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border:       Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          _InfoRow(label: 'Name', value: user?.name ?? ''),

                          Divider(color: AppColors.border, height: 1),
                          _InfoRow(
                            label:    'Email',
                            value:    user?.email ?? '',
                            maxLines: 1,
                          ),

                          Divider(color: AppColors.border, height: 1),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Role',
                                  style: TextStyle(
                                    fontSize: AppFontSize.sm,
                                    color:    AppColors.text,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm,
                                    vertical:   AppSpacing.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color:        AppColors.primary.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(AppRadius.sm),
                                    border: Border.all(color: AppColors.primary),
                                  ),
                                  child: Text(
                                    (user?.role ?? '').toUpperCase(),
                                    style: TextStyle(
                                      fontSize:   AppFontSize.xs,
                                      fontWeight: FontWeight.bold,
                                      color:      AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: 100.w,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () => _handleLogout(context, ref),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 52, 51, 51),
                          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            side: BorderSide(color: AppColors.primaryDark),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize:   AppFontSize.md,
                            fontWeight: FontWeight.bold,
                            color:      AppColors.error,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable Info Row 

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final int?   maxLines;

  const _InfoRow({
    required this.label,
    required this.value,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppFontSize.sm,
              color:    AppColors.text,
            ),
          ),
          Flexible(
            child: Text(
              value,
              maxLines: maxLines,
              overflow: maxLines != null ? TextOverflow.ellipsis : null,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize:   AppFontSize.sm,
                fontWeight: FontWeight.w500,
                color:      AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}