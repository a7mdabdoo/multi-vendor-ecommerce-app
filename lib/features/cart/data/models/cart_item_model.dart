import '../../domain/entities/cart_item_entity.dart';
import '../../../products/data/models/product_model.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.product,
    super.quantity = 1,
    super.selectedVariant,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      selectedVariant: json['selectedVariant'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': (product is ProductModel)
          ? (product as ProductModel).toJson()
          : ProductModel(
              id: product.id,
              title: product.title,
              description: product.description,
              category: product.category,
              price: product.price,
              discountPercentage: product.discountPercentage,
              rating: product.rating,
              stock: product.stock,
              brand: product.brand,
              tags: product.tags,
              sku: product.sku,
              warrantyInformation: product.warrantyInformation,
              shippingInformation: product.shippingInformation,
              availabilityStatus: product.availabilityStatus,
              returnPolicy: product.returnPolicy,
              images: product.images,
              thumbnail: product.thumbnail,
              vendor: product.vendor,
            ).toJson(),
      'quantity': quantity,
      'selectedVariant': selectedVariant,
    };
  }

  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      product: entity.product,
      quantity: entity.quantity,
      selectedVariant: entity.selectedVariant,
    );
  }
}
