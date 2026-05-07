import 'package:fish_meat/features/home/model/response/response_model.dart';

class ProductState {
  final bool isLoading;
  final List<Product> products;
  final Map<String, List<Product>> categorized;
  final String? selectedCategory;
  final String? error;

  ProductState({
    this.isLoading = false,
    this.products = const [],
    this.categorized = const {},
    this.selectedCategory,
    this.error,
  });

  ProductState copyWith({
    bool? isLoading,
    List<Product>? products,
    Map<String, List<Product>>? categorized,
    String? selectedCategory,
    String? error,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      categorized: categorized ?? this.categorized,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      error: error ?? this.error,
    );
  }
}