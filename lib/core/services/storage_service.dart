import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // Auth Token
  Future<bool> saveToken(String token) async {
    return await _prefs.setString(AppConstants.keyAuthToken, token);
  }

  String? getToken() {
    return _prefs.getString(AppConstants.keyAuthToken);
  }

  Future<bool> clearToken() async {
    return await _prefs.remove(AppConstants.keyAuthToken);
  }

  // User Data JSON
  Future<bool> saveUserData(String userJson) async {
    return await _prefs.setString(AppConstants.keyUserData, userJson);
  }

  String? getUserData() {
    return _prefs.getString(AppConstants.keyUserData);
  }

  Future<bool> clearUserData() async {
    return await _prefs.remove(AppConstants.keyUserData);
  }

  // Cart Items JSON
  Future<bool> saveCartItems(String cartJson) async {
    return await _prefs.setString(AppConstants.keyCartItems, cartJson);
  }

  String? getCartItems() {
    return _prefs.getString(AppConstants.keyCartItems);
  }

  // Wishlist
  Future<bool> saveWishlist(List<String> ids) async {
    return await _prefs.setStringList(AppConstants.keyWishlistItems, ids);
  }

  List<String> getWishlist() {
    return _prefs.getStringList(AppConstants.keyWishlistItems) ?? [];
  }

  // Orders
  Future<bool> saveOrders(String ordersJson) async {
    return await _prefs.setString(AppConstants.keyOrders, ordersJson);
  }

  String? getOrders() {
    return _prefs.getString(AppConstants.keyOrders);
  }

  // Theme Mode ('dark', 'light', or 'system')
  Future<bool> saveThemeMode(String mode) async {
    return await _prefs.setString(AppConstants.keyThemeMode, mode);
  }

  String? getThemeMode() {
    return _prefs.getString(AppConstants.keyThemeMode);
  }

  // Clear session on logout
  Future<void> clearSession() async {
    await _prefs.remove(AppConstants.keyAuthToken);
    await _prefs.remove(AppConstants.keyUserData);
  }
}
