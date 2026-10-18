import 'package:equatable/equatable.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../domain/entities/vendor_entity.dart';

abstract class VendorState extends Equatable {
  const VendorState();

  @override
  List<Object?> get props => [];
}

class VendorInitialState extends VendorState {
  const VendorInitialState();
}

class VendorLoadingState extends VendorState {
  const VendorLoadingState();
}

class VendorLoadedState extends VendorState {
  final List<VendorEntity> featuredVendors;
  final VendorEntity? currentVendor;
  final List<ProductEntity> currentVendorProducts;
  final bool isStorefrontLoading;

  const VendorLoadedState({
    this.featuredVendors = const [],
    this.currentVendor,
    this.currentVendorProducts = const [],
    this.isStorefrontLoading = false,
  });

  VendorLoadedState copyWith({
    List<VendorEntity>? featuredVendors,
    VendorEntity? currentVendor,
    List<ProductEntity>? currentVendorProducts,
    bool? isStorefrontLoading,
  }) {
    return VendorLoadedState(
      featuredVendors: featuredVendors ?? this.featuredVendors,
      currentVendor: currentVendor ?? this.currentVendor,
      currentVendorProducts: currentVendorProducts ?? this.currentVendorProducts,
      isStorefrontLoading: isStorefrontLoading ?? this.isStorefrontLoading,
    );
  }

  @override
  List<Object?> get props => [
        featuredVendors,
        currentVendor,
        currentVendorProducts,
        isStorefrontLoading,
      ];
}

class VendorErrorState extends VendorState {
  final String message;

  const VendorErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
