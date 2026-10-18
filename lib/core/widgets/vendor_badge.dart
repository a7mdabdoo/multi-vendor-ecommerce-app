import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class VendorBadge extends StatelessWidget {
  final String name;
  final bool isVerified;
  final VoidCallback? onTap;
  final double fontSize;
  final double iconSize;

  const VendorBadge({
    super.key,
    required this.name,
    this.isVerified = true,
    this.onTap,
    this.fontSize = 11,
    this.iconSize = 13,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardSecondary : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.storefront_rounded,
            size: iconSize,
            color: isDark ? AppColors.primaryNeon : AppColors.primary,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
              ),
            ),
          ),
          if (isVerified) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.verified_rounded,
              size: iconSize - 1,
              color: AppColors.accentBlue,
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: badge,
      );
    }

    return badge;
  }
}
