import '../../domain/entities/product_entity.dart';
import '../../../vendors/data/models/vendor_model.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.price,
    required super.discountPercentage,
    required super.rating,
    required super.stock,
    super.brand,
    super.tags = const [],
    super.sku,
    super.warrantyInformation,
    super.shippingInformation,
    super.availabilityStatus = 'In Stock',
    super.returnPolicy,
    required super.images,
    required super.thumbnail,
    required super.vendor,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final imagesList = (json['images'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    final tagsList = (json['tags'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    final brand = json['brand'] as String?;
    final category = json['category'] as String? ?? 'General';

    // Parse or synthesize Vendor
    VendorModel vendor;
    if (json['vendor'] != null && json['vendor'] is Map<String, dynamic>) {
      vendor = VendorModel.fromJson(json['vendor'] as Map<String, dynamic>);
    } else {
      vendor = VendorModel.fromBrand(brand, category);
    }

    return ProductModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? 'Unknown Product',
      description: json['description'] as String? ?? '',
      category: category,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      stock: (json['stock'] as num?)?.toInt() ?? 10,
      brand: brand,
      tags: tagsList,
      sku: json['sku'] as String?,
      warrantyInformation: json['warrantyInformation'] as String?,
      shippingInformation: json['shippingInformation'] as String?,
      availabilityStatus: json['availabilityStatus'] as String? ?? 'In Stock',
      returnPolicy: json['returnPolicy'] as String?,
      images: imagesList.isNotEmpty ? imagesList : [json['thumbnail']?.toString() ?? ''],
      thumbnail: json['thumbnail'] as String? ?? (imagesList.isNotEmpty ? imagesList.first : ''),
      vendor: vendor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'brand': brand,
      'tags': tags,
      'sku': sku,
      'warrantyInformation': warrantyInformation,
      'shippingInformation': shippingInformation,
      'availabilityStatus': availabilityStatus,
      'returnPolicy': returnPolicy,
      'images': images,
      'vendor': {
        'id': vendor.id,
        'name': vendor.name,
        'logoUrl': vendor.logoUrl,
        'bannerUrl': vendor.bannerUrl,
        'rating': vendor.rating,
        'reviewsCount': vendor.reviewsCount,
        'description': vendor.description,
        'isVerified': vendor.isVerified,
        'location': vendor.location,
        'joinedDate': vendor.joinedDate,
        'followersCount': vendor.followersCount,
        'shippingPolicy': vendor.shippingPolicy,
      },
    };
  }
}
