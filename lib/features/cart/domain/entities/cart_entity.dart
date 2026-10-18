import 'package:equatable/equatable.dart';
import 'package:multi_vendor_ecommerce/features/vendors/domain/entities/vendor_entity.dart';
import 'cart_item_entity.dart';

class CartEntity extends Equatable {
  final List<CartItemEntity> items;

  const CartEntity({this.items = const []});

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  int get totalItemCount => items.fold(0, (acc, item) => acc + item.quantity);

  double get subtotal => items.fold(0.0, (acc, item) => acc + item.totalPrice);

  double get estimatedTax => subtotal * 0.08; // 8% sales tax

  List<VendorCartGroup> get vendorGroups {
    final Map<String, List<CartItemEntity>> grouped = {};
    final Map<String, VendorEntity> vendors = {};

    for (final item in items) {
      final vendorId = item.vendor.id;
      grouped.putIfAbsent(vendorId, () => []).add(item);
      vendors[vendorId] = item.vendor;
    }

    return grouped.entries.map((entry) {
      return VendorCartGroup(
        vendor: vendors[entry.key]!,
        items: entry.value,
      );
    }).toList();
  }

  double get totalShippingFee {
    return vendorGroups.fold(0.0, (acc, group) => acc + group.shippingFee);
  }

  double get grandTotal => subtotal + estimatedTax + totalShippingFee;

  @override
  List<Object?> get props => [items];
}
