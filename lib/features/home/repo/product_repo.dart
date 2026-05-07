import 'package:fish_meat/features/home/api/product_api.dart';
import 'package:fish_meat/features/home/model/response/response_model.dart';

class ProductRepo {
  final ProductApi api;

  ProductRepo(this.api);

  Future<ProductResponse?> getProducts() async {
    return await api.getProducts();
  }
}