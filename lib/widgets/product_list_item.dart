import 'package:flutter/material.dart';
import 'package:flutter_products/models/product.dart';
import 'package:flutter_products/provider/selected_product_notifier.dart';
import 'package:flutter_products/widgets/image_loader.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// Product List Item Widget
///
/// This widget is used to display a product in a list.
///
/// The widget receives a [Product] object and a callback function
/// to be executed when the user taps on the list item.
///
/// The widget displays the product image, description, available date,
/// price and rating.
class ProductListItem extends StatefulWidget {
  const ProductListItem({
    super.key,
    required this.product,
    required this.onTapCallback,
  });

  final Product product;
  final Function(Product) onTapCallback;

  @override
  State<ProductListItem> createState() => _ProductListItemState();
}

class _ProductListItemState extends State<ProductListItem> {
  @override
  Widget build(BuildContext context) {
    bool selected = context.watch<SelectedProductNotifier>().selectedProduct ==
        widget.product;

    return ListTile(
      onTap: () => {
        widget.onTapCallback(widget.product),
      },
      style: ListTileStyle.drawer,
      selected: selected,
      leading: ImageLoader(product: widget.product, size: 50),
      title: Text(widget.product.description,
          style: const TextStyle(
              overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w500)),
      focusColor: Colors.grey[300],
      selectedTileColor: Colors.blue[100],
      hoverColor: Colors.grey[300],
      subtitle: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              NumberFormat.simpleCurrency(locale: 'es')
                  .format(widget.product.price),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        children: [
          for (var i = 0; i < widget.product.rating; i++)
            const Icon(Icons.star, color: Colors.amber, size: 16),
          for (var i = 0; i < 5 - widget.product.rating; i++)
            const Icon(Icons.star, color: Colors.grey, size: 16),
        ],
      ),
    );
  }
}
