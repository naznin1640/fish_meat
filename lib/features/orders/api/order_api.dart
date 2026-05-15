import 'package:dio/dio.dart';
import 'package:fish_meat/core/services/api_services.dart';
import 'package:fish_meat/features/orders/model/response/order_response.dart';

class OrderApi {
  final Dio dio = ApiServices().dio;

  Future<OrderResponse?> getOrders() async{
    try {
      final res = await dio.get('/orders');
      return OrderResponse.fromJson(res.data);
    }on DioException catch (e) {
      print("get orders error: ${e.response?.data}");
      return null;
    }
  }

  Future<SingleOrderResponse?> getOrderById(String id) async{
    try {
      final res = await dio.get('/orders/$id');
      return SingleOrderResponse.fromJson(res.data);
    }on DioException catch (e) {
      print("get order error: ${e.response?.data}");
      return null;
    }
  }
}