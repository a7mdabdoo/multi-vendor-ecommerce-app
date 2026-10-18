import 'dart:convert';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/storage_service.dart';
import '../models/order_model.dart';

abstract class OrderLocalDataSource {
  Future<List<OrderModel>> getOrders();
  Future<void> saveOrder(OrderModel order);
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  final StorageService _storageService;

  OrderLocalDataSourceImpl(this._storageService);

  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      final jsonString = _storageService.getOrders();
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> list = jsonDecode(jsonString) as List<dynamic>;
        return list.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      throw CacheException(message: 'Failed to retrieve orders: $e');
    }
  }

  @override
  Future<void> saveOrder(OrderModel order) async {
    try {
      final existingOrders = await getOrders();
      existingOrders.insert(0, order);
      final jsonString = jsonEncode(existingOrders.map((e) => e.toJson()).toList());
      await _storageService.saveOrders(jsonString);
    } catch (e) {
      throw CacheException(message: 'Failed to persist order: $e');
    }
  }
}
