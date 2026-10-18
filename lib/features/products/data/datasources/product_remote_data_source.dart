import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({int limit = 30, int skip = 0});
  Future<ProductModel> getProductDetails(int id);
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> searchProducts(String query);
  Future<List<ProductModel>> getProductsByCategory(String categorySlug);
  Future<List<ProductModel>> getProductsByVendor(String vendorId);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient _dioClient;
  List<ProductModel>? _inMemoryCache;

  ProductRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<ProductModel>> getProducts({int limit = 30, int skip = 0}) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.products,
        queryParameters: {'limit': limit, 'skip': skip},
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data['products'] is List) {
        final products = (data['products'] as List)
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList();
        _inMemoryCache = products;
        return products;
      }
      return [];
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException(message: 'Failed to fetch products: $e');
    }
  }

  @override
  Future<ProductModel> getProductDetails(int id) async {
    try {
      final response = await _dioClient.get('${ApiConstants.products}/$id');
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return ProductModel.fromJson(data);
      }
      throw const ServerException(message: 'Product not found');
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException(message: 'Failed to fetch product details: $e');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dioClient.get(ApiConstants.categories);
      final data = response.data;
      if (data is List) {
        return data.map((item) => CategoryModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException(message: 'Failed to fetch categories: $e');
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.productSearch,
        queryParameters: {'q': query},
      );
      final data = response.data;
      if (data is Map<String, dynamic> && data['products'] is List) {
        return (data['products'] as List)
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException(message: 'Failed to search products: $e');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String categorySlug) async {
    try {
      final response = await _dioClient.get('${ApiConstants.productsByCategory}/$categorySlug');
      final data = response.data;
      if (data is Map<String, dynamic> && data['products'] is List) {
        return (data['products'] as List)
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException(message: 'Failed to fetch products for category: $e');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByVendor(String vendorId) async {
    try {
      List<ProductModel> allProducts = _inMemoryCache ?? [];
      if (allProducts.isEmpty) {
        allProducts = await getProducts(limit: 100);
      }
      return allProducts.where((p) => p.vendor.id == vendorId).toList();
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException(message: 'Failed to fetch vendor products: $e');
    }
  }
}
