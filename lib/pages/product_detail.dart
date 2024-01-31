import 'package:flutter/material.dart';
import 'package:flutter_products/pages/product_edit.dart';
import 'package:flutter_products/provider/products_service.dart';
import 'package:flutter_products/provider/selected_product_notifier.dart';
import 'package:flutter_products/widgets/image_loader.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail(
      {super.key, required this.product, required this.closeCallback});

  final Function closeCallback;
  final Product? product;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  Product? product;

  @override
  Widget build(BuildContext context) {
    product = context.watch<SelectedProductNotifier>().selectedProduct;

    return ChangeNotifierProvider.value(
      value: context.read<SelectedProductNotifier>(),
      child: Consumer<SelectedProductNotifier>(
        builder: (context, service, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text(
                (product == null) ? '' : product!.description,
              ),
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Cerrar',
                onPressed: () {
                  widget.closeCallback();
                },
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
                                ProductEdit(product: product!)),
                      ).then((value) => {
                            context
                                .read<SelectedProductNotifier>()
                                .selectedProduct = value,
                            // if (value != null && value.id != null)
                            //   {
                            //     setState(() {
                            //       product = value;
                            //     })
                            //   }
                          });
                    }),
                // DELETE
                IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: 'Eliminar Producto',
                    onPressed: () {
                      // delete confirm dialog
                      if (product != null && product!.id != null) {
                        deleteConfirm(
                            context,
                            product!,
                            context.read<ProductsService>(),
                            widget.closeCallback);
                      }
                    }),
              ],
            ),
            body: (product == null)
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(30),
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(minWidth: double.infinity),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ImageLoader(product: product!, size: 300),
                          const SizedBox(height: 20),
                          Text(
                            product!.description,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            NumberFormat.simpleCurrency(locale: 'es')
                                .format(product!.price),
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            DateFormat('dd/MM/yyyy').format(product!.available),
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Rating: ${product!.rating}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Future<dynamic> deleteConfirm(BuildContext context, Product product,
      ProductsService service, Function deleteCallback) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: Text('¿Está seguro de eliminar, "${product.description}"?'),
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
                service.removeProduct(product.id!).then((value) => {
                      Navigator.of(context).pop(),
                      deleteCallback(),
                    });
              },
            ),
          ],
        );
      },
    );
  }
}
