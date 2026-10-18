import 'package:equatable/equatable.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductsInitialState extends ProductsState {
  const ProductsInitialState();
}

class ProductsLoadingState extends ProductsState {
  const ProductsLoadingState();
}

class ProductsLoadedState extends ProductsState {
  final List<ProductEntity> allProducts;
  final List<ProductEntity> displayedProducts;
  final List<CategoryEntity> categories;
  final String selectedCategorySlug;
  final String searchQuery;
  final bool isSearching;

  const ProductsLoadedState({
    required this.allProducts,
    required this.displayedProducts,
    required this.categories,
    this.selectedCategorySlug = 'all',
    this.searchQuery = '',
    this.isSearching = false,
  });

  List<ProductEntity> get featuredBanners {
    final list = allProducts.where((p) => p.discountPercentage >= 12).toList();
    return list.isNotEmpty ? list.take(5).toList() : allProducts.take(3).toList();
  }

  ProductsLoadedState copyWith({
    List<ProductEntity>? allProducts,
    List<ProductEntity>? displayedProducts,
    List<CategoryEntity>? categories,
    String? selectedCategorySlug,
    String? searchQuery,
    bool? isSearching,
  }) {
    return ProductsLoadedState(
      allProducts: allProducts ?? this.allProducts,
      displayedProducts: displayedProducts ?? this.displayedProducts,
      categories: categories ?? this.categories,
      selectedCategorySlug: selectedCategorySlug ?? this.selectedCategorySlug,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object?> get props => [
        allProducts,
        displayedProducts,
        categories,
        selectedCategorySlug,
        searchQuery,
        isSearching,
      ];
}

class ProductsErrorState extends ProductsState {
  final String message;

  const ProductsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
