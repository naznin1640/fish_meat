import 'package:fish_meat/core/constants/api_constants.dart';
import 'package:fish_meat/core/constants/colors.dart';
import 'package:fish_meat/features/orders/model/response/order_response.dart';
import 'package:fish_meat/features/orders/providers/order_notifier.dart';
import 'package:fish_meat/features/orders/view/order_detail_screen.dart';
import 'package:fish_meat/features/landing/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      ref.read(orderProvider.notifier).fetchOrders();
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderProvider);

    return Scaffold(
      appBar: AppBarWidget(
        title: "My Orders",
        actions: [
          Icon(Icons.notifications, color: Colors.white,size: 28,)
        ],
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: [
            Tab(text: "Active (${state.activeOrders.length})"),
            Tab(text: "Pre-orders (${state.preOrders.length})"),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.error != null
                ? _buildError(state.error!)
                : TabBarView(
                    controller: tabController,
                    children: [
                      OrderList(
                        orders: state.activeOrders,
                        emptyMessage: "No active orders",
                        emptyIcon: Icons.receipt_outlined,
                        type: OrderType.active,
                      ),
                      OrderList(
                        orders: state.preOrders,
                        emptyMessage: "No pre-orders yet",
                        emptyIcon: Icons.calendar_today_outlined,
                        type: OrderType.preorder,
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 10),
          Text(error),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () => ref.read(orderProvider.notifier).fetchOrders(),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}

enum OrderType {active, preorder}

class OrderList extends StatelessWidget {
  final List<Order> orders;
  final String emptyMessage;
  final IconData emptyIcon;
  final OrderType type;

  const OrderList({
    super.key,
    required this.orders,
    required this.emptyMessage,
    required this.emptyIcon,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(emptyIcon, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 10),
            Text(
              emptyMessage,
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await (context as Element)
            .findAncestorStateOfType<_OrderScreenState>()
            ?.ref
            .read(orderProvider.notifier)
            .fetchOrders();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return OrderCard(order: orders[index], type: type);
        },
      ),
    );
  }
}




class OrderCard extends ConsumerWidget {
  final Order order;
  final OrderType type;

  const OrderCard({super.key, required this.order, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OrderDetailScreen(orderId: order.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: getStatusColor(order.status).withOpacity(0.1),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order #${order.id.substring(order.id.length - 6)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),

                      Text(
                        DateFormat('dd MMM yyyy').format(order.date),
                        style: const TextStyle(fontSize: 12),
                      ),
                      if (order.isPreOrder && order.preOrder != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.schedule,
                                  size: 12, color: Colors.purple),
                              const SizedBox(width: 4),
                              Text(
                                "Scheduled:${order.preOrder!}",
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      StatusBadge(
                          status: order.status, label: order.statusLabel),
                      if (order.isPreOrder)
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: PreOrderBadge(),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  ...order.items.take(2).map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  "${ApiConstants.imageBaseUrl}/${item.image}",
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.image),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "Qty: ${item.quantity}",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "₹${item.price * item.quantity}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ConstantColors.blueClr,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  if (order.items.length > 2)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "+${order.items.length - 2} more items",
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ),
                  const Divider(height: 20),
                  if (type == OrderType.active)
                    ProgressTracker(status: order.status),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Total Amount",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[500])),
                          Text(
                            "₹${order.amount}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ConstantColors.blueClr,
                            ),
                          ),
                        ],
                      ),
                      if (type == OrderType.active)
                        ActionButton(
                          label: "Track",
                          icon: Icons.location_on_outlined,
                          color: ConstantColors.blueClr,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    OrderDetailScreen(orderId: order.id),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PreOrderBadge extends StatelessWidget {
  const PreOrderBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule, size: 10, color: Colors.purple),
          SizedBox(width: 3),
          Text(
            "Pre-order",
            style: TextStyle(
              color: Colors.purple,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String status;
  final String label;

  const StatusBadge({super.key, required this.status, required this.label});

  @override
  Widget build(BuildContext context) {
    final color = getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}

class ProgressTracker extends StatelessWidget {
  final String status;

  const ProgressTracker({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = ["Confirmed", "Packed", "On the way", "Delivered"];
    int currentStep = 0;
    if (status == "PACKED") currentStep = 1;
    else if (status == "ON_THE_WAY") currentStep = 2;
    else if (status == "DELIVERED") currentStep = 3;

    return Row(
      children: List.generate(steps.length, (index) {
        final completed = index <= currentStep;
        return Expanded(
          child: Column(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor:
                    completed ? ConstantColors.blueClr : Colors.grey[300],
                child: const Icon(Icons.check, size: 14, color: Colors.white),
              ),
              const SizedBox(height: 5),
              Text(
                steps[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: completed ? ConstantColors.blueClr : Colors.grey,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 5),
            Text(label,
                style:
                    TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

Color getStatusColor(String status) {
  switch (status) {
    case "PAID":
    case "CONFIRMED":
      return Colors.orange;
    case "PACKED":
    case "ON_THE_WAY":
      return Colors.blue;
    case "DELIVERED":
      return Colors.green;
    default:
      return Colors.grey;
  }
}

