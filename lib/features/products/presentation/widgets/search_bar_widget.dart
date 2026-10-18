import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/debouncer.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';

class SearchBarWidget extends StatefulWidget {
  final String? initialValue;
  final VoidCallback? onFilterTap;

  const SearchBarWidget({
    super.key,
    this.initialValue,
    this.onFilterTap,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late final TextEditingController _controller;
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 350));

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          setState(() {});
          _debouncer.run(() {
            context.read<ProductsBloc>().add(SearchProductsEvent(value));
          });
        },
        decoration: InputDecoration(
          hintText: 'Search products, brands, stores...',
          hintStyle: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark ? AppColors.primaryNeon : AppColors.primary,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () {
                    _controller.clear();
                    setState(() {});
                    context.read<ProductsBloc>().add(const ClearSearchEvent());
                  },
                )
              : (widget.onFilterTap != null
                  ? IconButton(
                      icon: const Icon(Icons.tune_rounded, size: 20),
                      onPressed: widget.onFilterTap,
                    )
                  : null),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
