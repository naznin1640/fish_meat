

class OrderResponse {
  final bool success;
  final String message;
  final List<Order> data;

  OrderResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json["data"];
    List<Order> orders = [];
    if (dataList is List) {
      orders = dataList.map((x) => Order.fromJson(x)).toList();
    }
    return OrderResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: orders,
    );
  }
}

class SingleOrderResponse {
  final bool success;
  final String message;
  final Order? data;

  SingleOrderResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory SingleOrderResponse.fromJson(Map<String, dynamic> json) =>
      SingleOrderResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null ? null : Order.fromJson(json["data"]),
      );
}

class Order {
  final String id;
  final String userId;
  final int amount;
  final int? discountAmount;
  final String status;
  final DateTime date;
  final List<OrderItem> items;
  final String? address;
  final String? pincode;
  final String? razorpayOrderId;
  final String? paymentId;
  final String? preOrder;

  Order({
    required this.id,
    required this.userId,
    required this.amount,
    this.discountAmount,
    required this.status,
    required this.date,
    required this.items,
    this.address,
    this.pincode,
    this.razorpayOrderId,
    this.paymentId,
    this.preOrder,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"]?.toString() ?? "",
        userId: json["userId"]?.toString() ?? "",
        amount: ((json["amount"] ?? 0) as num).toInt(),
        discountAmount: json["discountAmount"] != null
            ? ((json["discountAmount"]) as num).toInt()
            : null,
        status: json["status"]?.toString() ?? "PAID",
        date: DateTime.tryParse(json["date"]?.toString() ?? "") ?? DateTime.now(),
        items: json["items"] is List
            ? (json["items"] as List)
                .map((x) => OrderItem.fromJson(x))
                .toList()
            : [],
        address: json["address"]?.toString(),
        pincode: json["pincode"]?.toString(),
        razorpayOrderId: json["razorpayOrderId"]?.toString(),
        paymentId: json["paymentId"]?.toString(),
        preOrder: (json["preOrder"] == null ||
        json["preOrder"].toString() == "null" ||
        json["preOrder"].toString().isEmpty)
    ? null
    : json["preOrder"].toString(),
        );
       

       
  bool get isActive =>
      status == "PAID" ||
      status == "PENDING" ||
      status == "CONFIRMED" ||
      status == "PACKED" ||
      status == "ON_THE_WAY";

  bool get isDelivered => status == "DELIVERED";

  bool get isPreOrder => preOrder != null && preOrder!.isNotEmpty && preOrder != "null";

  String get statusLabel {
    switch (status) {
      case "PAID":
        return "Confirmed";
      case "CONFIRMED":
        return "Confirmed";
      case "PACKED":
        return "Packed";
      case "ON_THE_WAY":
        return "On the way";
      case "DELIVERED":
        return "Delivered";
      case "CANCELLED":
        return "Cancelled";
      default:
        return status;
    }
  }
}

class OrderItem {
  final String id;
  final String productId;
  final int quantity;
  final String title;
  final String description;
  final int price;
  final dynamic offerPrice;
  final String? image;
  final String category;

  OrderItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.title,
    required this.description,
    required this.price,
    this.offerPrice,
    this.image,
    required this.category,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json["id"]?.toString() ?? "",
        productId: json["productId"]?.toString() ?? "",
        quantity: ((json["quantity"] ?? 1) as num).toInt(),
        title: json["title"]?.toString() ?? "",
        description: json["description"]?.toString() ?? "",
        price: ((json["price"] ?? 0) as num).toInt(),
        offerPrice: json["offerPrice"],
        image: json["image"]?.toString(),
        category: json["category"]?.toString() ?? "",
      );
}