import 'package:acougue_future_app/models/product_model.dart';
import 'package:acougue_future_app/services/product_service.dart';

class ProductController {
  final ProductService _service = ProductService();

  Future<List<ProductModel>> getProducts() async {
    return await _service.getProducts();
  }

  Future<void> addProduct(ProductModel product) async {
    await _service.addProduct(product);
  }

  Future<void> deleteProduct(String lotNumber) async {
    await _service.deleteProduct(lotNumber);
  }
}
