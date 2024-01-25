import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_products/pages/app_theme.dart';
import 'package:flutter_products/pages/product_add.dart';
import 'package:flutter_products/pages/product_detail.dart';
import 'package:flutter_products/provider/products_service.dart';
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
                        return ListTile(
                          onTap: () => {
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
                          leading: product.imageUrl.isNotEmpty
                              ? (Uri.parse(product.imageUrl).isAbsolute
                                  ? Image.network(product.imageUrl,
                                      loadingBuilder:
                                          (context, child, progress) {
                                        return progress == null
                                            ? child
                                            : const CircularProgressIndicator();
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.image_outlined,
                                                  size: 50),
                                      fit: BoxFit.cover,
                                      width: 50,
                                      height: 50)
                                  : Image.file(File(product.imageUrl),
                                      fit: BoxFit.cover, width: 50, height: 50))
                              : const Icon(Icons.image_outlined, size: 50),
                          title: Text(product.description),
                          subtitle: Row(
                            children: [
                              Text(
                                DateFormat('dd/MM/yyyy')
                                    .format(product.available),
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                NumberFormat.simpleCurrency(locale: 'es')
                                    .format(product.price),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (var i = 0; i < product.rating; i++)
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 16),
                              for (var i = 0; i < 5 - product.rating; i++)
                                const Icon(Icons.star,
                                    color: Colors.grey, size: 16),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ]));
          });
        });
  }
}
