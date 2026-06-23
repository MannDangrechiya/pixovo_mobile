import '../config/api_config.dart';
import '../models/order.dart';
import 'api_service.dart';

/// Handles order CRUD operations.
class OrderService {
  final ApiService _api = ApiService();

  /// Create a new order.
  Future<Order> createOrder({
    required String templateId,
    required List<OrderItem> items,
    required String shippingAddressId,
  }) async {
    final response = await _api.post(
      ApiConfig.storeOrder,
      data: {
        'template_id': templateId,
        'items': items.map((e) => e.toJson()).toList(),
        'shipping_address_id': shippingAddressId,
      },
    );

    return Order.fromJson(response.data as Map<String, dynamic>);
  }

  /// Fetch a paginated list of the user's orders.
  Future<List<Order>> getOrders({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (status != null) queryParams['status'] = status;

    final response = await _api.get(
      ApiConfig.orderList,
      queryParameters: queryParams,
    );

    final list = response.data['orders'] as List<dynamic>;
    return list.map((e) => Order.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Fetch a single order by its ID.
  Future<Order> getOrderDetail(String orderId) async {
    final response = await _api.get('${ApiConfig.orderDetail}/$orderId');
    return Order.fromJson(response.data as Map<String, dynamic>);
  }

  /// Cancel an existing order.
  Future<Order> cancelOrder(String orderId) async {
    final response =
        await _api.post('${ApiConfig.updateOrder}/$orderId/cancel');
    return Order.fromJson(response.data as Map<String, dynamic>);
  }
}
