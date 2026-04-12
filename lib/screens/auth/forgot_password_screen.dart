import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_flutter_app/screens/auth/login_screen.dart';
import '../../constants/app_constants.dart';
import '../../providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends ConsumerState<ForgotPasswordScreen> {
  final _emailCtrl       = TextEditingController();
  final _otpCtrl         = TextEditingController();
  final _newPasswordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _otpCtrl.dispose();
    _newPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSendOtp() async {
    await ref
        .read(forgotPasswordProvider.notifier)
        .sendOtp(_emailCtrl.text.trim());
  }

  Future<void> _handleResetPassword() async {
    final success = await ref
        .read(forgotPasswordProvider.notifier)
        .resetPassword(
          _emailCtrl.text.trim(),
          _otpCtrl.text.trim(),
          _newPasswordCtrl.text,
        );
    if (success && mounted) {
      Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => const LoginScreen()),
  (route) => false,
);
    };
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    TextInputType keyboardType = TextInputType.text,
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
        Opacity(
          opacity: enabled ? 1.0 : 0.5,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
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
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(color: AppColors.border),
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
        ),
         SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state   = ref.watch(forgotPasswordProvider);
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

              // ── Back Button ────────────────────────────────────────────────
                                IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context), iconSize: AppFontSize.xxl,color: AppColors.primary,),


              // ── Title ──────────────────────────────────────────────────────
               Text('Forgot Password',
                  style: TextStyle(
                    fontSize: AppFontSize.xxl,
                    fontWeight: FontWeight.w300,
                    color: AppColors.text,
                    letterSpacing: 0.3,
                  )),
               SizedBox(height: AppSpacing.xs),
              Text(
                otpSent
                    ? 'Enter OTP sent to your email'
                    : 'Enter your email to receive OTP',
                style:  TextStyle(
                  fontSize: AppFontSize.sm,
                  color: AppColors.textSecondary,
                ),
              ),
               SizedBox(height: AppSpacing.xl),

              // ── Email ──────────────────────────────────────────────────────
              _buildInput(
                controller: _emailCtrl,
                label: 'EMAIL ADDRESS',
                placeholder: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                enabled: !otpSent,
              ),

              // ── OTP + New Password — only after OTP sent ───────────────────
              if (otpSent) ...[
                _buildInput(
                  controller: _otpCtrl,
                  label: 'OTP',
                  placeholder: 'Enter OTP',
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  letterSpacing: 8,
                ),
                _buildInput(
                  controller: _newPasswordCtrl,
                  label: 'NEW PASSWORD',
                  placeholder: 'Enter new password',
                  obscureText: !state.isPasswordVisible,
                  suffixIcon: GestureDetector(
                    onTap: () => ref
                        .read(forgotPasswordProvider.notifier)
                        .togglePasswordVisible(),
                    child: Text(
                      state.isPasswordVisible ? '👁️' : '🙈',
                      style:  TextStyle(fontSize: AppFontSize.md),
                    ),
                  ),
                ),
              ],

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
                      : (otpSent ? _handleResetPassword : _handleSendOtp),
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
                      : Text(otpSent ? 'Reset Password' : 'Send OTP',
                          style:  TextStyle(
                            fontSize: AppFontSize.md,
                            fontWeight: FontWeight.w700,
                            color: AppColors.background,
                            letterSpacing: 1.5,
                          )),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}