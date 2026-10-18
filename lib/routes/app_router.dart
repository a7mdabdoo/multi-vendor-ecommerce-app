import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/cart/domain/entities/cart_entity.dart';
import '../features/cart/presentation/pages/checkout_page.dart';
import '../features/navigation/presentation/main_layout_screen.dart';
import '../features/orders/domain/entities/order_entity.dart';
import '../features/orders/presentation/pages/order_success_page.dart';
import '../features/orders/presentation/pages/orders_page.dart';
import '../features/products/domain/entities/product_entity.dart';
import '../features/products/presentation/pages/product_details_page.dart';
import '../features/vendors/domain/entities/vendor_entity.dart';
import '../features/vendors/presentation/pages/vendor_storefront_page.dart';
import '../features/wishlist/presentation/pages/wishlist_page.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainLayoutScreen(initialIndex: 0),
    ),
    GoRoute(
      path: '/catalog',
      builder: (context, state) => const MainLayoutScreen(initialIndex: 1),
    ),
    GoRoute(
      path: '/vendors',
      builder: (context, state) => const MainLayoutScreen(initialIndex: 2),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const MainLayoutScreen(initialIndex: 3),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const MainLayoutScreen(initialIndex: 4),
    ),
    GoRoute(
      path: '/product-details',
      builder: (context, state) {
        final product = state.extra as ProductEntity;
        return ProductDetailsPage(product: product);
      },
    ),
    GoRoute(
      path: '/vendor-storefront',
      builder: (context, state) {
        final vendor = state.extra as VendorEntity;
        return VendorStorefrontPage(vendor: vendor);
      },
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) {
        final cart = state.extra as CartEntity;
        return CheckoutPage(cart: cart);
      },
    ),
    GoRoute(
      path: '/order-success',
      builder: (context, state) {
        final order = state.extra as OrderEntity;
        return OrderSuccessPage(order: order);
      },
    ),
    GoRoute(
      path: '/orders',
      builder: (context, state) => const OrdersPage(),
    ),
    GoRoute(
      path: '/wishlist',
      builder: (context, state) => const WishlistPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
  ],
);
