import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_flutter_app/screens/auth/login_screen.dart';
import '../../constants/app_constants.dart';
import '../../providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameCtrl            = TextEditingController();
  final _emailCtrl           = TextEditingController();
  final _passwordCtrl        = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _otpCtrl             = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSendOtp() async {
    await ref.read(signupProvider.notifier).sendOtp(
          _nameCtrl.text.trim(),
          _emailCtrl.text.trim(),
          _passwordCtrl.text,
          _confirmPasswordCtrl.text,
        );
  }

  Future<void> _handleSignup() async {
    final success = await ref
        .read(signupProvider.notifier)
        .verifyOtp(_emailCtrl.text.trim(), _otpCtrl.text.trim());
    if (success && mounted) {
      Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => const LoginScreen()),
  (route) => false,
);
    };
  }

  // ── Reusable input builder (local — no separate file needed) ───────────────
  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.words,
    bool obscureText = false,
    Widget? suffixIcon,
    bool enabled = true,
    int? maxLength,
    TextAlign textAlign = TextAlign.start,
    double? letterSpacing,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:  TextStyle(
              fontSize: AppFontSize.xs,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 2,
            )),
         SizedBox(height: AppSpacing.sm),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          enabled: enabled,
          maxLength: maxLength,
          textAlign: textAlign,
          style: TextStyle(
            fontSize: AppFontSize.md,
            color: AppColors.text,
            letterSpacing: letterSpacing,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.surface,
            counterText: '',
            contentPadding:  EdgeInsets.all(AppSpacing.md),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            suffixIcon: suffixIcon != null
                ? Padding(
                    padding:  EdgeInsets.all(AppSpacing.md),
                    child: suffixIcon,
                  )
                : null,
            suffixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
          ),
        ),
         SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state   = ref.watch(signupProvider);
    final otpSent = state.otpSent;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding:  EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xxl,
          ),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Brand Header ───────────────────────────────────────────────
               Text('CINEMAX',
                  style: TextStyle(
                    fontSize: AppFontSize.xs,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    letterSpacing: 6,
                  )),
               SizedBox(height: AppSpacing.sm),
              Container(width: 32, height: 1, color: AppColors.border),
               SizedBox(height: AppSpacing.xl),

              // ── Title ──────────────────────────────────────────────────────
               Text('Create Account',
                  style: TextStyle(
                    fontSize: AppFontSize.xxl,
                    fontWeight: FontWeight.w300,
                    color: AppColors.text,
                    letterSpacing: 0.3,
                  )),
               SizedBox(height: AppSpacing.xs),
               Text('Join CineMax today 🎬',
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    color: AppColors.textSecondary,
                  )),
               SizedBox(height: AppSpacing.xl),

              // ── Fields ─────────────────────────────────────────────────────
              _buildInput(
                controller: _nameCtrl,
                label: 'FULL NAME',
                placeholder: 'Enter your name',
              ),
              _buildInput(
                controller: _emailCtrl,
                label: 'EMAIL',
                placeholder: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
              ),
              _buildInput(
                controller: _passwordCtrl,
                label: 'PASSWORD',
                placeholder: 'Enter your password',
                obscureText: !state.isPasswordVisible,
                suffixIcon: GestureDetector(
                  onTap: () => ref
                      .read(signupProvider.notifier)
                      .togglePasswordVisible(),
                  child: Text(
                    state.isPasswordVisible ? '👁️' : '🙈',
                    style:  TextStyle(fontSize: AppFontSize.md),
                  ),
                ),
              ),
              _buildInput(
                controller: _confirmPasswordCtrl,
                label: 'CONFIRM PASSWORD',
                placeholder: 'Confirm your password',
                obscureText: !state.isConfirmPasswordVisible,
                suffixIcon: GestureDetector(
                  onTap: () => ref
                      .read(signupProvider.notifier)
                      .toggleConfirmPasswordVisible(),
                  child: Text(
                    state.isConfirmPasswordVisible ? '👁️' : '🙈',
                    style:  TextStyle(fontSize: AppFontSize.md),
                  ),
                ),
              ),

              // ── OTP — only after OTP sent ──────────────────────────────────
              if (otpSent)
                _buildInput(
                  controller: _otpCtrl,
                  label: 'OTP',
                  placeholder: 'Enter OTP',
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  letterSpacing: 8,
                ),

              // ── Error ──────────────────────────────────────────────────────
              if (state.errorMessage.isNotEmpty)
                Container(
                  margin:  EdgeInsets.only(bottom: AppSpacing.md),
                  padding:  EdgeInsets.symmetric(
                    vertical: AppSpacing.sm,
                    horizontal: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: const Border(
                      left: BorderSide(color: AppColors.error, width: 3),
                    ),
                  ),
                  child: Text(state.errorMessage,
                      style:  TextStyle(
                        fontSize: AppFontSize.sm,
                        color: AppColors.error,
                      )),
                ),

              // ── Button ─────────────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.isLoading
                      ? null
                      : (otpSent ? _handleSignup : _handleSendOtp),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                    padding:
                         EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: state.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.background,
                          ),
                        )
                      : Text(otpSent ? 'Sign Up' : 'Send OTP',
                          style:  TextStyle(
                            fontSize: AppFontSize.md,
                            fontWeight: FontWeight.w700,
                            color: AppColors.background,
                            letterSpacing: 1.5,
                          )),
                ),
              ),

              // ── Login Link ─────────────────────────────────────────────────
               SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text('Already have an account?',
                      style: TextStyle(
                        fontSize: AppFontSize.sm,
                        color: AppColors.textSecondary,
                      )),
                  GestureDetector(
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    ),
                              child:  Text(' Login',
                                            style: TextStyle(
                          fontSize: AppFontSize.sm,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        )),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}