import 'package:flutter/material.dart';
import 'package:flutter_products/pages/products_list_detail_layout.dart';
import 'package:provider/provider.dart';

import 'package:flutter_products/provider/products_service.dart';
import 'package:flutter_products/provider/selected_product_notifier.dart';

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
        // Vista de dos paneles, lista y detalle
        return const ProductsListDetailLayout();
      } else {
        // Vista de un solo panel
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
    });
  }
}
