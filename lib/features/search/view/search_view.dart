import 'package:fish_meat/features/search/providers/search_notifier.dart';
import 'package:fish_meat/features/search/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchProvider);
    final notifier = ref.read(searchProvider.notifier);

    // final category = state.selectedCategory;
    // final products = state.categorized[category] ?? [];

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                onChanged: notifier.search,
                decoration: InputDecoration(
                  hintText: "Search products...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Expanded(
              child: state.searchResult.isEmpty
                  ? const Center(child: Text("No Results"))
                  : GridView.builder(
                      itemCount: state.searchResult.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.62,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        final product = state.searchResult[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ProductCard(product: product),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}