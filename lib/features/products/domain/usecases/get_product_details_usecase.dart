import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductDetailsUseCase {
  final ProductRepository _repository;

  GetProductDetailsUseCase(this._repository);

  Future<ProductEntity> call(int id) async {
    return await _repository.getProductDetails(id);
  }
}
