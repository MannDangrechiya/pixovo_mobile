/// API configuration constants for Pixovo Mobile.
class ApiConfig {
  ApiConfig._();

  /// Base URL for the Pixovo API.
  /// Set this to https://pixovo.com/api/front-end to keep route strings clean.
  static const String baseUrl = 'https://pixovo.com/api/front-end';

  /// Request timeout duration in milliseconds.
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
  static const int sendTimeout = 30000;

  // ── Auth Endpoints ──────────────────────────────────────────────
  static const String login = '/login';
  static const String register = '/register';
  static const String socialLogin = '/social-login';
  static const String facebookLogin = '/facebook-login';
  static const String guestRegister = '/guest-register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String changePassword = '/change_password';

  // ── Profile Endpoints ─────────────────────────────────────────────
  static const String userProfile = '/profile/detail';
  static const String updateProfile = '/profile/update';

  // ── Template Endpoints ─────────────────────────────────────────
  static const String templatesList = '/template/list';
  static const String templateDetail = '/template/detail';
  static const String allTemplatesList = '/template/all-list';

  // ── Image Endpoints ────────────────────────────────────────────
  static const String addImage = '/image/add';
  static const String tempAddImage = '/image/temp-add';
  static const String imageList = '/image/list';
  static const String imageDetail = '/image/detail';
  static const String storeFacebookImage = '/image/store-facebook';
  static const String deleteImage = '/image/delete';
  static const String imageAiText = '/image/image-ai-text';

  // ── Order & Cart Endpoints ────────────────────────────────────────────
  static const String storeOrder = '/order/store';
  static const String updateOrder = '/order/update';
  static const String orderDetail = '/order/detail';
  static const String orderList = '/order/list';
  static const String cart = '/order/user-order-cart';
  static const String deleteCartItem = '/order/user-order-cart-delete';
  static const String applyPromotion = '/order/apply-promotion';
  static const String createPdf = '/order/pdf-create';

  // ── Payment Endpoints ──────────────────────────────────────────
  static const String storePayment = '/payment/store';

  // ── Shipping Endpoints ─────────────────────────────────────────
  static const String shippingAddressesList = '/shipping-address/list';
  static const String addAddress = '/shipping-address/store';
  static const String updateAddress =
      '/shipping-address/update'; // append /{id}
  static const String deleteAddress =
      '/shipping-address/delete'; // append /{id}
}
