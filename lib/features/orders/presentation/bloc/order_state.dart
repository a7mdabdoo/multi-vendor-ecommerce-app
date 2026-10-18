import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitialState extends OrderState {
  const OrderInitialState();
}

class OrderLoadingState extends OrderState {
  const OrderLoadingState();
}

class OrderLoadedState extends OrderState {
  final List<OrderEntity> orders;
  final OrderEntity? lastPlacedOrder;

  const OrderLoadedState({
    required this.orders,
    this.lastPlacedOrder,
  });

  @override
  List<Object?> get props => [orders, lastPlacedOrder];
}

class OrderSuccessState extends OrderState {
  final OrderEntity order;

  const OrderSuccessState(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderErrorState extends OrderState {
  final String message;

  const OrderErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
