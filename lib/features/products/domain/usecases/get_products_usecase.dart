import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository _repository;

  GetProductsUseCase(this._repository);

  Future<List<ProductEntity>> call({int limit = 30, int skip = 0}) async {
    return await _repository.getProducts(limit: limit, skip: skip);
  }
}
