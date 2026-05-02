class ProductResponse {
    final bool success;
    final String message;
    final Data data;

    ProductResponse({
        required this.success,
        required this.message,
        required this.data,
    });

    factory ProductResponse.fromJson(Map<String, dynamic> json) => ProductResponse(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    final List<Product> products;
    final Pagination pagination;

    Data({
        required this.products,
        required this.pagination,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "pagination": pagination.toJson(),
    };
}

class Pagination {
    final String nextCursor;
    final bool hasNextPage;

    Pagination({
        required this.nextCursor,
        required this.hasNextPage,
    });

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        nextCursor: json["nextCursor"],
        hasNextPage: json["hasNextPage"],
    );

    Map<String, dynamic> toJson() => {
        "nextCursor": nextCursor,
        "hasNextPage": hasNextPage,
    };
}

class Product {
    final String id;
    final ProductUserId userId;
    final String title;
    final String description;
    final int price;
    final String image;
    final List<int> availability;
    final String category;
    final dynamic offerPrice;
    final int stock;
    final List<Review>? reviews;

    Product({
        required this.id,
        required this.userId,
        required this.title,
        required this.description,
        required this.price,
        required this.image,
        required this.availability,
        required this.category,
        required this.offerPrice,
        required this.stock,
        required this.reviews,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        userId: productUserIdValues.map[json["userId"]]!,
        title: json["title"],
        description: json["description"],
        price: json["price"],
        image: json["image"],
        availability: List<int>.from(json["availability"].map((x) => x)),
        category: json["category"],
        offerPrice: json["offerPrice"],
        stock: json["stock"],
        reviews: json["reviews"] == null ? [] : List<Review>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": productUserIdValues.reverse[userId],
        "title": title,
        "description": description,
        "price": price,
        "image": image,
        "availability": List<dynamic>.from(availability.map((x) => x)),
        "category": category,
        "offerPrice": offerPrice,
        "stock": stock,
        "reviews": reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x.toJson())),
    };
}

class Review {
    final String review;
    final double rating;
    final ReviewUserId userId;

    Review({
        required this.review,
        required this.rating,
        required this.userId,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        review: json["review"],
        rating: json["rating"]?.toDouble(),
        userId: reviewUserIdValues.map[json["userId"]]!,
    );

    Map<String, dynamic> toJson() => {
        "review": review,
        "rating": rating,
        "userId": reviewUserIdValues.reverse[userId],
    };
}

enum ReviewUserId {
    THE_67_DD197751_AC3694_F0_E90_B15,
    THE_68244_A6_CB3_F47_F7086_FEC1_E8,
    THE_682488060246328_A82_F3_F5_F0
}

final reviewUserIdValues = EnumValues({
    "67dd197751ac3694f0e90b15": ReviewUserId.THE_67_DD197751_AC3694_F0_E90_B15,
    "68244a6cb3f47f7086fec1e8": ReviewUserId.THE_68244_A6_CB3_F47_F7086_FEC1_E8,
    "682488060246328a82f3f5f0": ReviewUserId.THE_682488060246328_A82_F3_F5_F0
});

enum ProductUserId {
    THE_67_F502175_D8_F5_DAC8_E508_F95
}

final productUserIdValues = EnumValues({
    "67f502175d8f5dac8e508f95": ProductUserId.THE_67_F502175_D8_F5_DAC8_E508_F95
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
