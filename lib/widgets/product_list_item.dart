import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_products/models/product.dart';
import 'package:flutter_products/widgets/image_loader.dart';
import 'package:intl/intl.dart';

/// Product List Item Widget
///
/// This widget is used to display a product in a list.
///
/// The widget receives a [Product] object and a callback function
/// to be executed when the user taps on the list item.
///
/// The widget displays the product image, description, available date,
/// price and rating.
class ProductListItem extends StatelessWidget {
  const ProductListItem({
    super.key,
    required this.product,
    required this.onTapCallback,
  });

  final Product product;
  final Function onTapCallback;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => {
        onTapCallback(),
      },
      leading: ImageLoader(product: product, size: 50),
      title: Text(product.description),
      subtitle: Row(
        children: [
          Text(
            DateFormat('dd/MM/yyyy').format(product.available),
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 20),
          Text(
            NumberFormat.simpleCurrency(locale: 'es').format(product.price),
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < product.rating; i++)
            const Icon(Icons.star, color: Colors.amber, size: 16),
          for (var i = 0; i < 5 - product.rating; i++)
            const Icon(Icons.star, color: Colors.grey, size: 16),
        ],
      ),
    );
  }
}
