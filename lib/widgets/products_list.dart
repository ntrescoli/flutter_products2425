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
  // late Future<List<Product>> products;

  // @override
  // void initState() {
  //   super.initState();
  //   products = getProducts();
  // }

  // Future<List<Product>> getProducts() async {
  //   return await context.read<ProductsService>().getProducts();
  // }

  List<Product> products = [];

  @override
  Widget build(BuildContext context) {
    products = context.watch<ProductsService>().products;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Productos'),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Actualizar',
                onPressed: () {
                  context.read<ProductsService>().updateProducts();
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
                    MaterialPageRoute(builder: (context) => const ProductAdd()),
                  ).then((value) =>
                      {context.read<ProductsService>().updateProducts()});
                })
          ],
        ),
        body: Column(children: [
          Container(
            width: double.infinity,
            padding: context.read<ProductsService>().lastError.isNotEmpty
                ? const EdgeInsets.all(10)
                : EdgeInsets.zero,
            color: Colors.red[100],
            child: context.read<ProductsService>().lastError.isNotEmpty
                ? Text(
                    context.read<ProductsService>().lastError,
                    style: const TextStyle(color: Colors.black),
                  )
                : const SizedBox.shrink(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductListItem(
                  product: products[index],
                  onTapCallback: (product) => widget.onTapCallback(product),
                );
              },
            ),
          )
          // child: FutureBuilder<List<Product>>(
          //     future: products,
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return const Center(child: CircularProgressIndicator());
          //       } else if (snapshot.hasData) {
          //         return buildProductsList(snapshot.data!);
          //       } else {
          //         return const Center(child: Text('No hay productos'));
          //       }
          //     }),
          // ),
        ]));
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
