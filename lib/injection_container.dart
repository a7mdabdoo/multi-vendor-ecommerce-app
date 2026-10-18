import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/dio_client.dart';
import 'core/network/interceptors/auth_interceptor.dart';
import 'core/network/interceptors/logging_interceptor.dart';
import 'core/services/storage_service.dart';
import 'core/theme/theme_cubit.dart';

// Auth
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/auth_usecases.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// Vendors
import 'features/vendors/data/datasources/vendor_remote_data_source.dart';
import 'features/vendors/data/repositories/vendor_repository_impl.dart';
import 'features/vendors/domain/repositories/vendor_repository.dart';
import 'features/vendors/domain/usecases/get_featured_vendors_usecase.dart';
import 'features/vendors/domain/usecases/get_vendor_details_usecase.dart';
import 'features/vendors/presentation/bloc/vendor_bloc.dart';

// Products
import 'features/products/data/datasources/product_remote_data_source.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/domain/repositories/product_repository.dart';
import 'features/products/domain/usecases/get_categories_usecase.dart';
import 'features/products/domain/usecases/get_product_details_usecase.dart';
import 'features/products/domain/usecases/get_products_by_category_usecase.dart';
import 'features/products/domain/usecases/get_products_by_vendor_usecase.dart';
import 'features/products/domain/usecases/get_products_usecase.dart';
import 'features/products/domain/usecases/search_products_usecase.dart';
import 'features/products/presentation/bloc/products_bloc.dart';

// Cart
import 'features/cart/data/datasources/cart_local_data_source.dart';
import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/cart/domain/repositories/cart_repository.dart';
import 'features/cart/domain/usecases/cart_usecases.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';

// Orders
import 'features/orders/data/datasources/order_local_data_source.dart';
import 'features/orders/data/repositories/order_repository_impl.dart';
import 'features/orders/domain/repositories/order_repository.dart';
import 'features/orders/domain/usecases/order_usecases.dart';
import 'features/orders/presentation/bloc/order_bloc.dart';

// Wishlist
import 'features/wishlist/presentation/cubit/wishlist_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // 1. External & Core Storage
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<StorageService>(() => StorageService(sl()));

  // 2. Core Network & Dio
  sl.registerLazySingleton<AuthInterceptor>(() => AuthInterceptor(sl()));
  sl.registerLazySingleton<LoggingInterceptor>(() => LoggingInterceptor());
  sl.registerLazySingleton<DioClient>(
    () => DioClient(
      authInterceptor: sl(),
      loggingInterceptor: sl(),
    ),
  );

  // 3. Theme & Wishlist
  sl.registerFactory<ThemeCubit>(() => ThemeCubit(sl()));
  sl.registerFactory<WishlistCubit>(() => WishlistCubit(sl()));

  // 4. Feature: Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(sl()));
  sl.registerLazySingleton<GetCurrentUserUseCase>(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(sl()));
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      getCurrentUserUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );

  // 5. Feature: Vendors
  sl.registerLazySingleton<VendorRemoteDataSource>(() => VendorRemoteDataSourceImpl());
  sl.registerLazySingleton<VendorRepository>(() => VendorRepositoryImpl(sl()));
  sl.registerLazySingleton<GetFeaturedVendorsUseCase>(() => GetFeaturedVendorsUseCase(sl()));
  sl.registerLazySingleton<GetVendorDetailsUseCase>(() => GetVendorDetailsUseCase(sl()));
  sl.registerFactory<VendorBloc>(
    () => VendorBloc(
      getFeaturedVendorsUseCase: sl(),
      getVendorDetailsUseCase: sl(),
      getProductsByVendorUseCase: sl(),
    ),
  );

  // 6. Feature: Products
  sl.registerLazySingleton<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(sl()));
  sl.registerLazySingleton<GetProductsUseCase>(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton<GetProductDetailsUseCase>(() => GetProductDetailsUseCase(sl()));
  sl.registerLazySingleton<GetCategoriesUseCase>(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton<SearchProductsUseCase>(() => SearchProductsUseCase(sl()));
  sl.registerLazySingleton<GetProductsByCategoryUseCase>(() => GetProductsByCategoryUseCase(sl()));
  sl.registerLazySingleton<GetProductsByVendorUseCase>(() => GetProductsByVendorUseCase(sl()));
  sl.registerFactory<ProductsBloc>(
    () => ProductsBloc(
      getProductsUseCase: sl(),
      getCategoriesUseCase: sl(),
      searchProductsUseCase: sl(),
      getProductsByCategoryUseCase: sl(),
    ),
  );

  // 7. Feature: Cart
  sl.registerLazySingleton<CartLocalDataSource>(() => CartLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()));
  sl.registerLazySingleton<GetCartUseCase>(() => GetCartUseCase(sl()));
  sl.registerLazySingleton<SaveCartUseCase>(() => SaveCartUseCase(sl()));
  sl.registerLazySingleton<ClearCartUseCase>(() => ClearCartUseCase(sl()));
  sl.registerFactory<CartBloc>(
    () => CartBloc(
      getCartUseCase: sl(),
      saveCartUseCase: sl(),
      clearCartUseCase: sl(),
    ),
  );

  // 8. Feature: Orders
  sl.registerLazySingleton<OrderLocalDataSource>(() => OrderLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(sl()));
  sl.registerLazySingleton<GetOrdersUseCase>(() => GetOrdersUseCase(sl()));
  sl.registerLazySingleton<PlaceOrderUseCase>(() => PlaceOrderUseCase(sl()));
  sl.registerFactory<OrderBloc>(
    () => OrderBloc(
      getOrdersUseCase: sl(),
      placeOrderUseCase: sl(),
    ),
  );
}
