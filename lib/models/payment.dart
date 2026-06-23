/// Payment status enumeration.
enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  refunded;

  static PaymentStatus fromString(String value) {
    return PaymentStatus.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => PaymentStatus.pending,
    );
  }
}

/// Payment method enumeration.
enum PaymentMethod {
  card,
  upi,
  netBanking,
  wallet,
  cod;

  static PaymentMethod fromString(String value) {
    return PaymentMethod.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => PaymentMethod.card,
    );
  }
}

/// Represents a payment transaction.
class Payment {
  final String id;
  final String orderId;
  final double amount;
  final String currency;
  final PaymentStatus status;
  final PaymentMethod method;
  final String? transactionId;
  final DateTime? paidAt;

  const Payment({
    required this.id,
    required this.orderId,
    required this.amount,
    this.currency = 'INR',
    required this.status,
    required this.method,
    this.transactionId,
    this.paidAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'INR',
      status: PaymentStatus.fromString(json['status'] as String),
      method: PaymentMethod.fromString(json['method'] as String),
      transactionId: json['transaction_id'] as String?,
      paidAt: json['paid_at'] != null
          ? DateTime.parse(json['paid_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'amount': amount,
      'currency': currency,
      'status': status.name,
      'method': method.name,
      'transaction_id': transactionId,
      'paid_at': paidAt?.toIso8601String(),
    };
  }

  Payment copyWith({
    String? id,
    String? orderId,
    double? amount,
    String? currency,
    PaymentStatus? status,
    PaymentMethod? method,
    String? transactionId,
    DateTime? paidAt,
  }) {
    return Payment(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      method: method ?? this.method,
      transactionId: transactionId ?? this.transactionId,
      paidAt: paidAt ?? this.paidAt,
    );
  }
}
