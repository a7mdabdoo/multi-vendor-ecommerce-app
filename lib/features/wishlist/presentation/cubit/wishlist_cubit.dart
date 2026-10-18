import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/storage_service.dart';

class WishlistCubit extends Cubit<Set<int>> {
  final StorageService _storageService;

  WishlistCubit(this._storageService) : super({}) {
    _loadWishlist();
  }

  void _loadWishlist() {
    final ids = _storageService.getWishlist();
    final parsed = ids.map((id) => int.tryParse(id)).whereType<int>().toSet();
    emit(parsed);
  }

  Future<void> toggleWishlist(int productId) async {
    final updated = Set<int>.from(state);
    if (updated.contains(productId)) {
      updated.remove(productId);
    } else {
      updated.add(productId);
    }
    await _storageService.saveWishlist(updated.map((e) => e.toString()).toList());
    emit(updated);
  }

  bool isFavorite(int productId) => state.contains(productId);
}
