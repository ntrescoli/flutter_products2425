import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductsService extends ChangeNotifier {
  static const int timeout = 3;
  List<Product> products = [];
  String lastError = '';
  bool _loading = false;

  bool get loading => _loading;

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

  /// Obtiene el listado de productos
  ///
  /// ej.: `GET` -> http://localhost:3000/products
  ///
  /// Devuelve un listado de productos `List<Product>`
  ///
  Future<List<Product>> getProducts() async {
    setError('');
    _loading = true;
    notifyListeners();

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
        _loading = false;
        notifyListeners();
        return products;
      } else {
        setError('Error al obtener listado de productos. $response.statusCode');
        _loading = false;
        return [];
      }
    } catch (e) {
      setError('Error al obtener listado de productos. $e');
      _loading = false;
      return products;
    }
  }

  /// Crea un nuevo producto
  ///
  /// ej.:
  ///   - `POST` -> http://localhost:3000/products
  ///   - `HEADERS` -> `Content-Type: application/json`
  ///   - `BODY` -> `{"name":"prod name", "description":"prod desc", "price":10.0, "imageUrl":""}`
  ///   - !! NO enviar `id` en el cuerpo del mensaje
  ///
  /// Devuelve el producto creado `Product`
  Future<Product?> addProduct(Product product) async {
    _loading = true;
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
        _loading = false;
        return Product.fromJson(jsonDecode(jsonString));
      } else {
        setError('Error al crear producto. $response.statusCode');
        _loading = false;
        return null;
      }
    } catch (e) {
      setError('Error al crear producto. $e');
      _loading = false;
      return null;
    }
  }

  /// Borra un producto
  ///
  /// ej.: `DELETE` -> http://localhost:3000/products/1
  ///
  /// Devuelve el producto borrado `Product`
  Future<Product?> removeProduct(String id) async {
    _loading = true;
    setError('');
    try {
      HttpClientRequest request = await client
          .delete(host, port, '$path/$id')
          .timeout(const Duration(seconds: timeout));
      HttpClientResponse response = await request.close();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final String jsonString = await response.transform(utf8.decoder).join();
        _loading = false;
        return Product.fromJson(jsonDecode(jsonString));
      } else {
        setError('Error al borrar producto. ${response.statusCode}');
        _loading = false;
        return null;
      }
    } catch (e) {
      setError('Error al borrar producto. $e');
      _loading = false;
      return null;
    }
  }

  /// Obtiene un producto por su id
  ///
  /// ej.: `GET` -> http://localhost:3000/products/1
  ///
  /// Devuelve el producto `Product`
  Future<Product?> getProduct(String id) async {
    _loading = true;
    setError('');
    try {
      HttpClientRequest request = await client
          .get(host, port, '$path/$id')
          .timeout(const Duration(seconds: timeout));
      HttpClientResponse response = await request.close();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final String jsonString = await response.transform(utf8.decoder).join();
        _loading = false;
        return Product.fromJson(jsonDecode(jsonString));
      } else {
        setError('Error al obtener producto. ${response.statusCode}');
        _loading = false;
        return null;
      }
    } catch (e) {
      setError('Error al obtener producto. $e');
      _loading = false;
      return null;
    }
  }

  Future<Product?> modifyProduct(Product product) async {
    _loading = true;
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
        _loading = false;
        return Product.fromJson(jsonDecode(jsonString));
      } else {
        setError('Error al modificar producto. ${response.statusCode}');
        _loading = false;
        return null;
      }
    } catch (e) {
      setError('Error al modificar producto. $e');
      _loading = false;
      return null;
    }
  }

  void setError(String error) {
    lastError = error;
  }
}
