import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class GetOrdersUseCase {
  final OrderRepository _repository;

  GetOrdersUseCase(this._repository);

  Future<List<OrderEntity>> call() async {
    return await _repository.getOrders();
  }
}

class PlaceOrderUseCase {
  final OrderRepository _repository;

  PlaceOrderUseCase(this._repository);

  Future<OrderEntity> call(OrderEntity order) async {
    return await _repository.placeOrder(order);
  }
}
