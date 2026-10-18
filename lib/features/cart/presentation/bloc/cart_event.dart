import 'package:equatable/equatable.dart';
import '../../../products/domain/entities/product_entity.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCartEvent extends CartEvent {
  const LoadCartEvent();
}

class AddToCartEvent extends CartEvent {
  final ProductEntity product;
  final int quantity;
  final String? selectedVariant;

  const AddToCartEvent({
    required this.product,
    this.quantity = 1,
    this.selectedVariant,
  });

  @override
  List<Object?> get props => [product, quantity, selectedVariant];
}

class RemoveFromCartEvent extends CartEvent {
  final int productId;

  const RemoveFromCartEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

class UpdateCartQuantityEvent extends CartEvent {
  final int productId;
  final int newQuantity;

  const UpdateCartQuantityEvent({
    required this.productId,
    required this.newQuantity,
  });

  @override
  List<Object?> get props => [productId, newQuantity];
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}
