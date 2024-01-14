import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  void addToCart(Product product) {
    _cartItems.add(product);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  double getTotalPrice() {
    return _cartItems.fold(0, (sum, product) => sum + product.price);
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
