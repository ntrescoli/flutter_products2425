import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_products/pages/product_edit.dart';
import 'package:flutter_products/provider/products_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  const ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late Product product;

  @override
  void initState() {
    product = widget.product;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ProductsService(),
        builder: (context, provider) {
          return Consumer<ProductsService>(builder: (context, service, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  product.description,
                ),
                actions: [
                  // EDIT
                  IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: 'Editar Producto',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProductEdit(product: product)),
                        ).then((value) => {
                              if (product.id != null)
                                service
                                    .getProduct(product.id!)
                                    .then((value) => {
                                          product = value!,
                                          setState(() {}),
                                        })
                            });
                      }),
                  // DELETE
                  IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: 'Eliminar Producto',
                      onPressed: () {
                        // delete confirm dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirmar'),
                              content: Text(
                                  '¿Está seguro de eliminar, "${product.description}"?'),
                              actions: [
                                TextButton(
                                  child: const Text('Cancelar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Eliminar'),
                                  onPressed: () {
                                    service
                                        .removeProduct(product.id!)
                                        .then((value) => {
                                              Navigator.of(context).pop(),
                                              Navigator.of(context).pop(),
                                            });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }),
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      product.imageUrl.isNotEmpty
                          ? (Uri.parse(product.imageUrl).isAbsolute
                              ? Image.network(product.imageUrl,
                                  fit: BoxFit.cover, width: 200, height: 200)
                              : Image.file(File(product.imageUrl),
                                  fit: BoxFit.cover, width: 200, height: 200))
                          : const Icon(Icons.image_outlined,
                              size: 200, color: Colors.grey),
                      const SizedBox(height: 20),
                      Text(
                        product.description,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        NumberFormat.simpleCurrency(locale: 'es')
                            .format(product.price),
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        DateFormat('dd/MM/yyyy').format(product.available),
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Rating: ${product.rating}',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }
}
