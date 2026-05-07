
import 'package:fish_meat/features/cart/api/cart_api.dart';
import 'package:fish_meat/features/cart/model/response/cart_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartRepoProvider = Provider<CartRepo>((ref) => CartRepo());

class CartRepo {

final CartApi api = CartApi();

Future<bool> addToCart(CartItem item) async{
  return await api.addToCart(item);
}

Future<CartResponse?> getCart() async{
  return await api.getCart();
}

Future<bool> removeFromCart(String cartItemId) async{
  return await api.removeFromCart(cartItemId);
}

Future<bool> increaseQuantity( String cartItemId) async{
  return await api.increaseQuantity(cartItemId);
}

Future<bool> decreaseQuantity(String cartItemId) async{
  return await api.decreaseQuantity(cartItemId);
}

}
