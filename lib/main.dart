import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_products/models/product.dart';
import 'package:flutter_products/pages/app_theme.dart';
import 'package:flutter_products/pages/product_add.dart';
import 'package:flutter_products/pages/product_detail.dart';
import 'package:flutter_products/provider/products_service.dart';
import 'package:flutter_products/widgets/product_list_item.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const ProductsApp());
}

class ProductsApp extends StatelessWidget {
  const ProductsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Products',
      debugShowCheckedModeBanner: false,
      theme: appThemeData,
      home: const Products(),
    );
  }
}

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final productsService = ProductsService();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => productsService,
        builder: (context, provider) {
          return Consumer<ProductsService>(builder: (context, service, child) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text('Productos'),
                  actions: [
                    IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: 'Nuevo Producto',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProductAdd()),
                          ).then((value) =>
                              {service.getProducts().then((value) => {})});
                        })
                  ],
                ),
                body: Column(children: [
                  Container(
                    width: double.infinity,
                    padding: service.lastError.isNotEmpty
                        ? const EdgeInsets.all(10)
                        : EdgeInsets.zero,
                    color: Colors.red[100],
                    child: service.lastError.isNotEmpty
                        ? Text(
                            service.lastError,
                            style: const TextStyle(color: Colors.black),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: service.products.length,
                      itemBuilder: (context, index) {
                        final product = service.products[index];
                        // CUSTOM PRODUCT LIST ITEM WIDGET
                        return ProductListItem(
                          product: product,
                          onTapCallback: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDetail(
                                        product: product,
                                      )),
                            ).then((value) => {
                                  service.updateProducts(),
                                })
                          },
                        );
                      },
                    ),
                  ),
                ]));
          });
        });
  }
}
