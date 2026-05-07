import 'package:fish_meat/features/home/model/response/response_model.dart';

class SearchState {
  final String searchQuery;
  final List<Product> searchResult;
  final Map<String, List<Product>> categorized;
  final String? selectedCategory;
  
  SearchState({
    this.searchQuery = "",
    this.searchResult = const [],
    this.categorized  = const {},
    this.selectedCategory
  });

  SearchState copyWith({
    String? searchQuery,
    List<Product>? searchResult,
    Map<String, List<Product>>? categorized,
    String? selectedCategory
  }){
    return SearchState(
      searchQuery: searchQuery ?? this.searchQuery,
      searchResult: searchResult ?? this.searchResult,
      categorized: categorized ?? this.categorized,
      selectedCategory: selectedCategory ?? this.selectedCategory
    );
  }
}