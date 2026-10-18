import '../entities/vendor_entity.dart';

abstract class VendorRepository {
  Future<List<VendorEntity>> getFeaturedVendors();
  Future<VendorEntity> getVendorDetails(String vendorId);
}
