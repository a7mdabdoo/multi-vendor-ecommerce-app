import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../../../../core/widgets/rating_badge.dart';
import '../../../products/presentation/bloc/products_bloc.dart';
import '../../../products/presentation/bloc/products_state.dart';
import '../../../products/presentation/widgets/product_card.dart';
import '../../domain/entities/vendor_entity.dart';
import '../bloc/vendor_bloc.dart';
import '../bloc/vendor_event.dart';

class VendorStorefrontPage extends StatefulWidget {
  final VendorEntity vendor;

  const VendorStorefrontPage({super.key, required this.vendor});

  @override
  State<VendorStorefrontPage> createState() => _VendorStorefrontPageState();
}

class _VendorStorefrontPageState extends State<VendorStorefrontPage> {
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    context.read<VendorBloc>().add(FetchVendorStorefrontEvent(widget.vendor.id));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vendor = widget.vendor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsible SliverAppBar with Store Banner
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Store link copied for ${vendor.name}'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: vendor.bannerUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: isDark ? AppColors.darkSurface : Colors.grey[300]),
                    errorWidget: (_, __, ___) => Container(color: isDark ? AppColors.darkSurface : Colors.grey[300]),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Vendor Profile Card Sliver
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar & Follow Button Row
                  Transform.translate(
                    offset: const Offset(0, -32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Store Avatar
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? AppColors.primaryNeon : AppColors.primary,
                              width: 2.5,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 38,
                            backgroundImage: CachedNetworkImageProvider(vendor.logoUrl),
                          ),
                        ),

                        // Follow / Contact Store Button
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() => _isFollowing = !_isFollowing);
                          },
                          icon: Icon(
                            _isFollowing ? Icons.check_rounded : Icons.add_rounded,
                            size: 18,
                            color: _isFollowing
                                ? (isDark ? Colors.white : Colors.black)
                                : (isDark ? Colors.black : Colors.white),
                          ),
                          label: Text(_isFollowing ? 'Following' : 'Follow Store'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isFollowing
                                ? (isDark ? AppColors.darkCard : AppColors.lightBorder)
                                : (isDark ? AppColors.primaryNeon : AppColors.primary),
                            foregroundColor: _isFollowing
                                ? (isDark ? Colors.white : Colors.black)
                                : (isDark ? Colors.black : Colors.white),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Store Titles & Badges
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              vendor.name,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                            ),
                            if (vendor.isVerified) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.verified_rounded, color: AppColors.accentBlue, size: 20),
                            ],
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            RatingBadge(
                              rating: vendor.rating,
                              reviewCount: vendor.reviewsCount,
                              fontSize: 13,
                              starSize: 16,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '•',
                              style: TextStyle(
                                color: isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${(vendor.followersCount / 1000).toStringAsFixed(1)}k followers',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '•',
                              style: TextStyle(
                                color: isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              vendor.location,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Store Bio
                        Text(
                          vendor.description,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Shipping & Trust Banner
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCard : AppColors.lightSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.local_shipping_outlined,
                                size: 20,
                                color: isDark ? AppColors.primaryNeon : AppColors.primary,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  vendor.shippingPolicy,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Products Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Store Products',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: (isDark ? AppColors.primaryNeon : AppColors.primary).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Verified Merchant',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.primaryNeon : AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Vendor Products Grid
          BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, state) {
              if (state is ProductsLoadingState) {
                return const SliverToBoxAdapter(
                  child: ShimmerProductGrid(itemCount: 4),
                );
              }

              if (state is ProductsLoadedState) {
                // Filter products that belong to this vendor
                final vendorProducts = state.allProducts
                    .where((p) => p.vendor.id == widget.vendor.id || p.vendor.name == widget.vendor.name)
                    .toList();

                if (vendorProducts.isEmpty) {
                  // If dummyjson has only a few, provide a fallback of products with similar category
                  final similarCategoryProducts = state.allProducts.take(4).toList();
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ProductCard(product: similarCategoryProducts[index]),
                        childCount: similarCategoryProducts.length,
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ProductCard(product: vendorProducts[index]),
                      childCount: vendorProducts.length,
                    ),
                  ),
                );
              }

              return const SliverToBoxAdapter(
                child: EmptyView(
                  title: 'No Products Found',
                  message: 'This vendor does not have any active product listings.',
                ),
              );
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
