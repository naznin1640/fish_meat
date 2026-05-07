import 'package:fish_meat/core/constants/colors.dart';
import 'package:fish_meat/features/home/providers/product_notifier.dart';
import 'package:fish_meat/features/home/views/product_detail_screen.dart';
import 'package:fish_meat/features/search/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryProductScreen extends ConsumerWidget {
  const CategoryProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productProvider);

    if (state.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final category = state.selectedCategory;
    final products = state.categorized[category] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: ConstantColors.blueClr,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: FlexibleSpaceBar(
          title: Text(
            category?.toUpperCase() ?? "",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 0.5,
            ),
          ),
          background: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [ConstantColors.blueClr, ConstantColors.lightClr],
              ),
            ),
          ),
        ),
      ),
      body: products.isEmpty
          ? const Center(child: Text("No Products"))
          : GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                 childAspectRatio: 0.62,
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context, MaterialPageRoute(
                          builder:(context)=> ProductDetailScreen(product:products[index],) ));
                    },
                    child: ProductCard(product: products[index])),
                );
              },
            ),
    );
  }
}


