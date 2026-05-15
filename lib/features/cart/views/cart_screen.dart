import 'package:fish_meat/core/constants/api_constants.dart';
import 'package:fish_meat/core/constants/colors.dart';
import 'package:fish_meat/features/cart/model/response/cart_response.dart';
import 'package:fish_meat/features/cart/model/state/cart_state.dart';
import 'package:fish_meat/features/cart/providers/cart_notifier.dart';
import 'package:fish_meat/features/orders/providers/order_notifier.dart';
import 'package:fish_meat/features/profile/provider/profile_notifier.dart';
import 'package:fish_meat/shared/services/razorpay_helper.dart';
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

  void _showCheckoutBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CheckoutBottomSheet(ref: ref),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cartProvider);
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.items.isEmpty
            ? buildEmptyCart()
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        return _CartItemCard(item: state.items[index]);
                      },
                    ),
                  ),
                  buildOrderSummary(context, state, _showCheckoutBottomSheet),
                ],
              ),
      ),
    );
  }
}

class CheckoutBottomSheet extends ConsumerStatefulWidget {
  final WidgetRef ref;
  const CheckoutBottomSheet({super.key, required this.ref});

  @override
  ConsumerState<CheckoutBottomSheet> createState() =>
      _CheckoutBottomSheetState();
}

class _CheckoutBottomSheetState extends ConsumerState<CheckoutBottomSheet> {
  final _addressCtrl = TextEditingController();
  final _pincodeCtrl = TextEditingController();
  late RazorpayHelper _razorpayHelper;
  bool _isPreOrder = false;
  String? _selectedPreOrderDate;

  List<Map<String, String>> _savedAddresses = [];
  String? _selectedAddressKey;

  @override
  void initState() {
    super.initState();

    _razorpayHelper = RazorpayHelper(
      onSuccess: () {
        ref.read(cartProvider.notifier).fetchCart();
        ref.read(orderProvider.notifier).fetchOrders();
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Payment successful! Order placed."),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      onFailure: () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Payment failed. Please try again."),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );

    Future.microtask(() async {
      await ref.read(profileProvider.notifier).fetchUser();
      final user = ref.read(profileProvider).user;
      if (user != null) {
        final List<Map<String, String>> addresses = [];
        if ((user.address ?? '').isNotEmpty &&
            (user.pincode ?? '').isNotEmpty) {
          addresses.add({
            'label': 'Saved Address',
            'address': user.address!,
            'pincode': user.pincode!,
          });
        }
        if (mounted) {
          setState(() {
            _savedAddresses = addresses;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _razorpayHelper.dispose();
    _addressCtrl.dispose();
    _pincodeCtrl.dispose();
    super.dispose();
  }

  void _onSelectAddress(Map<String, String> addr) {
    setState(() {
      _selectedAddressKey = addr['label'];
      _addressCtrl.text = addr['address'] ?? '';
      _pincodeCtrl.text = addr['pincode'] ?? '';
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );

    if (picked != null) {
      setState(() {
        _selectedPreOrderDate =
            "${picked.day.toString().padLeft(2, '0')}/ ${picked.month.toString().padLeft(2, '0')}/ ${picked.year}";
      });
    }
  }

  void _placeOrder() async {
    if (_addressCtrl.text.trim().isEmpty || _pincodeCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter delivery address and pincode"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_isPreOrder && _selectedPreOrderDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("select a delivery date for pre-order"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final cartState = ref.read(cartProvider);
    final user = ref.read(profileProvider).user;

    debugPrint("Place order tapped");
    debugPrint("Address: ${_addressCtrl.text.trim()}");
    debugPrint("Pincode: ${_pincodeCtrl.text.trim()}");

    await _razorpayHelper.openCheckout(
      amount: cartState.totalPrice.toDouble(),
      name: 'Fish & Meat',
      description: 'Cart Payment',
      contact: '9999999999',
      email: user?.email ?? 'user@example.com',
      address: _addressCtrl.text.trim(),
      pincode: _pincodeCtrl.text.trim(),
      discountAmount: 222,
      preOrder: _isPreOrder ? _selectedPreOrderDate : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 24 + bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Checkout",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A2B3C),
              ),
            ),
            const SizedBox(height: 20),

            if (_savedAddresses.isNotEmpty) ...[
              const Text(
                "Select a saved address",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A2B3C),
                ),
              ),
              const SizedBox(height: 10),
              ..._savedAddresses.map((addr) {
                final isSelected = _selectedAddressKey == addr['label'];
                return GestureDetector(
                  onTap: () => _onSelectAddress(addr),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ConstantColors.blueClr.withOpacity(0.07)
                          : Colors.grey[50],
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? ConstantColors.blueClr
                            : Colors.grey[200]!,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: isSelected
                              ? ConstantColors.blueClr
                              : Colors.grey[400],
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                addr['label'] ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: isSelected
                                      ? ConstantColors.blueClr
                                      : const Color(0xFF1A2B3C),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "${addr['address']}, ${addr['pincode']}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: ConstantColors.blueClr,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 6),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "or enter manually",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 14),
            ],

            TextField(
              controller: _addressCtrl,
              decoration: InputDecoration(
                labelText: "Delivery Address",
                prefixIcon: Icon(
                  Icons.home_outlined,
                  color: ConstantColors.blueClr,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: ConstantColors.blueClr,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _pincodeCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Pincode",
                prefixIcon: Icon(
                  Icons.pin_drop_outlined,
                  color: ConstantColors.blueClr,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: ConstantColors.blueClr,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEEEEEE)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: ConstantColors.blueClr,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Schedule pre-order",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: _isPreOrder,
                        activeThumbColor: ConstantColors.blueClr,
                        onChanged: (val) {
                          setState(() {
                            _isPreOrder = val;
                            if (!val) _selectedPreOrderDate = null;
                          });
                        },
                      ),
                    ],
                  ),

                  if (_isPreOrder) ...[
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: ConstantColors.blueClr),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: ConstantColors.blueClr,
                              size: 18,
                            ),
                            SizedBox(width: 10),
                            Text(
                              _selectedPreOrderDate ?? "selected deliver date",
                              style: TextStyle(
                                fontSize: 14,
                                color: _selectedPreOrderDate != null
                                    ? const Color(0xFF1A2B3C)
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${cartState.totalItems} item${cartState.totalItems != 1 ? 's' : ''}",
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
                Text(
                  "Total: ₹${cartState.totalPrice}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ConstantColors.blueClr,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ConstantColors.blueClr,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Pay Now",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
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

Widget buildOrderSummary(
  BuildContext context,
  CartState state,
  VoidCallback onCheckout,
) {
  return Container(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 16,
          offset: const Offset(0, -4),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${state.totalItems} item${state.totalItems != 1 ? 's' : ''}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
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
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onCheckout,
            style: ElevatedButton.styleFrom(
              backgroundColor: ConstantColors.blueClr,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Proceed to Checkout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
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
                  child: Icon(
                    Icons.set_meal_rounded,
                    color: Colors.grey[300],
                    size: 36,
                  ),
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
                            hasOffer ? '₹${item.offerPrice}' : '₹${item.price}',
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
                            padding: const EdgeInsets.symmetric(horizontal: 12),
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
