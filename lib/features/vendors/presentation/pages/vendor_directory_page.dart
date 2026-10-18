import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../../../../core/widgets/rating_badge.dart';
import '../bloc/vendor_bloc.dart';
import '../bloc/vendor_event.dart';
import '../bloc/vendor_state.dart';

class VendorDirectoryPage extends StatelessWidget {
  const VendorDirectoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verified Vendors & Stores'),
      ),
      body: BlocBuilder<VendorBloc, VendorState>(
        builder: (context, state) {
          if (state is VendorLoadingState) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: ShimmerVendorList(),
            );
          }

          if (state is VendorLoadedState) {
            final vendors = state.featuredVendors;

            if (vendors.isEmpty) {
              return const EmptyView(
                title: 'No Vendors Available',
                message: 'No stores are active at this moment.',
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: vendors.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final vendor = vendors[index];

                return InkWell(
                  onTap: () => context.push('/vendor-storefront', extra: vendor),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.6),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Banner with overlay
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                          child: SizedBox(
                            height: 90,
                            width: double.infinity,
                            child: CachedNetworkImage(
                              imageUrl: vendor.bannerUrl,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Container(color: isDark ? AppColors.darkSurface : Colors.grey[200]),
                              errorWidget: (_, __, ___) => Container(color: isDark ? AppColors.darkSurface : Colors.grey[200]),
                            ),
                          ),
                        ),

                        // Store Details
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage: CachedNetworkImageProvider(vendor.logoUrl),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          vendor.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (vendor.isVerified) ...[
                                          const SizedBox(width: 4),
                                          const Icon(Icons.verified_rounded, size: 16, color: AppColors.accentBlue),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      vendor.location,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    RatingBadge(
                                      rating: vendor.rating,
                                      reviewCount: vendor.reviewsCount,
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: isDark ? AppColors.primaryNeon : AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          if (state is VendorErrorState) {
            return ErrorView(
              message: state.message,
              onRetry: () => context.read<VendorBloc>().add(const FetchFeaturedVendorsEvent()),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
