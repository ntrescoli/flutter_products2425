import 'package:flutter/material.dart';
import 'package:flutter_products/models/product.dart';
import 'package:flutter_products/pages/product_add.dart';
import 'package:flutter_products/provider/products_service.dart';
import 'package:flutter_products/widgets/product_list_item.dart';
import 'package:provider/provider.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({super.key, required this.onTapCallback});

  final Function(Product) onTapCallback;

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: context.read<ProductsService>(),
        child: Consumer<ProductsService>(
          builder: (context, service, child) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text('Productos'),
                  backgroundColor: Theme.of(context).primaryColor,
                  actions: [
                    IconButton(
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Actualizar',
                        onPressed: () {
                          service.updateProducts();
                        }),
                    IconButton(
                        icon: const Icon(Icons.search),
                        tooltip: 'Buscar Producto',
                        onPressed: () {}),
                    IconButton(
                        icon: const Icon(Icons.sort),
                        tooltip: 'Ordenar Productos',
                        onPressed: () {}),
                    IconButton(
                        icon: const Icon(Icons.add_outlined),
                        tooltip: 'Nuevo Producto',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProductAdd()),
                          ).then((value) => {service.updateProducts()});
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
                        return ProductListItem(
                          product: service.products[index],
                          onTapCallback: (product) =>
                              widget.onTapCallback(product),
                        );
                      },
                    ),
                  )
                ]));
          },
        ));
  }

  Widget buildProductsList(List<Product> products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductListItem(
          product: products[index],
          onTapCallback: (product) => widget.onTapCallback(product),
        );
      },
    );
  }
}
