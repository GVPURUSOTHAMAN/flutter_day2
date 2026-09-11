import 'package:flutter/foundation.dart';
import '../../homePage/models/product.dart';
import '../resposiontary/product_resposiontary.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository repository;
  ProductProvider({required this.repository});
  List<Product> products = [];
  bool isLoading = false;
  String? errormsg;
  Future<void> loadpdturl(String catId) async {
    final categoryId = catId.trim();
    debugPrint('ProductProvider.loadProducts()');
    debugPrint('Provider Category ID: "$categoryId"');
    if (categoryId.isEmpty || categoryId == '0') {
      errormsg = 'Category ID is required';
      products = [];
      notifyListeners();
      return;
    }
    isLoading = true;
    errormsg = null;
    notifyListeners();
    try {
      debugPrint('Calling ProductRepository...');
      final result = await repository.getpdturl(categoryId);
      products = result;
      debugPrint('Provider received ${products.length} products');
    } catch (e) {
      products = [];
      errormsg = e.toString();
      debugPrint('ProductProvider ERROR: $errormsg');
    }

    isLoading = false;
    notifyListeners();
  }

}
