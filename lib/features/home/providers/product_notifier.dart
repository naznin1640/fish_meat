import 'package:fish_meat/features/home/api/product_api.dart';
import 'package:fish_meat/features/home/model/state/product_state.dart';
import 'package:fish_meat/features/home/model/response/response_model.dart';
import 'package:fish_meat/features/home/repo/product_repo.dart';
import 'package:flutter_riverpod/legacy.dart';

class ProductNotifier extends StateNotifier<ProductState> {
  ProductNotifier(this.repo) : super(ProductState());

  final ProductRepo repo;

  String normalize(String value) {
    return value.toLowerCase().trim();
  }

 
  Future<void> fetchProducts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await repo.getProducts();

      if (response != null && response.success) {
        final products = response.data.products;

        final categorized = _categorize(products);

       
          print(" Products count: ${products.length}");
        print(" Categories: ${categorized.keys}");

        state = state.copyWith(
          isLoading: false,
          products: products,
          categorized: categorized,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response?.message ?? "Failed to load products",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  
  Map<String, List<Product>> _categorize(List<Product> products) {
    final Map<String, List<Product>> map = {};

    for (var product in products) {
      final category = normalize(product.category);

      map.putIfAbsent(category, () => []);
      map[category]!.add(product);
    }

    return map;
  }

  void selectCategory(String category) {
    final normalized = normalize(category);
    state = state.copyWith(selectedCategory: normalized);
  }
}


final productProvider =
    StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  return ProductNotifier(ProductRepo(ref.read(productApiProvider)));
});
