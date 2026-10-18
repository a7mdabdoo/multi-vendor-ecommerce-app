import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsByCategoryUseCase {
  final ProductRepository _repository;

  GetProductsByCategoryUseCase(this._repository);

  Future<List<ProductEntity>> call(String categorySlug) async {
    return await _repository.getProductsByCategory(categorySlug);
  }
}
