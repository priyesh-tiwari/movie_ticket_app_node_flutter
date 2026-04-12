import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:movie_flutter_app/main_screen.dart';
import 'package:movie_flutter_app/screens/splash/splash_screen.dart';
import 'constants/app_constants.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Stripe initialize — same as RN ka <StripeProvider publishableKey=...>
  Stripe.publishableKey = 'pk_test_51QpHeaK9TNgWmqYBWEwqYcX6h1SgcZsg2cklvNuIBI7LWGxTQ5EZIduxGrK4uYR09cBS5dwzpejaeX48OlmeN1Ws001mk04jDh';
  await Stripe.instance.applySettings();

  runApp(const ProviderScope(child: CineMaxApp()));
}

class CineMaxApp extends ConsumerStatefulWidget {
  const CineMaxApp({super.key});

  @override
  ConsumerState<CineMaxApp> createState() => _CineMaxAppState();
}

class _CineMaxAppState extends ConsumerState<CineMaxApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // iPhone 14 base size — RN jaisa
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => MaterialApp(
        title: 'CineMax',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authProvider).isLoggedIn;
    return isLoggedIn ? const MainScreen() : const LoginScreen();
  }
}