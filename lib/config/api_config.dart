/// API configuration constants for Pixovo Mobile.
class ApiConfig {
  ApiConfig._();

  /// Base URL for the Pixovo API.
  static const String baseUrl = 'https://api.pixovo.com/v1';

  /// Request timeout duration in milliseconds.
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
  static const int sendTimeout = 30000;

  // ── Auth Endpoints ──────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // ── User Endpoints ─────────────────────────────────────────────
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile';

  // ── Template Endpoints ─────────────────────────────────────────
  static const String templates = '/templates';
  static const String templateDetail = '/templates'; // append /{id}
  static const String templateCategories = '/templates/categories';

  // ── Image Endpoints ────────────────────────────────────────────
  static const String uploadImage = '/images/upload';
  static const String userImages = '/images';
  static const String deleteImage = '/images'; // append /{id}

  // ── Order Endpoints ────────────────────────────────────────────
  static const String orders = '/orders';
  static const String orderDetail = '/orders'; // append /{id}
  static const String createOrder = '/orders';
  static const String cancelOrder = '/orders'; // append /{id}/cancel

  // ── Payment Endpoints ──────────────────────────────────────────
  static const String initiatePayment = '/payments/initiate';
  static const String verifyPayment = '/payments/verify';
  static const String paymentStatus = '/payments'; // append /{id}

  // ── Shipping Endpoints ─────────────────────────────────────────
  static const String shippingAddresses = '/user/addresses';
  static const String addAddress = '/user/addresses';
  static const String updateAddress = '/user/addresses'; // append /{id}
  static const String deleteAddress = '/user/addresses'; // append /{id}
}
