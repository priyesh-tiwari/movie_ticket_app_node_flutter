import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_flutter_app/screens/receipt/receipt_screen.dart';
import '../../constants/app_constants.dart';
import '../../providers/payment_provider.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final String movieId;
  final String theaterId;
  final String screenId;
  final String showtimeId;
  final List<dynamic> selectedSeats;
  final double totalAmount;

  const PaymentScreen({
    super.key,
    required this.movieId,
    required this.theaterId,
    required this.screenId,
    required this.showtimeId,
    required this.selectedSeats,
    required this.totalAmount,
  });

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {

  @override
  void initState() {
    super.initState();
    // same as useEffect(() => { handlePayment() }, [])
    WidgetsBinding.instance.addPostFrameCallback((_) => _handlePayment());
  }

  Future<void> _handlePayment() async {
    final success = await ref.read(paymentProvider.notifier).makePayment(
      amount: widget.totalAmount,
      showtimeId: widget.showtimeId,
      selectedSeats: widget.selectedSeats,
      theaterId: widget.theaterId,
      screenId: widget.screenId,
      movieId: widget.movieId,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ReceiptScreen(
            movieId: widget.movieId,
            theaterId: widget.theaterId,
            showtimeId: widget.showtimeId,
            selectedSeats: widget.selectedSeats,
            totalAmount: widget.totalAmount,
          ),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paymentProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state.isLoading) ...[
              CircularProgressIndicator(color: AppColors.primary),
              SizedBox(height: AppSpacing.md),
              Text(
                'Processing payment...',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: AppFontSize.md,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Please do not close the app',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppFontSize.sm,
                ),
              ),
            ],
            if (state.error != null)
              Text(
                state.error!,
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: AppFontSize.sm,
                ),
              ),
          ],
        ),
      ),
    );
  }
}