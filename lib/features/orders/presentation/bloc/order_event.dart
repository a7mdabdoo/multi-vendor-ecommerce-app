import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrdersEvent extends OrderEvent {
  const LoadOrdersEvent();
}

class PlaceOrderEvent extends OrderEvent {
  final OrderEntity order;

  const PlaceOrderEvent(this.order);

  @override
  List<Object?> get props => [order];
}
