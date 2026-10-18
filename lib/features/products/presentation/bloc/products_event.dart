import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

class FetchProductsEvent extends ProductsEvent {
  final bool refresh;

  const FetchProductsEvent({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

class SelectCategoryEvent extends ProductsEvent {
  final String categorySlug;

  const SelectCategoryEvent(this.categorySlug);

  @override
  List<Object?> get props => [categorySlug];
}

class SearchProductsEvent extends ProductsEvent {
  final String query;

  const SearchProductsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearSearchEvent extends ProductsEvent {
  const ClearSearchEvent();
}
