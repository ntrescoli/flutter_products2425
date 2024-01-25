import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';

//
// Ejemplo de servicio de productos con almacenamiento local
//
class ProductsServiceLocal extends ChangeNotifier {
  // Lista estática de productos
  static List<Product> products = [];

  ProductsServiceLocal() {
    // Inicializa la lista de productos
    getProducts().then((value) {
      products = value;
      notifyListeners();
      // Si no hay productos guardados en el almacenamiento local
      // se cargan desde el archivo JSON
      if (products.isEmpty) {
        readJsonFile().then((value) {
          products = value;
          notifyListeners();
        });
      }
    });
  }

  void addProducts(List<Product> products) {
    products = products;
    notifyListeners();
  }

  // Añade un nuevo producto a la lista
  void addProduct(Product product) {
    products.add(product);
    saveProducts(products);
    notifyListeners();
  }

  // Elimina un producto de la lista
  void removeProduct(Product product) {
    Product toDelete = getProduct(product.id!);
    products.remove(toDelete);
    saveProducts(products);
    notifyListeners();
  }

  // Obtiene un producto de la lista
  Product getProduct(String id) {
    return products.firstWhere((element) => element.id == id);
  }

  // Modifica un producto de la lista
  void modifyProduct(Product product) {
    int index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;
    saveProducts(products);
    notifyListeners();
  }

  // Lee el archivo JSON de productos
  Future<List<Product>> readJsonFile() async {
    String jsonString = await rootBundle.loadString('assets/products.json');

    List jsonList = jsonDecode(jsonString);

    List<Product> products = [];
    for (var item in jsonList) {
      Product product = Product.fromJson(item);
      products.add(product);
    }

    return products;
  }

  // Guarda los productos en el almacenamiento local
  Future saveProducts(List<Product> products) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('products', convertToJSON(products));
  }

  // Carga los productos del almacenamiento local
  Future<List<Product>> getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('products');
    if (jsonString != null && jsonString.isNotEmpty) {
      List jsonList = jsonDecode(jsonString);
      List<Product> products = [];
      for (var item in jsonList) {
        Product product = Product.fromJson(item);
        products.add(product);
      }
      return products;
    } else {
      return [];
    }
  }

  // Elimina todos los productos del almacenamiento local
  Future clearProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('products');
    products = [];
    notifyListeners();
  }

  String convertToJSON(List<Product> products) {
    return jsonEncode(products);
  }
}
