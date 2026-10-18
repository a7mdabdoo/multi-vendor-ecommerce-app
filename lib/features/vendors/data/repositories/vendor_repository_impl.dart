import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/vendor_entity.dart';
import '../../domain/repositories/vendor_repository.dart';
import '../datasources/vendor_remote_data_source.dart';

class VendorRepositoryImpl implements VendorRepository {
  final VendorRemoteDataSource _remoteDataSource;

  VendorRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<VendorEntity>> getFeaturedVendors() async {
    try {
      return await _remoteDataSource.getFeaturedVendors();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message, statusCode: e.statusCode);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<VendorEntity> getVendorDetails(String vendorId) async {
    try {
      return await _remoteDataSource.getVendorDetails(vendorId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message, statusCode: e.statusCode);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
