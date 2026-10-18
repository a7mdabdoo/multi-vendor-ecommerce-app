import 'dart:convert';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/storage_service.dart';
import '../models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> saveCartItems(List<CartItemModel> items);
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final StorageService _storageService;

  CartLocalDataSourceImpl(this._storageService);

  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final jsonString = _storageService.getCartItems();
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> list = jsonDecode(jsonString) as List<dynamic>;
        return list.map((item) => CartItemModel.fromJson(item as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      throw CacheException(message: 'Failed to load cart items from cache: $e');
    }
  }

  @override
  Future<void> saveCartItems(List<CartItemModel> items) async {
    try {
      final jsonString = jsonEncode(items.map((e) => e.toJson()).toList());
      await _storageService.saveCartItems(jsonString);
    } catch (e) {
      throw CacheException(message: 'Failed to save cart items to cache: $e');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await _storageService.saveCartItems('[]');
    } catch (e) {
      throw CacheException(message: 'Failed to clear cart: $e');
    }
  }
}
