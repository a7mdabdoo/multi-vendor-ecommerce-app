import 'package:equatable/equatable.dart';
import 'package:multi_vendor_ecommerce/features/cart/domain/entities/cart_item_entity.dart';

class OrderEntity extends Equatable {
  final String id;
  final DateTime createdAt;
  final String status;
  final List<CartItemEntity> items;
  final double subtotal;
  final double tax;
  final double shippingFee;
  final double total;
  final int vendorCount;
  final String shippingAddress;
  final String paymentMethod;

  const OrderEntity({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.shippingFee,
    required this.total,
    required this.vendorCount,
    required this.shippingAddress,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [
        id,
        createdAt,
        status,
        items,
        subtotal,
        tax,
        shippingFee,
        total,
        vendorCount,
        shippingAddress,
        paymentMethod,
      ];
}
