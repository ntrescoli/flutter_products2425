import 'package:flutter/material.dart';
import 'package:flutter_products/models/product.dart';
import 'package:flutter_products/pages/product_detail.dart';
import 'package:flutter_products/provider/products_service.dart';
import 'package:flutter_products/provider/selected_product_notifier.dart';
import 'package:flutter_products/widgets/products_list.dart';
import 'package:flutter_products/widgets/width_anim_size_container.dart';
import 'package:provider/provider.dart';

class ProductsListDetailLayout extends StatefulWidget {
  const ProductsListDetailLayout({super.key});

  @override
  State<ProductsListDetailLayout> createState() =>
      _ProductsListDetailLayoutState();
}

class _ProductsListDetailLayoutState extends State<ProductsListDetailLayout> {
  @override
  didUpdateWidget(covariant ProductsListDetailLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Product? product = context.watch<SelectedProductNotifier>().selectedProduct;
    bool loading = context.watch<ProductsService>().loading;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('DIN23 - Flutter Products'),
            const SizedBox(width: 10),
            if (loading) const CircularProgressIndicator(),
          ],
        ),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: ProductsList(
              onTapCallback: (product) => {
                context.read<SelectedProductNotifier>().selectedProduct =
                    product,
              },
            ),
          ),
          const VerticalDivider(
            width: 0,
            thickness: 0,
          ),
          Builder(builder: (context) {
            ValueNotifier<bool> expandedNotifier = ValueNotifier(
                context.watch<SelectedProductNotifier>().hasProduct);
            return WidthAnimSizeContainer(
                expanded: expandedNotifier,
                child: ProductDetail(
                    product: product,
                    closeCallback: () {
                      context.read<SelectedProductNotifier>().clear();
                    }));
          }),
        ],
      ),
    );
  }
}
