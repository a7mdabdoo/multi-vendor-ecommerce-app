import '../entities/category_entity.dart';
import '../repositories/product_repository.dart';

class GetCategoriesUseCase {
  final ProductRepository _repository;

  GetCategoriesUseCase(this._repository);

  Future<List<CategoryEntity>> call() async {
    return await _repository.getCategories();
  }
}
