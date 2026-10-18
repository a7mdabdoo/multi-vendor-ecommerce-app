class AppConstants {
  AppConstants._();

  static const String appName = 'Multi-Vendor E-Commerce';
  static const String appTagline = 'Curated Marketplace of Premium Brands';

  // Local Storage Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyUserData = 'user_data';
  static const String keyCartItems = 'cart_items';
  static const String keyWishlistItems = 'wishlist_items';
  static const String keyOrders = 'orders_history';
  static const String keyThemeMode = 'theme_mode';

  // Demo Credentials for Recruiters
  static const String demoUsername = 'emilys';
  static const String demoPassword = 'emilyspassword';
  static const String demoFullName = 'Emily Johnson';
  static const String demoEmail = 'emily.johnson@x.dummyjson.com';

  // UI Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration debounceDuration = Duration(milliseconds: 400);

  // Financial Defaults
  static const double taxRate = 0.08; // 8% tax
  static const double shippingFeePerVendor = 4.99;
  static const double freeShippingThreshold = 75.0;
}
