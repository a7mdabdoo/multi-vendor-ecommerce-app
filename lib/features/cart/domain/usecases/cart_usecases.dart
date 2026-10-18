import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class GetCartUseCase {
  final CartRepository _repository;

  GetCartUseCase(this._repository);

  Future<List<CartItemEntity>> call() async {
    return await _repository.getCartItems();
  }
}

class SaveCartUseCase {
  final CartRepository _repository;

  SaveCartUseCase(this._repository);

  Future<void> call(List<CartItemEntity> items) async {
    return await _repository.saveCartItems(items);
  }
}

class ClearCartUseCase {
  final CartRepository _repository;

  ClearCartUseCase(this._repository);

  Future<void> call() async {
    return await _repository.clearCart();
  }
}
