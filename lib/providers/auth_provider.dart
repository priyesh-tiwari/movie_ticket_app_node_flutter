
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

// Auth State 

class AuthState {
  final bool       isLoggedIn;
  final UserModel? user;
  final bool       isLoading;
  final String     errorMessage;

  const AuthState({
    this.isLoggedIn   = false,
    this.user,
    this.isLoading    = false,
    this.errorMessage = '',
  });

  AuthState copyWith({
    bool?       isLoggedIn,
    UserModel?  user,
    bool?       isLoading,
    String?     errorMessage,
  }) => AuthState(
    isLoggedIn:   isLoggedIn   ?? this.isLoggedIn,
    user:         user         ?? this.user,
    isLoading:    isLoading    ?? this.isLoading,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}

// Auth Notifier

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  //  Login 

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      final user = await AuthService.login(email: email, password: password);
      state = state.copyWith(
        isLoading:  false,
        isLoggedIn: true,
        user:       user,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading:    false,
        errorMessage: _parseError(e),
      );
      return false;
    }
  }

  //  Logout 

  Future<void> logout() async {
    try {
      await AuthService.logout();
    } catch (_) {
      await StorageService.clearStorage();
    } finally {
      state = const AuthState();
    }
  }

  // Refresh Profile on App Start 

  Future<void> refreshProfile() async {
    if (!state.isLoggedIn) return;
    try {
      final user = await AuthService.fetchProfile();
      state = state.copyWith(user: user);
    } catch (_) {
      // silently fail — stay logged in with stale data
    }
  }

  // Restore session 

  Future<void> restoreSession() async {
    final token = await StorageService.getAccessToken();
    if (token == null) return;

    try {
      final user = await AuthService.fetchProfile();
      state = state.copyWith(isLoggedIn: true, user: user);
    } catch (_) {
      await StorageService.clearStorage();
    }
  }

  // ── Set error from outside (signup / forgot password flows) ───────────────

  void setError(String message) =>
      state = state.copyWith(errorMessage: message);

  void clearError() =>
      state = state.copyWith(errorMessage: '');

  // ── Helper ─────────────────────────────────────────────────────────────────

  String _parseError(Object e) {
    if (e is DioException) {
        return e.response?.data['message'] as String? ?? 'Something went wrong';
    }
    return 'Something went wrong';
  }
}

// ─── Providers 

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());


// ─── Signup State + Notifier 

class SignupState {
  final bool   isLoading;
  final String errorMessage;
  final bool   isPasswordVisible;
  final bool   isConfirmPasswordVisible;
  final bool   otpSent;

  const SignupState({
    this.isLoading               = false,
    this.errorMessage            = '',
    this.isPasswordVisible       = false,
    this.isConfirmPasswordVisible = false,
    this.otpSent                 = false,
  });

  SignupState copyWith({
    bool?   isLoading,
    String? errorMessage,
    bool?   isPasswordVisible,
    bool?   isConfirmPasswordVisible,
    bool?   otpSent,
  }) => SignupState(
    isLoading:               isLoading               ?? this.isLoading,
    errorMessage:            errorMessage            ?? this.errorMessage,
    isPasswordVisible:       isPasswordVisible       ?? this.isPasswordVisible,
    isConfirmPasswordVisible: isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
    otpSent:                 otpSent                 ?? this.otpSent,
  );
}

class SignupNotifier extends StateNotifier<SignupState> {
  SignupNotifier() : super(const SignupState());

  void togglePasswordVisible() =>
      state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);

  void toggleConfirmPasswordVisible() =>
      state = state.copyWith(
          isConfirmPasswordVisible: !state.isConfirmPasswordVisible);

  Future<bool> sendOtp(
      String name, String email, String password, String confirmPassword) async {
    // ── Validation (equivalent of zod schema) ──────────────────────────────
    if (name.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Name is required');
      return false;
    }
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      state = state.copyWith(errorMessage: 'Invalid email address');
      return false;
    }
    if (password.length < 6) {
      state = state.copyWith(
          errorMessage: 'Password must be at least 6 characters');
      return false;
    }
    if (confirmPassword.isEmpty) {
      state = state.copyWith(errorMessage: 'Confirm password is required');
      return false;
    }
    if (password != confirmPassword) {
      state = state.copyWith(errorMessage: 'Passwords do not match');
      return false;
    }

    state = state.copyWith(
      isLoading:    true,
      errorMessage: 'Server is waking up, please wait up to 60 seconds...',
    );

    try {
      await AuthService.sendOtp(name: name, email: email, password: password);
      state = state.copyWith(
        isLoading:    false,
        otpSent:      true,
        errorMessage: '',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading:    false,
        errorMessage: _parseError(e),
      );
      return false;
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      await AuthService.verifyOtp(email: email, otp: otp);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: _parseError(e));
      return false;
    }
  }

  String _parseError(Object e) {
    final msg   = e.toString();
    final match = RegExp(r'"message":"([^"]+)"').firstMatch(msg);
    return match?.group(1) ?? 'Something went wrong';
  }
}

final signupProvider =
    StateNotifierProvider.autoDispose<SignupNotifier, SignupState>(
        (ref) => SignupNotifier());


// ─── Forgot Password State + Notifier ────────────────────────────────────────

class ForgotPasswordState {
  final bool   isLoading;
  final String errorMessage;
  final bool   otpSent;
  final bool   isPasswordVisible;

  const ForgotPasswordState({
    this.isLoading        = false,
    this.errorMessage     = '',
    this.otpSent          = false,
    this.isPasswordVisible = false,
  });

  ForgotPasswordState copyWith({
    bool?   isLoading,
    String? errorMessage,
    bool?   otpSent,
    bool?   isPasswordVisible,
  }) => ForgotPasswordState(
    isLoading:         isLoading         ?? this.isLoading,
    errorMessage:      errorMessage      ?? this.errorMessage,
    otpSent:           otpSent           ?? this.otpSent,
    isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
  );
}

class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordState> {
  ForgotPasswordNotifier() : super(const ForgotPasswordState());

  void togglePasswordVisible() =>
      state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);

  Future<bool> sendOtp(String email) async {
    if (email.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Email is required');
      return false;
    }
    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      await AuthService.forgotPassword(email: email);
      state = state.copyWith(isLoading: false, otpSent: true);
      return true;
    } catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: _parseError(e));
      return false;
    }
  }

  Future<bool> resetPassword(
      String email, String otp, String newPassword) async {
    if (otp.isEmpty || newPassword.isEmpty) {
      state = state.copyWith(errorMessage: 'All fields are required');
      return false;
    }
    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      await AuthService.resetPassword(
          email: email, otp: otp, newPassword: newPassword);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: _parseError(e));
      return false;
    }
  }

  String _parseError(Object e) {
    final msg   = e.toString();
    final match = RegExp(r'"message":"([^"]+)"').firstMatch(msg);
    return match?.group(1) ?? 'Something went wrong';
  }
}

final forgotPasswordProvider =
    StateNotifierProvider.autoDispose<ForgotPasswordNotifier, ForgotPasswordState>(
        (ref) => ForgotPasswordNotifier());