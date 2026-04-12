import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';
import '../providers/auth_provider.dart';
import '../main_screen.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  void _handleLogout(BuildContext context, WidgetRef ref) {
    Navigator.pop(context); // drawer band karo pehle
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
              // AuthGate automatically LoginScreen pe le jaayega
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

    // Same as RN menuItems array
    final menuItems = [
      {'icon': '🏠', 'label': 'Home',        'index': 0},
      {'icon': '🎟️', 'label': 'My Bookings', 'index': 1},
      {'icon': '👤', 'label': 'Profile',      'index': 3},
    ];

    return Drawer(
      backgroundColor: AppColors.card,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── User Section ──────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Avatar
                  Container(
                    width:  70,
                    height: 70,
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

                  Text(
                    user?.email ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSize.sm,
                      color:    AppColors.textMuted,
                    ),
                  ),

                  SizedBox(height: AppSpacing.sm),

                  // Role badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical:   AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color:        AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border:       Border.all(color: AppColors.primary),
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

            Divider(color: AppColors.border, height: 1),

            // ── Menu Items ────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical:   AppSpacing.sm,
              ),
              child: Column(
                children: menuItems.map((item) {
                  return GestureDetector(
                    onTap: () {
                      // Same as RN: navigation.closeDrawer() + navigate
                      Navigator.pop(context); // drawer band karo
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MainScreen(
                            initialIndex: item['index'] as int,
                          ),
                        ),
                        (route) => false,
                      );
                    },
                    child: Container(
                      width:   double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical:   AppSpacing.md,
                      ),
                      margin: EdgeInsets.only(bottom: AppSpacing.xs),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Row(
                        children: [
                          Text(
                            item['icon'] as String,
                            style: TextStyle(fontSize: AppFontSize.lg),
                          ),
                          SizedBox(width: AppSpacing.md),
                          Text(
                            item['label'] as String,
                            style: TextStyle(
                              fontSize:   AppFontSize.md,
                              fontWeight: FontWeight.w500,
                              color:      AppColors.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            Divider(color: AppColors.border, height: 1),

            // ── Logout ────────────────────────────────────────────────────
            GestureDetector(
              onTap: () => _handleLogout(context, ref),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical:   AppSpacing.md,
                ),
                child: Row(
                  children: [
                    Text(
                      '🚪',
                      style: TextStyle(fontSize: AppFontSize.lg),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize:   AppFontSize.md,
                        fontWeight: FontWeight.bold,
                        color:      AppColors.error,
                      ),
                    ),
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