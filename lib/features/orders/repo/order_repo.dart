import 'package:fish_meat/features/orders/api/order_api.dart';
import 'package:fish_meat/features/orders/model/response/order_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderRepoProvider = Provider<OrderRepo>((ref) => OrderRepo());

class OrderRepo {
  final OrderApi _api = OrderApi();

  Future<OrderResponse?> getOrders() => _api.getOrders();
  Future<SingleOrderResponse?> getOrderById(String id) =>
      _api.getOrderById(id);
}