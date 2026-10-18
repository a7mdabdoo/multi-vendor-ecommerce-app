import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class SearchProductsUseCase {
  final ProductRepository _repository;

  SearchProductsUseCase(this._repository);

  Future<List<ProductEntity>> call(String query) async {
    return await _repository.searchProducts(query);
  }
}
