import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../../vendors/presentation/bloc/vendor_bloc.dart';
import '../../../vendors/presentation/bloc/vendor_event.dart';
import '../../../vendors/presentation/bloc/vendor_state.dart';
import '../../../vendors/presentation/widgets/vendor_card.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';
import '../bloc/products_state.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/featured_carousel.dart';
import '../widgets/product_card.dart';
import '../widgets/search_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final productsBloc = context.read<ProductsBloc>();
    if (productsBloc.state is! ProductsLoadedState) {
      productsBloc.add(const FetchProductsEvent());
    }
    final vendorBloc = context.read<VendorBloc>();
    if (vendorBloc.state is! VendorLoadedState) {
      vendorBloc.add(const FetchFeaturedVendorsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: isDark ? AppColors.primaryNeon : AppColors.primary,
          onRefresh: () async {
            context.read<ProductsBloc>().add(const FetchProductsEvent(refresh: true));
            context.read<VendorBloc>().add(const FetchFeaturedVendorsEvent());
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // 1. Top Header Bar (User Avatar, Greeting, Cart Badge)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Row(
                    children: [
                      // User Avatar
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, authState) {
                          String initial = 'G';
                          String name = 'Guest';
                          if (authState is AuthenticatedState) {
                            name = authState.user.firstName;
                            if (name.isNotEmpty) initial = name[0].toUpperCase();
                          }
                          return CircleAvatar(
                            radius: 20,
                            backgroundColor: (isDark ? AppColors.primaryNeon : AppColors.primary).withOpacity(0.15),
                            child: Text(
                              initial,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.primaryNeon : AppColors.primary,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),

                      // Greetings
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, authState) {
                                final name = authState is AuthenticatedState ? authState.user.firstName : 'Shopper';
                                return Text(
                                  'Hello, $name 👋',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 13,
                                  color: isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  'Multi-Vendor Global Marketplace',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Cart Icon with Live Badge
                      BlocBuilder<CartBloc, CartState>(
                        builder: (context, cartState) {
                          int count = 0;
                          if (cartState is CartLoadedState) {
                            count = cartState.cart.totalItemCount;
                          }

                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.shopping_bag_outlined, size: 26),
                                onPressed: () => context.push('/cart'),
                              ),
                              if (count > 0)
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: AppColors.error,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                                    child: Center(
                                      child: Text(
                                        '$count',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Search Bar
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: SearchBarWidget(),
                ),
              ),

              // 3. Featured Promotional Deals Carousel
              SliverToBoxAdapter(
                child: BlocBuilder<ProductsBloc, ProductsState>(
                  builder: (context, state) {
                    if (state is ProductsLoadedState && state.searchQuery.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: FeaturedBannersCarousel(products: state.featuredBanners),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),

              // 4. Featured Vendors / Stores Section
              SliverToBoxAdapter(
                child: BlocBuilder<ProductsBloc, ProductsState>(
                  builder: (context, prodState) {
                    if (prodState is ProductsLoadedState && prodState.searchQuery.isNotEmpty) {
                      return const SizedBox.shrink(); // Hide vendors when actively searching products
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.verified_rounded,
                                    size: 18,
                                    color: isDark ? AppColors.primaryNeon : AppColors.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Featured Stores & Vendors',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () => context.push('/vendors'),
                                child: Text(
                                  'View All',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.primaryNeon : AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        BlocBuilder<VendorBloc, VendorState>(
                          builder: (context, state) {
                            if (state is VendorLoadingState) {
                              return const ShimmerVendorList();
                            }
                            if (state is VendorLoadedState) {
                              final vendors = state.featuredVendors;
                              return SizedBox(
                                height: 165,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  itemCount: vendors.length,
                                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                                  itemBuilder: (context, index) {
                                    return VendorCard(vendor: vendors[index]);
                                  },
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),

              // 5. Category Filtering Bar
              SliverToBoxAdapter(
                child: BlocBuilder<ProductsBloc, ProductsState>(
                  builder: (context, state) {
                    if (state is ProductsLoadedState) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 18, bottom: 12),
                        child: CategoryFilterBar(
                          categories: state.categories,
                          selectedSlug: state.selectedCategorySlug,
                          onCategorySelected: (slug) {
                            context.read<ProductsBloc>().add(SelectCategoryEvent(slug));
                          },
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),

              // 6. Section Header
              SliverToBoxAdapter(
                child: BlocBuilder<ProductsBloc, ProductsState>(
                  builder: (context, state) {
                    if (state is ProductsLoadedState) {
                      final title = state.searchQuery.isNotEmpty
                          ? 'Search Results for "${state.searchQuery}"'
                          : state.selectedCategorySlug == 'all'
                              ? 'Curated Products'
                              : 'Category: ${state.selectedCategorySlug}';

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              '${state.displayedProducts.length} items',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),

              // 7. Products Grid / Shimmer / Error View
              BlocBuilder<ProductsBloc, ProductsState>(
                builder: (context, state) {
                  if (state is ProductsLoadingState) {
                    return const SliverToBoxAdapter(
                      child: ShimmerProductGrid(),
                    );
                  }

                  if (state is ProductsLoadedState) {
                    if (state.displayedProducts.isEmpty) {
                      return SliverToBoxAdapter(
                        child: EmptyView(
                          title: 'No Products Match',
                          message: 'Try adjusting your search keywords or browsing other categories.',
                          buttonText: 'Reset Filters',
                          onButtonPressed: () {
                            context.read<ProductsBloc>().add(const ClearSearchEvent());
                            context.read<ProductsBloc>().add(const SelectCategoryEvent('all'));
                          },
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product = state.displayedProducts[index];
                            return ProductCard(product: product);
                          },
                          childCount: state.displayedProducts.length,
                        ),
                      ),
                    );
                  }

                  if (state is ProductsErrorState) {
                    return SliverToBoxAdapter(
                      child: ErrorView(
                        message: state.message,
                        onRetry: () => context.read<ProductsBloc>().add(const FetchProductsEvent(refresh: true)),
                      ),
                    );
                  }

                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
