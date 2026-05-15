import 'package:dio/dio.dart';
import 'package:fish_meat/shared/services/api_services.dart';
import 'package:fish_meat/features/cart/model/response/cart_response.dart';

class CartApi {
  final Dio dio = ApiServices().dio;

  static String cart = "/carts";

  Future<bool> addToCart(CartItem item) async {
    try {
      final res = await dio.post(cart, data: item.toRequestBody());
      return res.data["success"] == true;
    } on DioException catch (e) {
      print("ADD TO CART ERROR: ${e.response?.data}");
      return false;
    }
  }

  Future<CartResponse?> getCart() async {
    try {
      final res = await dio.get(cart);
      return CartResponse.fromJson(res.data);
    } on DioException catch (e) {
      print("Get cart error: ${e.response?.data}");
      return null;
    }
  }

  Future<bool> removeFromCart(String cartItemId) async {
    try {
      final res = await dio.delete('$cart/$cartItemId');
      return res.data["success"] == true;
    } on DioException catch (e) {
      print("REMOVE FROM CART ERROR: ${e.response?.data}");
      return false;
    }
  }

  Future<bool> increaseQuantity(String cartItemId) async {
    try {
      final res = await dio.get('$cart/$cartItemId/increase');
      return res.data["success"] == true;
    } on DioException catch (e) {
      print("increse quantity error: ${e.response?.data}");
      return false;
    }
  }

  Future<bool> decreaseQuantity(String cartItemId) async {
    try {
      final res = await dio.get('$cart/$cartItemId/decrease');
      return res.data["success"] == true;
    } on DioException catch (e) {
      print("decrese quantity error: ${e.response?.data} ");
      return false;
    }
  }
}
