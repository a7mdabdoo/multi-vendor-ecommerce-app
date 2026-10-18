import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource _localDataSource;

  CartRepositoryImpl(this._localDataSource);

  @override
  Future<List<CartItemEntity>> getCartItems() async {
    try {
      return await _localDataSource.getCartItems();
    } on CacheException catch (e) {
      throw CacheFailure(message: e.message);
    } catch (e) {
      throw CacheFailure(message: e.toString());
    }
  }

  @override
  Future<void> saveCartItems(List<CartItemEntity> items) async {
    try {
      final models = items.map((e) => CartItemModel.fromEntity(e)).toList();
      await _localDataSource.saveCartItems(models);
    } on CacheException catch (e) {
      throw CacheFailure(message: e.message);
    } catch (e) {
      throw CacheFailure(message: e.toString());
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await _localDataSource.clearCart();
    } on CacheException catch (e) {
      throw CacheFailure(message: e.message);
    } catch (e) {
      throw CacheFailure(message: e.toString());
    }
  }
}
