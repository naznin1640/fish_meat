import 'package:fish_meat/core/constants/colors.dart';
import 'package:fish_meat/features/home/providers/product_notifier.dart';
import 'package:fish_meat/features/home/views/category_product_screen.dart';
import 'package:fish_meat/landing/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Homescreen extends ConsumerStatefulWidget {
  const Homescreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(productProvider.notifier).fetchProducts();
    });
  }

  void _navigateToCategory(BuildContext context, String categoryName) {
    final state = ref.read(productProvider);

    if (state.products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Still loading products...")),
      );
      return;
    }

    final notifier = ref.read(productProvider.notifier);
    notifier.selectCategory(notifier.normalize(categoryName));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CategoryProductScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      "Chicken",
      "Fresh Water Fish",
      "Salt Water Fish",
      "Pork",
      "Prawns",
      "Shell Fish",
      "Mutton",
    ];

    return Scaffold(
      appBar: AppBarWidget(title: "Categories"),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 5,
              children: categories.map((category) {
                return InkWell(
                  onTap: () => _navigateToCategory(context, category),
                  child: Container(
                    width: double.infinity,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      ConstantColors.blueClr,
                      ConstantColors.lightClr,
                    ],
                  ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}