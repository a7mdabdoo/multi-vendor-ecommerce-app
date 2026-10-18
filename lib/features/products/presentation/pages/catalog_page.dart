import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';
import '../bloc/products_state.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/product_card.dart';
import '../widgets/search_bar_widget.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  String _sortOption = 'default';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog & Collections'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort_rounded),
            onSelected: (val) {
              setState(() => _sortOption = val);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'default', child: Text('Default Order')),
              const PopupMenuItem(value: 'price_low', child: Text('Price: Low to High')),
              const PopupMenuItem(value: 'price_high', child: Text('Price: High to Low')),
              const PopupMenuItem(value: 'rating', child: Text('Highest Rated')),
            ],
          ),
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              // Search Bar
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: SearchBarWidget(),
                ),
              ),

              // Category Pills
              if (state is ProductsLoadedState)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CategoryFilterBar(
                      categories: state.categories,
                      selectedSlug: state.selectedCategorySlug,
                      onCategorySelected: (slug) {
                        context.read<ProductsBloc>().add(SelectCategoryEvent(slug));
                      },
                    ),
                  ),
                ),

              // Filter info strip
              if (state is ProductsLoadedState)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Showing ${state.displayedProducts.length} items',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                          ),
                        ),
                        if (_sortOption != 'default')
                          InkWell(
                            onTap: () => setState(() => _sortOption = 'default'),
                            child: Text(
                              'Reset Sorting',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.primaryNeon : AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

              // Grid Content
              if (state is ProductsLoadingState)
                const SliverToBoxAdapter(
                  child: ShimmerProductGrid(itemCount: 8),
                )
              else if (state is ProductsLoadedState)
                _buildProductGrid(state.displayedProducts)
              else
                const SliverToBoxAdapter(
                  child: EmptyView(
                    title: 'Unable to Load Catalog',
                    message: 'Please check your connection and pull to refresh.',
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(List<ProductEntity> rawProducts) {
    if (rawProducts.isEmpty) {
      return const SliverToBoxAdapter(
        child: EmptyView(
          title: 'No Items Found',
          message: 'Try changing category or search criteria.',
        ),
      );
    }

    final products = List<ProductEntity>.from(rawProducts);
    if (_sortOption == 'price_low') {
      products.sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));
    } else if (_sortOption == 'price_high') {
      products.sort((a, b) => b.discountedPrice.compareTo(a.discountedPrice));
    } else if (_sortOption == 'rating') {
      products.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => ProductCard(product: products[index]),
          childCount: products.length,
        ),
      ),
    );
  }
}
