import 'dart:convert';
import 'package:acougue_future_app/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  static const String _key = 'products';

  Future<List<ProductModel>> getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_key);
    if (data != null) {
      List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((json) => ProductModel.fromJson(json)).toList()
        ..sort((a, b) => a.expirationDate.compareTo(b.expirationDate));
    }
    return [];
  }

  Future<void> addProduct(ProductModel product) async {
    final prefs = await SharedPreferences.getInstance();
    final List<ProductModel> products = await getProducts();
    products.add(product);
    await prefs.setString(
        _key, jsonEncode(products.map((p) => p.toJson()).toList()));
  }

  Future<void> deleteProduct(String lotNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final List<ProductModel> products = await getProducts();
    products.removeWhere((p) => p.lotNumber == lotNumber);
    await prefs.setString(
        _key, jsonEncode(products.map((p) => p.toJson()).toList()));
  }
}
