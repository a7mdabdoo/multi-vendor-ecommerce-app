import 'package:equatable/equatable.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../vendors/domain/entities/vendor_entity.dart';

class CartItemEntity extends Equatable {
  final ProductEntity product;
  final int quantity;
  final String? selectedVariant;

  const CartItemEntity({
    required this.product,
    this.quantity = 1,
    this.selectedVariant,
  });

  double get unitPrice => product.discountedPrice;
  double get totalPrice => unitPrice * quantity;
  VendorEntity get vendor => product.vendor;

  CartItemEntity copyWith({
    ProductEntity? product,
    int? quantity,
    String? selectedVariant,
  }) {
    return CartItemEntity(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedVariant: selectedVariant ?? this.selectedVariant,
    );
  }

  @override
  List<Object?> get props => [product, quantity, selectedVariant];
}

class VendorCartGroup extends Equatable {
  final VendorEntity vendor;
  final List<CartItemEntity> items;

  const VendorCartGroup({
    required this.vendor,
    required this.items,
  });

  double get subtotal => items.fold(0.0, (acc, item) => acc + item.totalPrice);
  double get shippingFee => subtotal >= 50.0 ? 0.0 : 4.99;
  int get itemCount => items.fold(0, (acc, item) => acc + item.quantity);

  @override
  List<Object?> get props => [vendor, items];
}
