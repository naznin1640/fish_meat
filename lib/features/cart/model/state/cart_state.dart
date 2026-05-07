import 'package:fish_meat/features/cart/model/response/cart_response.dart';

class CartState {
  final bool isLoading;
  final bool isAdding;
  final List<CartItem> items;
  final String? error;

  CartState({
    this.isLoading = false,
    this.isAdding = false,
    this.items = const [],
    this.error,
  });

  int get totalItems => items.fold<int>(0, (sum, item) => sum + item.quantity);

  int get totalPrice => items.fold<int>(
        0,
        (sum, item) {
          int price;
          if (item.offerPrice != null) {
            price = (item.offerPrice is num)
                ? (item.offerPrice as num).toInt()
                : int.tryParse(item.offerPrice.toString()) ?? item.price;
          } else {
            price = item.price;
          }
          return sum + (price * item.quantity);
        },
      );

  CartState copyWith({
    bool? isLoading,
    bool? isAdding,
    List<CartItem>? items,
    String? error,
  }) {
    return CartState(
      isLoading: isLoading ?? this.isLoading,
      isAdding: isAdding ?? this.isAdding,
      items: items ?? this.items,
      error: error ?? this.error,
    );
  }
}
