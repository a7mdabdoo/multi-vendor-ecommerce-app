import 'package:equatable/equatable.dart';

abstract class VendorEvent extends Equatable {
  const VendorEvent();

  @override
  List<Object?> get props => [];
}

class FetchFeaturedVendorsEvent extends VendorEvent {
  const FetchFeaturedVendorsEvent();
}

class FetchVendorStorefrontEvent extends VendorEvent {
  final String vendorId;

  const FetchVendorStorefrontEvent(this.vendorId);

  @override
  List<Object?> get props => [vendorId];
}
