import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/template_selection_screen.dart';
import '../screens/home/template_detail_screen.dart';
import '../screens/editor/image_upload_screen.dart';
import '../screens/editor/image_dashboard_screen.dart';
import '../screens/editor/image_editor_screen.dart';
import '../screens/editor/book_preview_screen.dart';
import '../screens/orders/cart_screen.dart';
import '../screens/orders/order_list_screen.dart';
import '../screens/orders/order_detail_screen.dart';
import '../screens/orders/checkout_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/saved_addresses_screen.dart';
import '../screens/orders/payment_screen.dart';
import '../screens/thank_you_screen.dart';

/// Named route constants for type-safe navigation.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String templateDetail = '/template/detail';
  static const String imageUpload = '/editor/upload';
  static const String imageDashboard = '/editor/dashboard';
  static const String imageEditor = '/editor/edit';
  static const String bookPreview = '/editor/preview';
  static const String cart = '/orders/cart';
  static const String orderList = '/orders';
  static const String orderDetail = '/orders/detail';
  static const String checkout = '/orders/checkout';
  static const String profile = '/profile';
  static const String savedAddresses = '/profile/addresses';
  static const String payment = '/orders/payment';
  static const String thankYou = '/thank-you';
}

/// GoRouter provider for the app.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const TemplateSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.templateDetail,
        name: 'templateDetail',
        builder: (context, state) {
          final templateId = state.uri.queryParameters['templateId'] ?? '';
          return TemplateDetailScreen(templateId: templateId);
        },
      ),
      GoRoute(
        path: AppRoutes.imageUpload,
        name: 'imageUpload',
        builder: (context, state) {
          final templateId = state.uri.queryParameters['templateId'] ?? '';
          return ImageUploadScreen(templateId: templateId);
        },
      ),
      GoRoute(
        path: AppRoutes.imageDashboard,
        name: 'imageDashboard',
        builder: (context, state) {
          final templateId = state.uri.queryParameters['templateId'] ?? '';
          return ImageDashboardScreen(templateId: templateId);
        },
      ),
      GoRoute(
        path: AppRoutes.imageEditor,
        name: 'imageEditor',
        builder: (context, state) {
          final imageId = state.uri.queryParameters['imageId'] ?? '';
          return ImageEditorScreen(imageId: imageId);
        },
      ),
      GoRoute(
        path: AppRoutes.bookPreview,
        name: 'bookPreview',
        builder: (context, state) {
          final templateId = state.uri.queryParameters['templateId'] ?? '';
          return BookPreviewScreen(templateId: templateId);
        },
      ),
      GoRoute(
        path: AppRoutes.cart,
        name: 'cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: AppRoutes.orderList,
        name: 'orderList',
        builder: (context, state) => const OrderListScreen(),
      ),
      GoRoute(
        path: AppRoutes.orderDetail,
        name: 'orderDetail',
        builder: (context, state) {
          final orderId = state.uri.queryParameters['orderId'] ?? '';
          return OrderDetailScreen(orderId: orderId);
        },
      ),
      GoRoute(
        path: AppRoutes.checkout,
        name: 'checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.savedAddresses,
        name: 'savedAddresses',
        builder: (context, state) => const SavedAddressesScreen(),
      ),
      GoRoute(
        path: AppRoutes.payment,
        name: 'payment',
        builder: (context, state) {
          final orderId = state.uri.queryParameters['orderId'] ?? '';
          final amount =
              double.tryParse(state.uri.queryParameters['amount'] ?? '0') ??
                  0.0;
          return PaymentScreen(orderId: orderId, amount: amount);
        },
      ),
      GoRoute(
        path: AppRoutes.thankYou,
        name: 'thankYou',
        builder: (context, state) {
          final orderId = state.uri.queryParameters['orderId'] ?? '';
          return ThankYouScreen(orderId: orderId);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
