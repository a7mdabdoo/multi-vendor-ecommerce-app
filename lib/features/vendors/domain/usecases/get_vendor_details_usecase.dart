import '../entities/vendor_entity.dart';
import '../repositories/vendor_repository.dart';

class GetVendorDetailsUseCase {
  final VendorRepository _repository;

  GetVendorDetailsUseCase(this._repository);

  Future<VendorEntity> call(String vendorId) async {
    return await _repository.getVendorDetails(vendorId);
  }
}
