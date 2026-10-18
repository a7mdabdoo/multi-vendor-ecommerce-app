import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_products_by_category_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/search_products_usecase.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProductsUseCase _getProductsUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final SearchProductsUseCase _searchProductsUseCase;
  final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;

  ProductsBloc({
    required GetProductsUseCase getProductsUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
    required SearchProductsUseCase searchProductsUseCase,
    required GetProductsByCategoryUseCase getProductsByCategoryUseCase,
  })  : _getProductsUseCase = getProductsUseCase,
        _getCategoriesUseCase = getCategoriesUseCase,
        _searchProductsUseCase = searchProductsUseCase,
        _getProductsByCategoryUseCase = getProductsByCategoryUseCase,
        super(const ProductsInitialState()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<SelectCategoryEvent>(_onSelectCategory);
    on<SearchProductsEvent>(_onSearchProducts);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onFetchProducts(FetchProductsEvent event, Emitter<ProductsState> emit) async {
    if (state is! ProductsLoadedState || event.refresh) {
      emit(const ProductsLoadingState());
    }

    try {
      final results = await Future.wait([
        _getProductsUseCase(limit: 50),
        _getCategoriesUseCase(),
      ]);

      final products = results[0] as List<ProductEntity>;
      final rawCategories = results[1] as List<CategoryEntity>;

      final categories = [
        const CategoryEntity(
          slug: 'all',
          name: 'All Items',
          url: '',
          iconName: 'category',
        ),
        ...rawCategories,
      ];

      emit(ProductsLoadedState(
        allProducts: products,
        displayedProducts: products,
        categories: categories,
        selectedCategorySlug: 'all',
      ));
    } catch (e) {
      emit(ProductsErrorState(e.toString()));
    }
  }

  Future<void> _onSelectCategory(SelectCategoryEvent event, Emitter<ProductsState> emit) async {
    if (state is ProductsLoadedState) {
      final currentState = state as ProductsLoadedState;
      if (currentState.selectedCategorySlug == event.categorySlug) return;

      if (event.categorySlug == 'all') {
        emit(currentState.copyWith(
          selectedCategorySlug: 'all',
          displayedProducts: currentState.allProducts,
          searchQuery: '',
          isSearching: false,
        ));
        return;
      }

      emit(currentState.copyWith(
        selectedCategorySlug: event.categorySlug,
        searchQuery: '',
        isSearching: true,
      ));

      try {
        final categoryProducts = await _getProductsByCategoryUseCase(event.categorySlug);
        emit(currentState.copyWith(
          selectedCategorySlug: event.categorySlug,
          displayedProducts: categoryProducts,
          isSearching: false,
        ));
      } catch (_) {
        // Fallback: local filter
        final localFiltered = currentState.allProducts
            .where((p) => p.category.toLowerCase() == event.categorySlug.toLowerCase())
            .toList();
        emit(currentState.copyWith(
          selectedCategorySlug: event.categorySlug,
          displayedProducts: localFiltered,
          isSearching: false,
        ));
      }
    }
  }

  Future<void> _onSearchProducts(SearchProductsEvent event, Emitter<ProductsState> emit) async {
    if (state is ProductsLoadedState) {
      final currentState = state as ProductsLoadedState;
      final q = event.query.trim();

      if (q.isEmpty) {
        emit(currentState.copyWith(
          searchQuery: '',
          displayedProducts: currentState.allProducts,
          isSearching: false,
        ));
        return;
      }

      emit(currentState.copyWith(
        searchQuery: q,
        isSearching: true,
      ));

      try {
        final searchResults = await _searchProductsUseCase(q);
        emit(currentState.copyWith(
          searchQuery: q,
          displayedProducts: searchResults,
          isSearching: false,
        ));
      } catch (_) {
        final filtered = currentState.allProducts.where((p) {
          final query = q.toLowerCase();
          return p.title.toLowerCase().contains(query) ||
              p.category.toLowerCase().contains(query) ||
              p.vendor.name.toLowerCase().contains(query) ||
              (p.brand != null && p.brand!.toLowerCase().contains(query));
        }).toList();

        emit(currentState.copyWith(
          searchQuery: q,
          displayedProducts: filtered,
          isSearching: false,
        ));
      }
    }
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<ProductsState> emit) {
    if (state is ProductsLoadedState) {
      final currentState = state as ProductsLoadedState;
      emit(currentState.copyWith(
        searchQuery: '',
        displayedProducts: currentState.allProducts,
        isSearching: false,
      ));
    }
  }
}
