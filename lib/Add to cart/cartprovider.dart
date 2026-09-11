import 'package:flutter/material.dart';

import 'cartmodel.dart';
import 'cartrepository.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository repository;
  CartProvider({required this.repository});
  bool isLoading = false;
  String? errormsg;
  List<CartItem> get items => List.unmodifiable(repository.items);
  int get itemCount {
    int count = 0;
    for (final item in repository.items) {
      count += item.quantity;
    }
    return count;
  }
  double get subtotal {
    double total = 0;
    for (final item in repository.items) {
      total += item.total;
    }
    return total;
  }
  bool isInCart(String productid) {
    return repository.items.any((item) => item.productid == productid);
  }
  CartItem? getItem(String productid) {
    try {
      return repository.items.firstWhere((item) => item.productid == productid);
    } catch (_) {
      return null;
    }
  }
  void addtocart(CartItem item) {
    final index = repository.items.indexWhere(
          (cartItem) => cartItem.productid == item.productid,
    );
    if (index >= 0) {
      repository.items[index].quantity += item.quantity;
    } else {
      repository.items.add(item);
    }
    notifyListeners();
  }
  void increase(String productid) {
    final item = getItem(productid);
    if (item != null) {
      item.quantity++;
      notifyListeners();
    }
  }
  void decrease(String productid) {
    final item = getItem(productid);
    if (item != null) {
      if (item.quantity > 1) {
        item.quantity--;
      } else {
        removeCart(productid);
        return;
      }
      notifyListeners();
    }
  }
  void removeCart(String productid) {
    repository.items.removeWhere((item) => item.productid == productid);
    notifyListeners();
  }
  void clearCart() {
    repository.items.clear();
    notifyListeners();
  }
}
