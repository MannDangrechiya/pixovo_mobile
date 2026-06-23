import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/order.dart';
import '../services/order_service.dart';

/// Order management state.
class OrderState {
  final List<Order> orders;
  final Order? currentOrder;
  final List<OrderItem> cartItems;
  final bool isLoading;
  final String? errorMessage;
  final int currentPage;
  final bool hasMore;

  const OrderState({
    this.orders = const [],
    this.currentOrder,
    this.cartItems = const [],
    this.isLoading = false,
    this.errorMessage,
    this.currentPage = 1,
    this.hasMore = true,
  });

  /// Total price of items currently in the cart.
  double get cartTotal =>
      cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  /// Number of items in the cart.
  int get cartItemCount => cartItems.length;

  OrderState copyWith({
    List<Order>? orders,
    Order? currentOrder,
    List<OrderItem>? cartItems,
    bool? isLoading,
    String? errorMessage,
    int? currentPage,
    bool? hasMore,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      currentOrder: currentOrder ?? this.currentOrder,
      cartItems: cartItems ?? this.cartItems,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// Manages orders, cart, and order flow.
class OrderNotifier extends StateNotifier<OrderState> {
  final OrderService _orderService;

  OrderNotifier(this._orderService) : super(const OrderState());

  // ── Cart Operations ────────────────────────────────────────────

  /// Add an item to the cart.
  void addToCart(OrderItem item) {
    state = state.copyWith(cartItems: [...state.cartItems, item]);
  }

  /// Remove an item from the cart by index.
  void removeFromCart(int index) {
    final updated = List<OrderItem>.from(state.cartItems)..removeAt(index);
    state = state.copyWith(cartItems: updated);
  }

  /// Clear the cart.
  void clearCart() {
    state = state.copyWith(cartItems: []);
  }

  // ── Order Operations ──────────────────────────────────────────

  /// Place an order from the current cart contents.
  Future<Order?> placeOrder({
    required String templateId,
    required String shippingAddressId,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final order = await _orderService.createOrder(
        templateId: templateId,
        items: state.cartItems,
        shippingAddressId: shippingAddressId,
      );
      state = state.copyWith(
        isLoading: false,
        currentOrder: order,
        cartItems: [],
        orders: [order, ...state.orders],
      );
      return order;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  /// Load the user's order history.
  Future<void> loadOrders() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final orders = await _orderService.getOrders(page: 1);
      state = state.copyWith(
        orders: orders,
        isLoading: false,
        currentPage: 1,
        hasMore: orders.length >= 10,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Load more orders (next page).
  Future<void> loadMoreOrders() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);
    try {
      final nextPage = state.currentPage + 1;
      final newOrders = await _orderService.getOrders(page: nextPage);
      state = state.copyWith(
        orders: [...state.orders, ...newOrders],
        isLoading: false,
        currentPage: nextPage,
        hasMore: newOrders.length >= 10,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Fetch a specific order detail.
  Future<void> loadOrderDetail(String orderId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final order = await _orderService.getOrderDetail(orderId);
      state = state.copyWith(
        currentOrder: order,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Cancel an order.
  Future<void> cancelOrder(String orderId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final cancelled = await _orderService.cancelOrder(orderId);
      final updatedOrders = state.orders.map((o) {
        return o.id == orderId ? cancelled : o;
      }).toList();

      state = state.copyWith(
        orders: updatedOrders,
        currentOrder:
            state.currentOrder?.id == orderId ? cancelled : state.currentOrder,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

/// Provider for OrderService.
final orderServiceProvider = Provider<OrderService>((ref) {
  return OrderService();
});

/// Provider for OrderNotifier.
final orderProvider =
    StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  return OrderNotifier(ref.read(orderServiceProvider));
});
