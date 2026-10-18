import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/usecases/cart_usecases.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase _getCartUseCase;
  final SaveCartUseCase _saveCartUseCase;
  final ClearCartUseCase _clearCartUseCase;

  CartBloc({
    required GetCartUseCase getCartUseCase,
    required SaveCartUseCase saveCartUseCase,
    required ClearCartUseCase clearCartUseCase,
  })  : _getCartUseCase = getCartUseCase,
        _saveCartUseCase = saveCartUseCase,
        _clearCartUseCase = clearCartUseCase,
        super(const CartInitialState()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateCartQuantityEvent>(_onUpdateQuantity);
    on<ClearCartEvent>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(const CartLoadingState());
    try {
      final items = await _getCartUseCase();
      emit(CartLoadedState(cart: CartEntity(items: items)));
    } catch (e) {
      emit(CartErrorState(e.toString()));
    }
  }

  Future<void> _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    List<CartItemEntity> currentItems = [];
    if (state is CartLoadedState) {
      currentItems = List.from((state as CartLoadedState).cart.items);
    } else {
      currentItems = await _getCartUseCase();
    }

    final existingIndex = currentItems.indexWhere((item) => item.product.id == event.product.id);
    if (existingIndex != -1) {
      final existingItem = currentItems[existingIndex];
      currentItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + event.quantity,
      );
    } else {
      currentItems.add(
        CartItemEntity(
          product: event.product,
          quantity: event.quantity,
          selectedVariant: event.selectedVariant,
        ),
      );
    }

    await _saveCartUseCase(currentItems);
    emit(CartLoadedState(
      cart: CartEntity(items: currentItems),
      notificationMessage: '${event.product.title} added to cart',
    ));
  }

  Future<void> _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) async {
    if (state is CartLoadedState) {
      final currentItems = List<CartItemEntity>.from((state as CartLoadedState).cart.items);
      currentItems.removeWhere((item) => item.product.id == event.productId);

      await _saveCartUseCase(currentItems);
      emit(CartLoadedState(
        cart: CartEntity(items: currentItems),
        notificationMessage: 'Item removed from cart',
      ));
    }
  }

  Future<void> _onUpdateQuantity(UpdateCartQuantityEvent event, Emitter<CartState> emit) async {
    if (state is CartLoadedState) {
      final currentItems = List<CartItemEntity>.from((state as CartLoadedState).cart.items);
      final index = currentItems.indexWhere((item) => item.product.id == event.productId);

      if (index != -1) {
        if (event.newQuantity <= 0) {
          currentItems.removeAt(index);
        } else {
          currentItems[index] = currentItems[index].copyWith(quantity: event.newQuantity);
        }

        await _saveCartUseCase(currentItems);
        emit(CartLoadedState(cart: CartEntity(items: currentItems)));
      }
    }
  }

  Future<void> _onClearCart(ClearCartEvent event, Emitter<CartState> emit) async {
    await _clearCartUseCase();
    emit(const CartLoadedState(cart: CartEntity(items: [])));
  }
}
