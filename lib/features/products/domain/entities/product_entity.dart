import 'package:equatable/equatable.dart';
import 'package:multi_vendor_ecommerce/features/vendors/domain/entities/vendor_entity.dart';

class ProductEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String? brand;
  final List<String> tags;
  final String? sku;
  final String? warrantyInformation;
  final String? shippingInformation;
  final String availabilityStatus;
  final String? returnPolicy;
  final List<String> images;
  final String thumbnail;
  final VendorEntity vendor;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    this.brand,
    this.tags = const [],
    this.sku,
    this.warrantyInformation,
    this.shippingInformation,
    this.availabilityStatus = 'In Stock',
    this.returnPolicy,
    required this.images,
    required this.thumbnail,
    required this.vendor,
  });

  double get discountedPrice {
    if (discountPercentage <= 0) return price;
    return price * (1 - (discountPercentage / 100));
  }

  bool get inStock => stock > 0;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        price,
        discountPercentage,
        rating,
        stock,
        brand,
        tags,
        sku,
        warrantyInformation,
        shippingInformation,
        availabilityStatus,
        returnPolicy,
        images,
        thumbnail,
        vendor,
      ];
}
