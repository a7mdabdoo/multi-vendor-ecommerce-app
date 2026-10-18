import 'package:multi_vendor_ecommerce/features/cart/data/models/cart_item_model.dart';
import 'package:multi_vendor_ecommerce/features/cart/domain/entities/cart_item_entity.dart';
import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.createdAt,
    required super.status,
    required super.items,
    required super.subtotal,
    required super.tax,
    required super.shippingFee,
    required super.total,
    required super.vendorCount,
    required super.shippingAddress,
    required super.paymentMethod,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final itemsList = (json['items'] as List<dynamic>?)
            ?.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return OrderModel(
      id: json['id'] as String? ?? 'ORD-00000',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      status: json['status'] as String? ?? 'Confirmed',
      items: List<CartItemEntity>.from(itemsList),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      shippingFee: (json['shippingFee'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      vendorCount: (json['vendorCount'] as num?)?.toInt() ?? 1,
      shippingAddress: json['shippingAddress'] as String? ?? 'Default Address',
      paymentMethod: json['paymentMethod'] as String? ?? 'Credit Card',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
      'items': items.map((e) => CartItemModel.fromEntity(e).toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'shippingFee': shippingFee,
      'total': total,
      'vendorCount': vendorCount,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
    };
  }

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      createdAt: entity.createdAt,
      status: entity.status,
      items: entity.items,
      subtotal: entity.subtotal,
      tax: entity.tax,
      shippingFee: entity.shippingFee,
      total: entity.total,
      vendorCount: entity.vendorCount,
      shippingAddress: entity.shippingAddress,
      paymentMethod: entity.paymentMethod,
    );
  }
}
