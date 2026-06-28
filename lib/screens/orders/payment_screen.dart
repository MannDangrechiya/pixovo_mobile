import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../config/routes.dart';
import '../../services/payment_service.dart';
import 'package:go_router/go_router.dart';

/// Payment screen - initiates Razorpay checkout and handles callbacks.
class PaymentScreen extends ConsumerStatefulWidget {
  final String orderId;
  final double amount;
  final String currency;

  const PaymentScreen({
    super.key,
    required this.orderId,
    required this.amount,
    this.currency = 'INR',
  });

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  late Razorpay _razorpay;
  final PaymentService _paymentService = PaymentService();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
    // Auto-open Razorpay when screen loads.
    WidgetsBinding.instance.addPostFrameCallback((_) => _openCheckout());
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _openCheckout() {
    final options = {
      'key': 'YOUR_RAZORPAY_KEY_ID', // TODO: Replace with actual key from env
      'amount': (widget.amount * 100).toInt(), // In paise
      'currency': widget.currency,
      'name': 'Pixovo',
      'description': 'Photo Book Order #${widget.orderId}',
      'order_id': widget.orderId,
      'prefill': {
        'contact': '',
        'email': '',
      },
      'theme': {
        'color': '#6750A4', // Material You primary seed color
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      _showError('Failed to open payment: $e');
    }
  }

  Future<void> _onPaymentSuccess(PaymentSuccessResponse response) async {
    if (!mounted) return;
    setState(() => _isProcessing = true);

    try {
      await _paymentService.verifyPayment(
        paymentId: response.paymentId ?? '',
        transactionId: response.paymentId ?? '',
        signature: response.signature,
      );

      if (!mounted) return;
      context.go('${AppRoutes.thankYou}?orderId=${widget.orderId}');
    } catch (e) {
      if (!mounted) return;
      _showError('Payment verification failed. Contact support.');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _onPaymentError(PaymentFailureResponse response) {
    if (!mounted) return;
    _showError(
      response.message ?? 'Payment failed. Please try again.',
    );
  }

  void _onExternalWallet(ExternalWalletResponse response) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('External wallet selected: ${response.walletName}'),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: _openCheckout,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isProcessing) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 24),
                Text(
                  'Verifying payment...',
                  style: theme.textTheme.titleMedium,
                ),
              ] else ...[
                Icon(
                  Icons.payment,
                  size: 80,
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 24),
                Text(
                  'Payment Gateway',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Amount: ${widget.currency} ${widget.amount.toStringAsFixed(2)}',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _openCheckout,
                    child: const Text('Open Payment'),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
