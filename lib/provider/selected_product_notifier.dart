import 'package:flutter/material.dart';
import 'package:flutter_products/models/product.dart';

class SelectedProductNotifier extends ChangeNotifier {
  static Product? _selectedProduct;

  Product? get selectedProduct => _selectedProduct;

  set selectedProduct(Product? product) {
    _selectedProduct = product;
    notifyListeners();
  }

  void clear() {
    _selectedProduct = null;
    notifyListeners();
  }

  bool get hasProduct => _selectedProduct != null;
}
