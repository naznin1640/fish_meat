import 'package:fish_meat/core/constants/api_constants.dart';
import 'package:fish_meat/core/constants/colors.dart';
import 'package:fish_meat/features/cart/model/response/cart_response.dart';
import 'package:fish_meat/features/cart/model/state/cart_state.dart';
import 'package:fish_meat/features/cart/providers/cart_notifier.dart';
import 'package:fish_meat/landing/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {

   @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(cartProvider.notifier).fetchCart());
  }
  
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cartProvider);
    return Scaffold(
      appBar: const AppBarWidget(title: "My Cart"),
      body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30)
          ),
          child: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.items.isEmpty
          ? buildEmptyCart()
          : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: state.items.length,
                  itemBuilder:(context, index){
                    return _CartItemCard(item: state.items[index]);
                  } )),
                  buildOrderSummary(state),
            ],
          )
        ),
    );
  }
}

  Widget buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to get started',
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }


Widget buildOrderSummary(CartState state){
  return Container(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      boxShadow: [BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 16,
        offset: Offset(0, -4)
      )
    ]),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${state.totalItems} items${state.totalItems != 1 ? 's' : ''}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
             Text(
                '₹${state.totalPrice}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: ConstantColors.blueClr,
                ),
              ),
          ],
        ),

        SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: (){},
          style: ElevatedButton.styleFrom(
                backgroundColor: ConstantColors.blueClr,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
           child:Text('proceed to checkout',
           style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white
           ),) ),
        )
      ],
    ),
  );
}


class _CartItemCard extends ConsumerWidget {
  final CartItem item;
  const _CartItemCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(cartProvider.notifier);
    final hasOffer = item.offerPrice != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
       
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "${ApiConstants.imageBaseUrl}/${item.image}",
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: const Color(0xFFEEF2F7),
                  child: Icon(Icons.set_meal_rounded,
                      color: Colors.grey[300], size: 36),
                ),
              ),
            ),

            const SizedBox(width: 12),

            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A2B3C),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.category,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (hasOffer)
                            Text(
                              '₹${item.price}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[400],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Text(
                            hasOffer
                                ? '₹${item.offerPrice}'
                                : '₹${item.price}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ConstantColors.blueClr,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _QtyButton(
                            icon: Icons.remove,
                            onTap: () => notifier.decreaseQuantity(item),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _QtyButton(
                            icon: Icons.add,
                            onTap: () => notifier.increaseQuantity(item),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: () => notifier.removeFromCart(item),
              icon: Icon(Icons.delete_outline, color: Colors.red[400]),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: ConstantColors.blueClr,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}