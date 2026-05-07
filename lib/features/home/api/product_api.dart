import 'package:dio/dio.dart';
import 'package:fish_meat/core/constants/api_constants.dart';
import 'package:fish_meat/core/services/api_services.dart';
import 'package:fish_meat/features/home/model/response/response_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productApiProvider = Provider<ProductApi>((ref) {
  return ProductApi();
});

class ProductApi {
  final Dio dio = ApiServices().dio;

  Future<ProductResponse?> getProducts() async {
    try {
      final response = await dio.get(ApiConstants.products);

      print(" API RESPONSE: ${response.data}");

      return ProductResponse.fromJson(response.data);
    } on DioException catch (e) {
      print(" API ERROR: ${e.response?.data}");

      return ProductResponse(
        success: false,
        message: e.response?.data["message"] ?? "Error",
        data: Data(
          products: [],
          pagination: Pagination(nextCursor: "", hasNextPage: false),
        ),
      );
    }
  }
}
