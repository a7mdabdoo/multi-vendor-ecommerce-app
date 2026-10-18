import '../entities/vendor_entity.dart';
import '../repositories/vendor_repository.dart';

class GetFeaturedVendorsUseCase {
  final VendorRepository _repository;

  GetFeaturedVendorsUseCase(this._repository);

  Future<List<VendorEntity>> call() async {
    return await _repository.getFeaturedVendors();
  }
}
