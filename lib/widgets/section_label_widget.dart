import 'package:flutter/material.dart';
import 'package:movie_flutter_app/constants/app_constants.dart';

// ignore: unused_element
class SectionLabel extends StatelessWidget {
  final String label;
  const SectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) => Padding(
        padding:  EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, AppSpacing.xs,
        ),
        child: Row(
          children: [
            Container(
              width: 3, height: 18,
              decoration: BoxDecoration(
                color:        AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
             SizedBox(width: AppSpacing.sm),
            Text(label,
                style:  TextStyle(
                  fontSize:      AppFontSize.xs,
                  fontWeight:    FontWeight.w700,
                  color:         AppColors.primaryDark,
                  letterSpacing: 3,
                )),
          ],
        ),
      );
}