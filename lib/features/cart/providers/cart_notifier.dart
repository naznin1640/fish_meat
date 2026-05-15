import 'package:fish_meat/features/cart/model/response/cart_response.dart';
import 'package:fish_meat/features/cart/model/state/cart_state.dart';
import 'package:fish_meat/features/cart/repo/cart_repo.dart';
import 'package:fish_meat/features/home/model/response/response_model.dart';
import 'package:flutter_riverpod/legacy.dart';

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier(this.repo) : super(CartState());

  final CartRepo repo;

  CartItem fromProduct(Product product) => CartItem(
    id: product.id,
    productId: product.id,
    stock: product.stock,
    title: product.title,
    description: product.description,
    price: product.price,
    image: product.image,
    offerPrice: product.offerPrice,
    reviews: product.reviews ?? [],
    availability: product.availability,
    category: product.category,
  );

  Future<bool> addToCart(Product product) async {
    state = state.copyWith(isAdding: true, error: null);
    final item = fromProduct(product);
    final success = await repo.addToCart(item);
    if (success) {
      await fetchCart();
    } else {
      state.copyWith(isAdding: false, error: "failed add to cart");
    }
    return success;
  }

  Future<void> fetchCart() async {
    state = state.copyWith(isLoading: true, error: null);
    final res = await repo.getCart();
    if (res != null && res.success) {
      state = state.copyWith(
        isLoading: false,
        isAdding: false,
        items: res.data,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        isAdding: false,
        error: res?.message ?? "failed to load cart",
      );
    }
  }

  Future<void> removeFromCart(CartItem item) async {
    if (item.id == null) return;
    state = state.copyWith(isLoading: true);
    final success = await repo.removeFromCart(item.id!);
    if (success) {
      await fetchCart();
    } else {
      state = state.copyWith(isLoading: false, error: "Failed to remove item");
    }
  }

  Future<void> increaseQuantity(CartItem item) async {
    if (item.id == null) return;
    final success = await repo.increaseQuantity(item.id!);
    if (success) await fetchCart();
  }

  Future<void> decreaseQuantity(CartItem item) async {
    if (item.id == null) return;
    if (item.quantity <= 1) {
      await removeFromCart(item);
      return;
    }

    final success = await repo.decreaseQuantity(item.id!);
    if (success) await fetchCart();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier(ref.read(cartRepoProvider));
});
