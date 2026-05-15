import 'package:fish_meat/features/home/providers/product_notifier.dart';
import 'package:fish_meat/features/search/model/state/search_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier(this.ref): super(SearchState());

  final Ref ref;

 void search(String query){
  final products = ref.read(productProvider).products;

  final lowerQuery = query.toLowerCase();
  

  final result = products.where((products){
    return products.title.toLowerCase().contains(lowerQuery) ||
    products.category.toLowerCase().contains(lowerQuery);
  }).toList();

  state = state.copyWith(
    searchQuery: query,
    searchResult: result
  );
 }
}

final searchProvider = StateNotifierProvider<SearchNotifier,SearchState >((ref) =>
  SearchNotifier(ref)
);
