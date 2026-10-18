import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/category_entity.dart';

class CategoryFilterBar extends StatelessWidget {
  final List<CategoryEntity> categories;
  final String selectedSlug;
  final void Function(String slug) onCategorySelected;

  const CategoryFilterBar({
    super.key,
    required this.categories,
    required this.selectedSlug,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat.slug.toLowerCase() == selectedSlug.toLowerCase();

          return InkWell(
            onTap: () => onCategorySelected(cat.slug),
            borderRadius: BorderRadius.circular(22),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? AppColors.primaryNeon : AppColors.primary)
                    : (isDark ? AppColors.darkCard : AppColors.lightSurface),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isSelected
                      ? (isDark ? AppColors.primaryNeon : AppColors.primary)
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  width: 1.2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: (isDark ? AppColors.primaryNeon : AppColors.primary).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _iconForCategory(cat.iconName),
                    size: 16,
                    color: isSelected
                        ? (isDark ? Colors.black : Colors.white)
                        : (isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cat.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? (isDark ? Colors.black : Colors.white)
                          : (isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _iconForCategory(String iconName) {
    switch (iconName) {
      case 'beauty':
        return Icons.auto_awesome_rounded;
      case 'fragrance':
        return Icons.water_drop_rounded;
      case 'home':
        return Icons.chair_rounded;
      case 'grocery':
        return Icons.local_dining_rounded;
      case 'laptop':
        return Icons.laptop_mac_rounded;
      case 'phone':
        return Icons.phone_iphone_rounded;
      case 'fashion':
        return Icons.checkroom_rounded;
      case 'shoes':
        return Icons.skateboarding_rounded;
      case 'watch':
        return Icons.watch_rounded;
      case 'jewelry':
        return Icons.diamond_rounded;
      default:
        return Icons.grid_view_rounded;
    }
  }
}
