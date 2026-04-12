import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../auth/signup_screen.dart';
import '../auth/forgot_password_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _pwVisible     = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    await ref.read(authProvider.notifier).login(
          _emailCtrl.text.trim(),
          _passwordCtrl.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

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
               Text('Welcome back',
                  style: TextStyle(
                    fontSize: AppFontSize.xxl,
                    fontWeight: FontWeight.w300,
                    color: AppColors.text,
                    letterSpacing: 0.3,
                  )),
               SizedBox(height: AppSpacing.xs),
               Text('Sign in to continue',
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    color: AppColors.textSecondary,
                  )),
             SizedBox(height: AppSpacing.xl),

              // ── Email ──────────────────────────────────────────────────────
               Text('EMAIL',
                  style: TextStyle(
                    fontSize: AppFontSize.xs,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                    letterSpacing: 2,
                  )),
               SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                style:  TextStyle(
                  fontSize: AppFontSize.md,
                  color: AppColors.text,
                ),
                decoration: InputDecoration(
                  hintText: 'you@example.com',
                  hintStyle: const TextStyle(color: AppColors.textMuted),
                  filled: true,
                  fillColor: AppColors.surface,
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
                ),
              ),
               SizedBox(height: AppSpacing.lg),

              // ── Password ───────────────────────────────────────────────────
               Text('PASSWORD',
                  style: TextStyle(
                    fontSize: AppFontSize.xs,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                    letterSpacing: 2,
                  )),
               SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _passwordCtrl,
                obscureText: !_pwVisible,
                style:  TextStyle(
                  fontSize: AppFontSize.md,
                  color: AppColors.text,
                ),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: const TextStyle(color: AppColors.textMuted),
                  filled: true,
                  fillColor: AppColors.surface,
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
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() => _pwVisible = !_pwVisible),
                    child: Padding(
                      padding:  EdgeInsets.all(AppSpacing.md),
                      child: Text(
                        _pwVisible ? '👁️' : '🙈',
                        style:  TextStyle(fontSize: AppFontSize.md),
                      ),
                    ),
                  ),
                  suffixIconConstraints:
                      const BoxConstraints(minWidth: 0, minHeight: 0),
                ),
              ),
               SizedBox(height: AppSpacing.md),

              // ── Error ──────────────────────────────────────────────────────
              if (authState.errorMessage.isNotEmpty)
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
                  child: Text(authState.errorMessage,
                      style:  TextStyle(
                        fontSize: AppFontSize.sm,
                        color: AppColors.error,
                      )),
                ),

              // ── Forgot Password ────────────────────────────────────────────
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordScreen(),
                    ),
                  ),
                  child:  Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.lg),
                    child: Text('Forgot password?',
                        style: TextStyle(
                          fontSize: AppFontSize.sm,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        )),
                  ),
                ),
              ),

              // ── Login Button ───────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authState.isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor:
                        AppColors.primary.withOpacity(0.5),
                    padding:  EdgeInsets.symmetric(
                        vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: authState.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.background,
                          ),
                        )
                      :  Text('Login',
                          style: TextStyle(
                            fontSize: AppFontSize.md,
                            fontWeight: FontWeight.w700,
                            color: AppColors.background,
                            letterSpacing: 1.5,
                          )),
                ),
              ),

              // ── Signup Link ────────────────────────────────────────────────
               SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text("Don't have an account?",
                      style: TextStyle(
                        fontSize: AppFontSize.sm,
                        color: AppColors.textSecondary,
                      )),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignupScreen(),
                      ),
                    ),
                    child:  Text(' Sign up',
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