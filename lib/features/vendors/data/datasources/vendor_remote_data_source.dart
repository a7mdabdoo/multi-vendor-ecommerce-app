import '../models/vendor_model.dart';

abstract class VendorRemoteDataSource {
  Future<List<VendorModel>> getFeaturedVendors();
  Future<VendorModel> getVendorDetails(String vendorId);
}

class VendorRemoteDataSourceImpl implements VendorRemoteDataSource {
  final List<VendorModel> _featuredVendors = [
    const VendorModel(
      id: 'vendor_essence',
      name: 'Essence Official',
      logoUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=200',
      bannerUrl: 'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?w=900',
      rating: 4.9,
      reviewsCount: 3840,
      description: 'The global cosmetics powerhouse bringing cruelty-free, trendsetting makeup essentials to beauty enthusiasts worldwide.',
      isVerified: true,
      location: 'Berlin, Germany',
      joinedDate: 'Joined March 2021',
      followersCount: 28500,
      shippingPolicy: 'Free express shipping on all orders over \$40. Dispatched in 24h.',
    ),
    const VendorModel(
      id: 'vendor_apple',
      name: 'Apple Authorized Hub',
      logoUrl: 'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?w=200',
      bannerUrl: 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=900',
      rating: 4.95,
      reviewsCount: 14200,
      description: 'Certified premium reseller of genuine Apple hardware, MacBooks, iPhones, and authentic accessories with international AppleCare support.',
      isVerified: true,
      location: 'Cupertino, CA, USA',
      joinedDate: 'Joined January 2020',
      followersCount: 89000,
      shippingPolicy: 'Priority tracked air express. Insured against transit damage.',
    ),
    const VendorModel(
      id: 'vendor_glamour_beauty',
      name: 'Glamour Beauty Lab',
      logoUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=200',
      bannerUrl: 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=900',
      rating: 4.8,
      reviewsCount: 2150,
      description: 'Artisanal palettes, luminous highlighters, and dermatologist-approved botanical skincare formulas.',
      isVerified: true,
      location: 'Paris, France',
      joinedDate: 'Joined May 2022',
      followersCount: 19400,
      shippingPolicy: 'Eco-packaged with recycled materials. Dispatches within 48h.',
    ),
    const VendorModel(
      id: 'vendor_velvet_touch',
      name: 'Velvet Touch Cosmetics',
      logoUrl: 'https://images.unsplash.com/photo-1516975080664-ed2fc6a32937?w=200',
      bannerUrl: 'https://images.unsplash.com/photo-1526045612212-70caf35c14df?w=900',
      rating: 4.75,
      reviewsCount: 1680,
      description: 'Masterfully formulated setting powders, velvet lipsticks, and complexion perfection tools for studio and everyday wear.',
      isVerified: true,
      location: 'New York, USA',
      joinedDate: 'Joined September 2022',
      followersCount: 14200,
      shippingPolicy: 'Standard 2-4 day domestic delivery. Flat \$4.99 shipping.',
    ),
    const VendorModel(
      id: 'vendor_chic_cosmetics',
      name: 'Chic Fragrance & Beauty',
      logoUrl: 'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?w=200',
      bannerUrl: 'https://images.unsplash.com/photo-1547887537-6158d64c35b3?w=900',
      rating: 4.88,
      reviewsCount: 2980,
      description: 'Exclusive Eau de Parfum, bespoke scents, and French Riviera body oils.',
      isVerified: true,
      location: 'Grasse, France',
      joinedDate: 'Joined November 2021',
      followersCount: 22100,
      shippingPolicy: 'Hazardous materials certified fragrance transit with temperature control.',
    ),
  ];

  @override
  Future<List<VendorModel>> getFeaturedVendors() async {
    // Simulated remote latency
    await Future.delayed(const Duration(milliseconds: 300));
    return _featuredVendors;
  }

  @override
  Future<VendorModel> getVendorDetails(String vendorId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _featuredVendors.firstWhere((v) => v.id == vendorId);
    } catch (_) {
      // Dynamic fallback for any vendor id generated on the fly
      final name = vendorId.replaceFirst('vendor_', '').replaceAll('_', ' ');
      return VendorModel.fromBrand(name, 'Marketplace');
    }
  }
}
