import 'shipping_address.dart';
import 'page_model.dart'; // We will create this next

/// Order status enumeration.
enum OrderStatus {
  cart,
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled;

  static OrderStatus fromString(String value) {
    return OrderStatus.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => OrderStatus.pending,
    );
  }
}

/// Represents an individual item in an order.
class OrderItem {
  final String templateId;
  final String templateName;
  final int quantity;
  final double unitPrice;
  final List<String> imageIds;

  const OrderItem({
    required this.templateId,
    required this.templateName,
    required this.quantity,
    required this.unitPrice,
    this.imageIds = const [],
  });

  double get totalPrice => quantity * unitPrice;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      templateId: json['template_id'] as String,
      templateName: json['template_name'] as String,
      quantity: json['quantity'] as int,
      unitPrice: (json['unit_price'] as num).toDouble(),
      imageIds: (json['image_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'template_id': templateId,
      'template_name': templateName,
      'quantity': quantity,
      'unit_price': unitPrice,
      'image_ids': imageIds,
    };
  }
}

/// Represents an order in the Pixovo system.
class Order {
  final String id;
  final String userId;
  final String templateId;
  final OrderStatus status;
  final double totalAmount;
  final String? currency;
  final List<OrderItem> items;
  final ShippingAddress? shippingAddress;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  // New fields
  final int numberOfPages;
  final String? size;
  final String? coverType;
  final String? paperQuality;
  final String? trackingNumber;
  final String? promoCode;
  final double promoDiscount;
  final double shippingCost;
  final double tax;
  final List<PageModel> pages;

  const Order({
    required this.id,
    required this.userId,
    required this.templateId,
    required this.status,
    required this.totalAmount,
    this.currency = 'USD',
    this.items = const [],
    this.shippingAddress,
    required this.createdAt,
    this.updatedAt,
    this.numberOfPages = 0,
    this.size,
    this.coverType,
    this.paperQuality,
    this.trackingNumber,
    this.promoCode,
    this.promoDiscount = 0.0,
    this.shippingCost = 0.0,
    this.tax = 0.0,
    this.pages = const [],
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      templateId: json['template_id'] as String,
      status: OrderStatus.fromString(json['status'] as String),
      totalAmount: (json['total_amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      shippingAddress: json['shipping_address'] != null
          ? ShippingAddress.fromJson(
              json['shipping_address'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      numberOfPages: json['number_of_pages'] as int? ?? 0,
      size: json['size'] as String?,
      coverType: json['cover_type'] as String?,
      paperQuality: json['paper_quality'] as String?,
      trackingNumber: json['tracking_number'] as String?,
      promoCode: json['promo_code'] as String?,
      promoDiscount: (json['promo_discount'] as num?)?.toDouble() ?? 0.0,
      shippingCost: (json['shipping_cost'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      pages: (json['pages'] as List<dynamic>?)
              ?.map((e) => PageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'template_id': templateId,
      'status': status.name,
      'total_amount': totalAmount,
      'currency': currency,
      'items': items.map((e) => e.toJson()).toList(),
      'shipping_address': shippingAddress?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'number_of_pages': numberOfPages,
      'size': size,
      'cover_type': coverType,
      'paper_quality': paperQuality,
      'tracking_number': trackingNumber,
      'promo_code': promoCode,
      'promo_discount': promoDiscount,
      'shipping_cost': shippingCost,
      'tax': tax,
      'pages': pages.map((e) => e.toJson()).toList(),
    };
  }

  Order copyWith({
    String? id,
    String? userId,
    String? templateId,
    OrderStatus? status,
    double? totalAmount,
    String? currency,
    List<OrderItem>? items,
    ShippingAddress? shippingAddress,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? numberOfPages,
    String? size,
    String? coverType,
    String? paperQuality,
    String? trackingNumber,
    String? promoCode,
    double? promoDiscount,
    double? shippingCost,
    double? tax,
    List<PageModel>? pages,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      templateId: templateId ?? this.templateId,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      currency: currency ?? this.currency,
      items: items ?? this.items,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      numberOfPages: numberOfPages ?? this.numberOfPages,
      size: size ?? this.size,
      coverType: coverType ?? this.coverType,
      paperQuality: paperQuality ?? this.paperQuality,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      promoCode: promoCode ?? this.promoCode,
      promoDiscount: promoDiscount ?? this.promoDiscount,
      shippingCost: shippingCost ?? this.shippingCost,
      tax: tax ?? this.tax,
      pages: pages ?? this.pages,
    );
  }
}
