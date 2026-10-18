import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/cart/presentation/bloc/cart_event.dart';
import 'features/orders/presentation/bloc/order_bloc.dart';
import 'features/orders/presentation/bloc/order_event.dart';
import 'features/products/presentation/bloc/products_bloc.dart';
import 'features/products/presentation/bloc/products_event.dart';
import 'features/vendors/presentation/bloc/vendor_bloc.dart';
import 'features/vendors/presentation/bloc/vendor_event.dart';
import 'features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'injection_container.dart' as di;
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const MultiVendorEcommerceApp());
}

class MultiVendorEcommerceApp extends StatelessWidget {
  const MultiVendorEcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => di.sl<ThemeCubit>(),
        ),
        BlocProvider<WishlistCubit>(
          create: (_) => di.sl<WishlistCubit>(),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>()..add(const CheckAuthStatusEvent()),
        ),
        BlocProvider<ProductsBloc>(
          create: (_) => di.sl<ProductsBloc>()..add(const FetchProductsEvent()),
        ),
        BlocProvider<VendorBloc>(
          create: (_) => di.sl<VendorBloc>()..add(const FetchFeaturedVendorsEvent()),
        ),
        BlocProvider<CartBloc>(
          create: (_) => di.sl<CartBloc>()..add(const LoadCartEvent()),
        ),
        BlocProvider<OrderBloc>(
          create: (_) => di.sl<OrderBloc>()..add(const LoadOrdersEvent()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'Multi-Vendor E-Commerce',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
