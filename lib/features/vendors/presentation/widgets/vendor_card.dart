import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/rating_badge.dart';
import '../../domain/entities/vendor_entity.dart';

class VendorCard extends StatelessWidget {
  final VendorEntity vendor;
  final VoidCallback? onTap;

  const VendorCard({
    super.key,
    required this.vendor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap ?? () => context.push('/vendor-storefront', extra: vendor),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 175,
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.6),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Store Banner Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: SizedBox(
                height: 55,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: vendor.bannerUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: isDark ? AppColors.darkSurface : Colors.grey[200]),
                  errorWidget: (_, __, ___) => Container(color: isDark ? AppColors.darkSurface : Colors.grey[200]),
                ),
              ),
            ),

            // Overlapping Store Avatar
            Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? AppColors.primaryNeon : AppColors.primary,
                    width: 1.5,
                  ),
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: isDark ? AppColors.darkSurface : Colors.grey[100],
                  backgroundImage: CachedNetworkImageProvider(vendor.logoUrl),
                ),
              ),
            ),

            // Store Info
            Transform.translate(
              offset: const Offset(0, -16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            vendor.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (vendor.isVerified) ...[
                          const SizedBox(width: 3),
                          const Icon(Icons.verified_rounded, size: 13, color: AppColors.accentBlue),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    RatingBadge(
                      rating: vendor.rating,
                      reviewCount: vendor.reviewsCount,
                      fontSize: 11,
                      starSize: 13,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(vendor.followersCount / 1000).toStringAsFixed(1)}k followers',
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
