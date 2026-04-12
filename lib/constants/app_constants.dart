import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ─── Colors ───────────────────────────────────────────────────────────────────

class AppColors {
  static const Color background    = Color.fromARGB(255, 73, 72, 72);
  static const Color surface       = Color(0xFF1A1A1A);
  static const Color card          = Color(0xFF141414);
  static const Color primary       = Color(0xFFF5A623);
  static const Color primaryDark   = Color(0xFFC47D0E);
  static const Color text          = Color(0xFFF0F0F0);
  static const Color textSecondary = Color(0xFF888888);
  static const Color textMuted     = Color(0xFF555555);
  static const Color error         = Color(0xFFE05252);
  static const Color success       = Color(0xFF44BB44);
  static const Color warning       = Color(0xFFFF9500);
  static const Color border        = Color(0xFF242424);
}

// ─── Font Sizes — wp() jaisa ──────────────────────────────────────────────────

class AppFontSize {
  static double get xs  => 12.sp;
  static double get sm  => 13.5.sp;
  static double get md  => 15.5.sp;
  static double get lg  => 19.sp;
  static double get xl  => 23.sp;
  static double get xxl => 27.sp;
}

// ─── Spacing — wp() jaisa ─────────────────────────────────────────────────────

class AppSpacing {
  static double get xs  => 4.w;
  static double get sm  => 8.w;
  static double get md  => 16.w;
  static double get lg  => 24.w;
  static double get xl  => 32.w;
  static double get xxl => 40.w;
}

// ─── Border Radius ────────────────────────────────────────────────────────────

class AppRadius {
  static double get sm => 8.r;
  static double get md => 12.r;
  static double get lg => 16.r;
  static double get xl => 24.r;
}

// ─── API ──────────────────────────────────────────────────────────────────────

class ApiConstants {
  static const String baseUrl     = 'https://movie-ticket-app-node-backend.onrender.com';
  static const String omdbApiKey  = '2d24410';
  static const String omdbBaseUrl = 'https://www.omdbapi.com/';
  static const String tmdbApiKey  = '636f32db89ff7719c85af0803b1b04da';
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
}