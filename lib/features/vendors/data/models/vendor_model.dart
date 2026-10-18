import '../../domain/entities/vendor_entity.dart';

class VendorModel extends VendorEntity {
  const VendorModel({
    required super.id,
    required super.name,
    required super.logoUrl,
    required super.bannerUrl,
    required super.rating,
    required super.reviewsCount,
    required super.description,
    super.isVerified = true,
    super.location = 'Global Logistics Center',
    super.joinedDate = 'Member since 2022',
    super.followersCount = 8500,
    super.shippingPolicy = 'Dispatched within 24 hours. Express tracked delivery.',
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'] as String? ?? 'vendor_default',
      name: json['name'] as String? ?? 'Premium Store',
      logoUrl: json['logoUrl'] as String? ?? 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=150',
      bannerUrl: json['bannerUrl'] as String? ?? 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviewsCount: (json['reviewsCount'] as num?)?.toInt() ?? 1250,
      description: json['description'] as String? ?? 'Verified marketplace merchant specializing in high-grade authentic consumer products.',
      isVerified: json['isVerified'] as bool? ?? true,
      location: json['location'] as String? ?? 'New York, USA',
      joinedDate: json['joinedDate'] as String? ?? 'Member since 2022',
      followersCount: (json['followersCount'] as num?)?.toInt() ?? 9400,
      shippingPolicy: json['shippingPolicy'] as String? ?? 'Dispatched within 24 hours. Express tracked delivery.',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'bannerUrl': bannerUrl,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'description': description,
      'isVerified': isVerified,
      'location': location,
      'joinedDate': joinedDate,
      'followersCount': followersCount,
      'shippingPolicy': shippingPolicy,
    };
  }

  /// Synthesizes a realistic, high-fidelity vendor model from a brand or category
  factory VendorModel.fromBrand(String? brand, String? category) {
    final cleanBrand = (brand != null && brand.trim().isNotEmpty) ? brand.trim() : null;
    final cleanCategory = (category != null && category.trim().isNotEmpty) ? category.trim() : 'General';

    final effectiveName = cleanBrand ?? '$cleanCategory Hub';
    final slug = effectiveName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
    final vendorId = 'vendor_$slug';

    // Curated high quality banners and logos based on brand / category
    final lower = effectiveName.toLowerCase();
    String logo;
    String banner;
    String desc;
    double rating = 4.8;
    int reviews = 1420;
    String location = 'New York, USA';

    if (lower.contains('apple')) {
      logo = 'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?w=200';
      banner = 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=900';
      desc = 'Official Certified Apple Reseller. Genuine devices, warranties, and premium accessories.';
      rating = 4.9;
      reviews = 4850;
      location = 'Cupertino, CA, USA';
    } else if (lower.contains('essence') || lower.contains('glamour') || lower.contains('beauty') || lower.contains('velvet')) {
      logo = 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=200';
      banner = 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=900';
      desc = 'Luxury Cosmetics & Skincare Boutique. Dermatologist-tested, cruelty-free formulas.';
      rating = 4.8;
      reviews = 2390;
      location = 'Paris, France';
    } else if (lower.contains('fragrance') || lower.contains('dior') || lower.contains('gucci') || lower.contains('perfume')) {
      logo = 'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?w=200';
      banner = 'https://images.unsplash.com/photo-1547887537-6158d64c35b3?w=900';
      desc = 'Artisanal Perfumery & Eau de Parfum collections curated from Grasse and Milan.';
      rating = 4.9;
      reviews = 1820;
      location = 'Milan, Italy';
    } else if (lower.contains('tech') || lower.contains('samsung') || lower.contains('laptop') || lower.contains('phone')) {
      logo = 'https://images.unsplash.com/photo-1550009158-9ebf69173e03?w=200';
      banner = 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=900';
      desc = 'Smart Electronics & Computing flagship distributor with express worldwide dispatch.';
      rating = 4.7;
      reviews = 3100;
      location = 'Seoul, South Korea';
    } else {
      logo = 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=200';
      banner = 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=900';
      desc = 'Premier Marketplace Merchant offering authenticated luxury and lifestyle products.';
      rating = 4.8;
      reviews = 980;
      location = 'London, UK';
    }

    return VendorModel(
      id: vendorId,
      name: effectiveName,
      logoUrl: logo,
      bannerUrl: banner,
      rating: rating,
      reviewsCount: reviews,
      description: desc,
      isVerified: true,
      location: location,
      joinedDate: 'Member since 2022',
      followersCount: 12400,
      shippingPolicy: 'Dispatched within 24 hours. Express tracked delivery.',
    );
  }
}
