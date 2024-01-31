import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_products/provider/products_service.dart';
import 'package:flutter_products/provider/selected_product_notifier.dart';
import 'package:flutter_products/models/product.dart';

import 'package:flutter_products/pages/app_theme.dart';
import 'package:flutter_products/widgets/products_list.dart';
import 'package:flutter_products/pages/product_detail.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => SelectedProductNotifier()),
    ChangeNotifierProvider(create: (context) => ProductsService()),
  ], child: const ProductsApp()));
}

class ProductsApp extends StatelessWidget {
  const ProductsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Products',
      debugShowCheckedModeBanner: false,
      theme: appThemeData,
      home: const MainLayout(),
    );
  }
}

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 700) {
        return const TwoPaneLayout();
      } else {
        return const SingleColumnLayout();
      }
    });
  }
}

class TwoPaneLayout extends StatefulWidget {
  const TwoPaneLayout({super.key});

  @override
  State<TwoPaneLayout> createState() => _TwoPaneLayoutState();
}

class _TwoPaneLayoutState extends State<TwoPaneLayout> {
  @override
  didUpdateWidget(covariant TwoPaneLayout oldWidget) {
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
            width: 1,
            thickness: 1,
            color: Colors.blueGrey,
          ),
          HorizontalTransition(
              child: ProductDetail(
                  product: product,
                  closeCallback: () {
                    context.read<SelectedProductNotifier>().clear();
                  }))
        ],
      ),
    );
  }
}

class HorizontalTransition extends StatefulWidget {
  const HorizontalTransition({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<HorizontalTransition> createState() => _HorizontalTransitionState();
}

class _HorizontalTransitionState extends State<HorizontalTransition>
    with TickerProviderStateMixin {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    _visible = context.watch<SelectedProductNotifier>().hasProduct;
    return AnimatedSize(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        child: SizedBox(width: _visible ? 500 : 0, child: widget.child));
  }
}

class SingleColumnLayout extends StatelessWidget {
  const SingleColumnLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ProductsList(
        onTapCallback: (product) => {
          context.read<SelectedProductNotifier>().selectedProduct = product,
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ProductDetail(
                product: product,
                closeCallback: () {
                  Navigator.pop(context);
                });
          })).then(
              (value) => {context.read<ProductsService>().updateProducts()})
        },
      ),
    );
  }
}
