import 'package:fish_meat/features/orders/model/state/order_state.dart';
import 'package:fish_meat/features/orders/repo/order_repo.dart';
import 'package:flutter_riverpod/legacy.dart';

class OrderNotifier extends StateNotifier<OrderState> {
  OrderNotifier(this.repo) : super(OrderState());

  final OrderRepo repo;

  Future<void> fetchOrders() async {
    state = state.copyWith(isLoading: true, error: null);
    final response = await repo.getOrders();
    if (response != null && response.success) {
      state = state.copyWith(isLoading: false, orders: response.data);
    } else {
      state = state.copyWith(
        isLoading: false,
        error: response?.message ?? "Failed to load orders",
      );
    }
  }

  Future<void> fetchOrderById(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    final response = await repo.getOrderById(id);
    if (response != null && response.success) {
      state = state.copyWith(isLoading: false, selectedOrder: response.data);
    } else {
      state = state.copyWith(
        isLoading: false,
        error: response?.message ?? "Failed to load order",
      );
    }
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  return OrderNotifier(ref.read(orderRepoProvider));
});