import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../products/domain/usecases/get_products_by_vendor_usecase.dart';
import '../../domain/usecases/get_featured_vendors_usecase.dart';
import '../../domain/usecases/get_vendor_details_usecase.dart';
import 'vendor_event.dart';
import 'vendor_state.dart';

class VendorBloc extends Bloc<VendorEvent, VendorState> {
  final GetFeaturedVendorsUseCase _getFeaturedVendorsUseCase;
  final GetVendorDetailsUseCase _getVendorDetailsUseCase;
  final GetProductsByVendorUseCase _getProductsByVendorUseCase;

  VendorBloc({
    required GetFeaturedVendorsUseCase getFeaturedVendorsUseCase,
    required GetVendorDetailsUseCase getVendorDetailsUseCase,
    required GetProductsByVendorUseCase getProductsByVendorUseCase,
  })  : _getFeaturedVendorsUseCase = getFeaturedVendorsUseCase,
        _getVendorDetailsUseCase = getVendorDetailsUseCase,
        _getProductsByVendorUseCase = getProductsByVendorUseCase,
        super(const VendorInitialState()) {
    on<FetchFeaturedVendorsEvent>(_onFetchFeaturedVendors);
    on<FetchVendorStorefrontEvent>(_onFetchVendorStorefront);
  }

  Future<void> _onFetchFeaturedVendors(FetchFeaturedVendorsEvent event, Emitter<VendorState> emit) async {
    emit(const VendorLoadingState());
    try {
      final vendors = await _getFeaturedVendorsUseCase();
      emit(VendorLoadedState(featuredVendors: vendors));
    } catch (e) {
      emit(VendorErrorState(e.toString()));
    }
  }

  Future<void> _onFetchVendorStorefront(FetchVendorStorefrontEvent event, Emitter<VendorState> emit) async {
    VendorLoadedState current = state is VendorLoadedState
        ? state as VendorLoadedState
        : const VendorLoadedState();

    emit(current.copyWith(isStorefrontLoading: true));

    try {
      final vendor = await _getVendorDetailsUseCase(event.vendorId);
      final products = await _getProductsByVendorUseCase(event.vendorId);

      emit(current.copyWith(
        currentVendor: vendor,
        currentVendorProducts: products,
        isStorefrontLoading: false,
      ));
    } catch (e) {
      // In case vendor products fallback is needed
      emit(current.copyWith(
        isStorefrontLoading: false,
      ));
    }
  }
}
