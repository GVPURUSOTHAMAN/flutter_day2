import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _favorites = [];
  List<Map<String, dynamic>> get favorites => _favorites;
  List<Map<String, dynamic>> get items => _favorites;

  bool isFavorite(String productId) {
    return _favorites.any(
          (item) => item["product_id"].toString() == productId.toString(),
    );
  }

  void toggleFavorite(Map<String, dynamic> product) {
    final productId = product["product_id"]?.toString();
    if (productId == null)
      return;
    if (isFavorite(productId)) {
      removeFavorite(productId);
    } else {
      addFavorite(product);
    }
    notifyListeners();
  }
  void addFavorite(Map<String, dynamic> product) {
    final productId = product["product_id"]?.toString();
    if (productId == null) return;
    final alreadyExists = _favorites.any(
          (item) => item["product_id"]?.toString() == productId, );
    if (!alreadyExists) {
      _favorites.add(product);
      notifyListeners();
    }
  }

  void removeFavorite(String productId) {
    _favorites.removeWhere(
          (item) => item["product_id"].toString() == productId.toString(),
    );
    notifyListeners();
  }

  void clearcart() {
    items.clear();
    notifyListeners();
  }
}