import 'package:flutter_test/flutter_test.dart';
import 'package:multi_vendor_ecommerce/features/cart/domain/entities/cart_entity.dart';
import 'package:multi_vendor_ecommerce/features/cart/domain/entities/cart_item_entity.dart';
import 'package:multi_vendor_ecommerce/features/products/domain/entities/product_entity.dart';
import 'package:multi_vendor_ecommerce/features/vendors/domain/entities/vendor_entity.dart';

void main() {
  group('Multi-Vendor Domain & Cart Calculation Tests', () {
    const testVendorA = VendorEntity(
      id: 'vendor_a',
      name: 'Tech Store',
      logoUrl: '',
      bannerUrl: '',
      rating: 4.8,
      reviewsCount: 100,
      description: 'Tech store',
    );

    const testVendorB = VendorEntity(
      id: 'vendor_b',
      name: 'Beauty Store',
      logoUrl: '',
      bannerUrl: '',
      rating: 4.9,
      reviewsCount: 200,
      description: 'Beauty store',
    );

    const testProduct1 = ProductEntity(
      id: 1,
      title: 'Wireless Earbuds',
      description: 'High quality sound',
      category: 'Electronics',
      price: 100.0,
      discountPercentage: 20.0, // Discounted: 80.0
      rating: 4.5,
      stock: 15,
      images: [],
      thumbnail: '',
      vendor: testVendorA,
    );

    const testProduct2 = ProductEntity(
      id: 2,
      title: 'Luxury Perfume',
      description: 'Long lasting scent',
      category: 'Fragrances',
      price: 60.0,
      discountPercentage: 0.0, // Discounted: 60.0
      rating: 4.8,
      stock: 5,
      images: [],
      thumbnail: '',
      vendor: testVendorB,
    );

    test('ProductEntity calculated discounted price correctly', () {
      expect(testProduct1.discountedPrice, 80.0);
      expect(testProduct2.discountedPrice, 60.0);
    });

    test('CartEntity correctly groups items by separate vendors', () {
      const item1 = CartItemEntity(product: testProduct1, quantity: 2); // 80 * 2 = 160
      const item2 = CartItemEntity(product: testProduct2, quantity: 1); // 60 * 1 = 60

      const cart = CartEntity(items: [item1, item2]);

      expect(cart.totalItemCount, 3);
      expect(cart.subtotal, 220.0);
      expect(cart.vendorGroups.length, 2);

      // Verify vendor groups
      final groupA = cart.vendorGroups.firstWhere((g) => g.vendor.id == 'vendor_a');
      final groupB = cart.vendorGroups.firstWhere((g) => g.vendor.id == 'vendor_b');

      expect(groupA.subtotal, 160.0);
      expect(groupA.shippingFee, 0.0); // Subtotal >= 50 gives free shipping

      expect(groupB.subtotal, 60.0);
      expect(groupB.shippingFee, 0.0);
    });
  });
}
