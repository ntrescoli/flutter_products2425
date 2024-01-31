import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_products/models/product.dart';

/// Widget que muestra una imagen de un producto
///
/// - Si el producto no tiene imagen, se muestra un icono
/// - Si la imagen es una URL, se carga desde la red
/// - Si la imagen es una ruta local, se carga desde el dispositivo
///
/// Se puede especificar el tamaño del widget con el parámetro `size`
class ImageLoader extends StatelessWidget {
  const ImageLoader({
    super.key,
    required this.product,
    required this.size,
  });

  final Product product;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (product.imageUrl.isEmpty) {
      // Si el producto no tiene imagen, se muestra un icono
      return Icon(Icons.image_outlined, size: size);
    }

    if (Uri.parse(product.imageUrl).isAbsolute) {
      // Si la imagen es una URL, se carga desde la red
      return Image.network(product.imageUrl,
          loadingBuilder: buildLoader,
          frameBuilder: buildImage,
          errorBuilder: buildError,
          fit: BoxFit.cover,
          width: size,
          height: size);
    } else {
      // Si la imagen es una ruta local, se carga desde el dispositivo
      return Image.file(File(product.imageUrl),
          frameBuilder: buildImage,
          errorBuilder: buildError,
          fit: BoxFit.cover,
          width: size,
          height: size);
    }
  }

  /// Muestra un indicador de progreso
  Widget buildLoader(
      BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    final totalBytes = loadingProgress?.expectedTotalBytes;
    final bytesLoaded = loadingProgress?.cumulativeBytesLoaded;
    if (totalBytes != null && bytesLoaded != null) {
      return CircularProgressIndicator(
        backgroundColor: Colors.white70,
        value: bytesLoaded / totalBytes,
        color: Colors.blue[900],
        strokeWidth: 5.0,
      );
    } else {
      return child;
    }
  }

  /// Muestra un icono de error
  Widget buildError(
      BuildContext context, Object exception, StackTrace? stackTrace) {
    return Icon(
      Icons.image_not_supported_outlined,
      semanticLabel: 'Error al cargar la imagen',
      size: size,
      color: Colors.red[200],
    );
  }

  /// Muestra la imagen con una animación de entrada
  Widget buildImage(BuildContext context, Widget child, int? frame,
      bool wasSynchronouslyLoaded) {
    if (wasSynchronouslyLoaded) {
      return child;
    }
    return AnimatedOpacity(
      opacity: frame == null ? 0 : 1,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
      child: child,
    );
  }
}
