import '../config/api_config.dart';
import '../models/payment.dart';
import 'api_service.dart';

/// Handles payment processing operations.
class PaymentService {
  final ApiService _api = ApiService();

  /// Initiate a payment for an order.
  ///
  /// Returns a [Payment] object with a transaction ID and gateway details
  /// that can be used to redirect or show a payment UI.
  Future<Payment> initiatePayment({
    required String orderId,
    required PaymentMethod method,
    required double amount,
    String currency = 'INR',
  }) async {
    final response = await _api.post(
      ApiConfig.initiatePayment,
      data: {
        'order_id': orderId,
        'method': method.name,
        'amount': amount,
        'currency': currency,
      },
    );

    return Payment.fromJson(response.data as Map<String, dynamic>);
  }

  /// Verify a payment after gateway callback.
  ///
  /// The [transactionId] and [signature] are provided by the
  /// payment gateway after the user completes the payment flow.
  Future<Payment> verifyPayment({
    required String paymentId,
    required String transactionId,
    String? signature,
  }) async {
    final response = await _api.post(
      ApiConfig.verifyPayment,
      data: {
        'payment_id': paymentId,
        'transaction_id': transactionId,
        'signature': signature,
      },
    );

    return Payment.fromJson(response.data as Map<String, dynamic>);
  }

  /// Check the current status of a payment.
  Future<Payment> getPaymentStatus(String paymentId) async {
    final response =
        await _api.get('${ApiConfig.paymentStatus}/$paymentId');
    return Payment.fromJson(response.data as Map<String, dynamic>);
  }
}
