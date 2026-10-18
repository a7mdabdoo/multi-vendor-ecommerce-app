import 'package:equatable/equatable.dart';

class VendorEntity extends Equatable {
  final String id;
  final String name;
  final String logoUrl;
  final String bannerUrl;
  final double rating;
  final int reviewsCount;
  final String description;
  final bool isVerified;
  final String location;
  final String joinedDate;
  final int followersCount;
  final String shippingPolicy;

  const VendorEntity({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.bannerUrl,
    required this.rating,
    required this.reviewsCount,
    required this.description,
    this.isVerified = true,
    this.location = 'Global Logistics Center',
    this.joinedDate = 'Member since 2022',
    this.followersCount = 8500,
    this.shippingPolicy = 'Dispatched within 24 hours. Express tracked delivery.',
  });

  @override
  List<Object?> get props => [
        id,
        name,
        logoUrl,
        bannerUrl,
        rating,
        reviewsCount,
        description,
        isVerified,
        location,
        joinedDate,
        followersCount,
        shippingPolicy,
      ];
}
