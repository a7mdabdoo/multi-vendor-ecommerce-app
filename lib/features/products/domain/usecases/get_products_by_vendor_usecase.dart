import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsByVendorUseCase {
  final ProductRepository _repository;

  GetProductsByVendorUseCase(this._repository);

  Future<List<ProductEntity>> call(String vendorId) async {
    return await _repository.getProductsByVendor(vendorId);
  }
}
