import 'package:fish_meat/core/constants/api_constants.dart';
import 'package:fish_meat/core/constants/colors.dart';
import 'package:fish_meat/features/cart/providers/cart_notifier.dart';
import 'package:fish_meat/features/home/model/response/response_model.dart';
import 'package:fish_meat/features/home/widgets/review_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ProductDetailScreen extends ConsumerWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasOffer = product.offerPrice != null;
    final reviews = product.reviews ?? [];
    final isAdding = ref.watch(cartProvider).isAdding;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                     width: double.infinity,
                      height: 400,
                    child: Image.network( 
                      fit: BoxFit.cover,
                      "${ApiConstants.imageBaseUrl}/${product.image}",
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFEEF2F7),
                        child: Icon(
                          Icons.set_meal_rounded,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: product.stock <= 5 ? Colors.red : Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.stock <= 5
                          ? 'only ${product.stock} leftt'
                          : 'In Stock (${product.stock})',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(product.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color:Color(0xFF1A2B3C) ),)),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (hasOffer)
                        Text(
                          '₹${product.price}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough
                          ),
                        ),
                        Text(hasOffer
                        ? '${product.offerPrice}'
                        : "₹${product.price}",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: ConstantColors.blueClr
                        ),)
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4
                  ),
                  decoration: BoxDecoration(
                    color: ConstantColors.blueClr.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text(product.category,
                  style: TextStyle(
                    fontSize: 12,
                    color: ConstantColors.blueClr,
                    fontWeight: FontWeight.w600
                  ),),
                ),
              ),
              SizedBox(height: 16,),
              if(reviews.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      ...List.generate(5, (i){
                        final avg = reviews
                        .map((r) => r.rating)
                        .reduce((a,b) => a + b) /
                        reviews.length;
                        return Icon(
                          i < avg.floor()
                          ? Icons.star_rounded
                          : (i < avg
                          ? Icons.star_half_rounded
                          :Icons.star_outline_rounded),
                          color: Color(0xFFFFC107),
                          size: 20,
                        );
                      }),
                      SizedBox(width: 8),
                      Text(
                        '${(reviews.map((r) => r.rating).reduce((a,b) => a+b) / reviews.length).toStringAsFixed(1)} (${reviews.length} reviews)',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 16,)
              ],
              const Divider(),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ConstantColors.blueClr
                ),),
              ),
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF757575),
                    height: 1.6
                  ),
                ),
              ),
               const SizedBox(height: 20),
               if(reviews.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Customer Reviews",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ConstantColors.blueClr,
                  ),),
                ),
                ...reviews.map((review) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ReviewCard(review: review),
                )),
               ],
                const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
         padding: const EdgeInsets.only(bottom: 49, left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, -4)
          )]
        ),
        child: ElevatedButton.icon(
          onPressed: isAdding
          ? null
          : () async{
            final success = await ref
            .read(cartProvider.notifier).addToCart(product);
            if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${product.title} added to cart!'),
                backgroundColor: ConstantColors.blueClr,
              ),
            );
            }
        }, 
        icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
        label: const Text(
            'Add to Cart',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: ConstantColors.blueClr,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          ),
      ),
    );
  }
}
