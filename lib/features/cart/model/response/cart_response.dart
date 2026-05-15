class CartResponse {
  final bool success;
  final String message;
  final List<CartItem> data;

  CartResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json["data"];
    List<CartItem> items = [];
    if (dataList is List) {
      items = dataList.map((x) => CartItem.fromJson(x)).toList();
    }
    return CartResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: items,
    );
  }
}

class CartItem {
  final String? id;      
  final String? userId;
  final String productId;
  final String title;
  final String description;
  final int price;
  final dynamic offerPrice;
  final String image;
  final int stock;
  final List reviews;
  final List availability;
  final String category;
  final int quantity;

  CartItem({
    this.id,
    this.userId,
    required this.productId,
    required this.title,
    required this.description,
    required this.price,
    this.offerPrice,
    required this.image,
    required this.stock,
    required this.reviews,
    required this.availability,
    required this.category,
    this.quantity = 1,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json["id"]?.toString(),         // server returns "id" not "_id"
        userId: json["userId"]?.toString(),
        productId: json["productId"]?.toString() ?? "",
        title: json["title"]?.toString() ?? "",
        description: json["description"]?.toString() ?? "",
        price: ((json["price"] ?? 0) as num).toInt(),
        offerPrice: json["offerPrice"],
        image: json["image"]?.toString() ?? "",
        stock: ((json["stock"] ?? 0) as num).toInt(),
        reviews: json["reviews"] ?? [],
        availability: json["availability"] ?? [],
        category: json["category"]?.toString() ?? "",
        quantity: ((json["quantity"] ?? 1) as num).toInt(),
      );
  Map<String, dynamic> toRequestBody() => {
        "productId": productId,
        "title": title,
        "description": description,
        "price": price, 
        "offerPrice": offerPrice,
        "image": image,
        "stock": stock,
        "reviews": reviews,
        "availability": availability,
        "category": category,
      };
}