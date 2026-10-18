import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_entity.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitialState extends CartState {
  const CartInitialState();
}

class CartLoadingState extends CartState {
  const CartLoadingState();
}

class CartLoadedState extends CartState {
  final CartEntity cart;
  final String? notificationMessage;

  const CartLoadedState({
    required this.cart,
    this.notificationMessage,
  });

  @override
  List<Object?> get props => [cart, notificationMessage];

  CartLoadedState copyWith({
    CartEntity? cart,
    String? notificationMessage,
  }) {
    return CartLoadedState(
      cart: cart ?? this.cart,
      notificationMessage: notificationMessage,
    );
  }
}

class CartErrorState extends CartState {
  final String message;

  const CartErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
