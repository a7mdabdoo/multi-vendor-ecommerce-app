class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://dummyjson.com';
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Endpoints
  static const String login = '/auth/login';
  static const String currentUser = '/auth/me';
  static const String products = '/products';
  static const String productSearch = '/products/search';
  static const String categories = '/products/categories';
  static const String productsByCategory = '/products/category';
}
