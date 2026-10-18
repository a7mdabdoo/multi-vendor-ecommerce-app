import '../entities/category_entity.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts({int limit = 30, int skip = 0});
  Future<ProductEntity> getProductDetails(int id);
  Future<List<CategoryEntity>> getCategories();
  Future<List<ProductEntity>> searchProducts(String query);
  Future<List<ProductEntity>> getProductsByCategory(String categorySlug);
  Future<List<ProductEntity>> getProductsByVendor(String vendorId);
}
