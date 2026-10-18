import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/empty_view.dart';
import '../../../products/presentation/bloc/products_bloc.dart';
import '../../../products/presentation/bloc/products_state.dart';
import '../../../products/presentation/widgets/product_card.dart';
import '../cubit/wishlist_cubit.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
      ),
      body: BlocBuilder<WishlistCubit, Set<int>>(
        builder: (context, favoriteIds) {
          if (favoriteIds.isEmpty) {
            return EmptyView(
              title: 'Your Wishlist is Empty',
              message: 'Save items you love from various stores to keep track of discounts.',
              icon: Icons.favorite_border_rounded,
              buttonText: 'Discover Products',
              onButtonPressed: () => context.go('/'),
            );
          }

          return BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, prodState) {
              if (prodState is ProductsLoadedState) {
                final wishlistProducts = prodState.allProducts
                    .where((p) => favoriteIds.contains(p.id))
                    .toList();

                if (wishlistProducts.isEmpty) {
                  return EmptyView(
                    title: 'Your Wishlist is Empty',
                    message: 'Save items you love from various stores to keep track of discounts.',
                    icon: Icons.favorite_border_rounded,
                    buttonText: 'Discover Products',
                    onButtonPressed: () => context.go('/'),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: wishlistProducts.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: wishlistProducts[index]);
                  },
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
