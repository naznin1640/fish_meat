import 'package:fish_meat/features/orders/model/response/order_response.dart';

class OrderState {
  final bool isLoading;
  final List<Order> orders;
  final Order? selectedOrder;
  final String? error;

  OrderState({
    this.isLoading = false,
    this.orders = const [],
    this.selectedOrder,
    this.error,
  });


List<Order> get activeOrders =>
    orders.where((o) => o.isActive && !o.isPreOrder).toList();

List<Order> get preOrders =>
    orders.where((o) => o.isPreOrder).toList();

  OrderState copyWith({
    bool? isLoading,
    List<Order>? orders,
    Order? selectedOrder,
    String? error,
  }) {
    return OrderState(
      isLoading: isLoading ?? this.isLoading,
      orders: orders ?? this.orders,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      error: error ?? this.error,
    );
  }
}