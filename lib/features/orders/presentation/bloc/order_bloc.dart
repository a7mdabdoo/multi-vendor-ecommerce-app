import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/order_usecases.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final GetOrdersUseCase _getOrdersUseCase;
  final PlaceOrderUseCase _placeOrderUseCase;

  OrderBloc({
    required GetOrdersUseCase getOrdersUseCase,
    required PlaceOrderUseCase placeOrderUseCase,
  })  : _getOrdersUseCase = getOrdersUseCase,
        _placeOrderUseCase = placeOrderUseCase,
        super(const OrderInitialState()) {
    on<LoadOrdersEvent>(_onLoadOrders);
    on<PlaceOrderEvent>(_onPlaceOrder);
  }

  Future<void> _onLoadOrders(LoadOrdersEvent event, Emitter<OrderState> emit) async {
    emit(const OrderLoadingState());
    try {
      final orders = await _getOrdersUseCase();
      emit(OrderLoadedState(orders: orders));
    } catch (e) {
      emit(OrderErrorState(e.toString()));
    }
  }

  Future<void> _onPlaceOrder(PlaceOrderEvent event, Emitter<OrderState> emit) async {
    emit(const OrderLoadingState());
    try {
      final placed = await _placeOrderUseCase(event.order);
      emit(OrderSuccessState(placed));
      // Re-fetch orders so history is updated
      final allOrders = await _getOrdersUseCase();
      emit(OrderLoadedState(orders: allOrders, lastPlacedOrder: placed));
    } catch (e) {
      emit(OrderErrorState(e.toString()));
    }
  }
}
