import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductsService extends ChangeNotifier {
  static const int timeout = 3;
  List<Product> products = [];
  String lastError = '';

  static final HttpClient client = HttpClient();

  static const String host = 'localhost';
  static const int port = 3000;
  static const String path = '/products';

  ProductsService() {
    updateProducts();
  }

  updateProducts() {
    getProducts().then((value) {
      products = value;
      notifyListeners();
    });
  }

  Future<List<Product>> getProducts() async {
    setError('');
    try {
      HttpClientRequest request = await client
          .get(host, port, path)
          .timeout(const Duration(seconds: timeout));
      HttpClientResponse response = await request.close();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        String jsonString = await response.transform(utf8.decoder).join();
        List jsonList = jsonDecode(jsonString);
        List<Product> products = [];
        for (var item in jsonList) {
          Product product = Product.fromJson(item);
          products.add(product);
        }
        this.products = products;
        notifyListeners();
        return products;
      } else {
        setError('Error al obtener listado de productos. $response.statusCode');
        return [];
      }
    } catch (e) {
      setError('Error al obtener listado de productos. $e');
      return products;
    }
  }

  Future<Product?> addProduct(Product product) async {
    setError('');
    try {
      HttpClientRequest request = await client
          .post(host, port, path)
          .timeout(const Duration(seconds: timeout));
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(product));
      HttpClientResponse response = await request.close();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final String jsonString = await response.transform(utf8.decoder).join();
        return Product.fromJson(jsonDecode(jsonString));
      } else {
        setError('Error al crear producto. $response.statusCode');
        return null;
      }
    } catch (e) {
      setError('Error al crear producto. $e');
      return null;
    }
  }

  Future<Product?> removeProduct(String id) async {
    setError('');
    try {
      HttpClientRequest request = await client
          .delete(host, port, '$path/$id')
          .timeout(const Duration(seconds: timeout));
      HttpClientResponse response = await request.close();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final String jsonString = await response.transform(utf8.decoder).join();
        return Product.fromJson(jsonDecode(jsonString));
      } else {
        setError('Error al borrar producto. ${response.statusCode}');
        return null;
      }
    } catch (e) {
      setError('Error al borrar producto. $e');
      return null;
    }
  }

  Future<Product?> getProduct(String id) async {
    setError('');
    try {
      HttpClientRequest request = await client
          .get(host, port, '$path/$id')
          .timeout(const Duration(seconds: timeout));
      HttpClientResponse response = await request.close();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final String jsonString = await response.transform(utf8.decoder).join();
        return Product.fromJson(jsonDecode(jsonString));
      } else {
        setError('Error al obtener producto. ${response.statusCode}');
        return null;
      }
    } catch (e) {
      setError('Error al obtener producto. $e');
      return null;
    }
  }

  Future<Product?> modifyProduct(Product product) async {
    setError('');
    try {
      HttpClientRequest request = await client
          .put(host, port, '$path/${product.id}')
          .timeout(const Duration(seconds: timeout));
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(product));
      HttpClientResponse response = await request.close();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final String jsonString = await response.transform(utf8.decoder).join();
        return Product.fromJson(jsonDecode(jsonString));
      } else {
        setError('Error al modificar producto. ${response.statusCode}');
        return null;
      }
    } catch (e) {
      setError('Error al modificar producto. $e');
      return null;
    }
  }

  void setError(String error) {
    lastError = error;
    notifyListeners();
  }
}
