import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_local_data_source.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource _localDataSource;

  OrderRepositoryImpl(this._localDataSource);

  @override
  Future<List<OrderEntity>> getOrders() async {
    try {
      return await _localDataSource.getOrders();
    } on CacheException catch (e) {
      throw CacheFailure(message: e.message);
    } catch (e) {
      throw CacheFailure(message: e.toString());
    }
  }

  @override
  Future<OrderEntity> placeOrder(OrderEntity order) async {
    try {
      final model = OrderModel.fromEntity(order);
      await _localDataSource.saveOrder(model);
      return model;
    } on CacheException catch (e) {
      throw CacheFailure(message: e.message);
    } catch (e) {
      throw CacheFailure(message: e.toString());
    }
  }
}
