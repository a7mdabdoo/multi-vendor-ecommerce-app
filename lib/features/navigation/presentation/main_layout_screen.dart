import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:multi_vendor_ecommerce/core/constants/app_colors.dart';
import 'package:multi_vendor_ecommerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:multi_vendor_ecommerce/features/cart/presentation/bloc/cart_state.dart';
import 'package:multi_vendor_ecommerce/features/cart/presentation/pages/cart_page.dart';
import 'package:multi_vendor_ecommerce/features/products/presentation/pages/catalog_page.dart';
import 'package:multi_vendor_ecommerce/features/products/presentation/pages/home_page.dart';
import 'package:multi_vendor_ecommerce/features/profile/presentation/pages/profile_page.dart';
import 'package:multi_vendor_ecommerce/features/vendors/presentation/pages/vendor_directory_page.dart';

class MainLayoutScreen extends StatefulWidget {
  final int initialIndex;

  const MainLayoutScreen({super.key, this.initialIndex = 0});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  late int _currentIndex;

  final List<Widget> _pages = const [
    HomePage(),
    CatalogPage(),
    VendorDirectoryPage(),
    CartPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 0.8,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
          },
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view_rounded),
              label: 'Catalog',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined),
              activeIcon: Icon(Icons.storefront_rounded),
              label: 'Stores',
            ),
            BottomNavigationBarItem(
              icon: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  int count = 0;
                  if (state is CartLoadedState) {
                    count = state.cart.totalItemCount;
                  }

                  if (count > 0) {
                    return Badge(
                      label: Text('$count', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      backgroundColor: AppColors.error,
                      child: const Icon(Icons.shopping_bag_outlined),
                    );
                  }

                  return const Icon(Icons.shopping_bag_outlined);
                },
              ),
              activeIcon: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  int count = 0;
                  if (state is CartLoadedState) {
                    count = state.cart.totalItemCount;
                  }

                  if (count > 0) {
                    return Badge(
                      label: Text('$count', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      backgroundColor: AppColors.error,
                      child: const Icon(Icons.shopping_bag_rounded),
                    );
                  }

                  return const Icon(Icons.shopping_bag_rounded);
                },
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
