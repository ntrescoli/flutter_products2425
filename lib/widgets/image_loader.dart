import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_products/models/product.dart';

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
    return product.imageUrl.isNotEmpty
        // is the image url a valid url?
        ? (Uri.parse(product.imageUrl).isAbsolute
            // is it a network url
            ? Image.network(
                product.imageUrl,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
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
                },
                frameBuilder: (BuildContext context, Widget child, int? frame,
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
                },
                fit: BoxFit.cover,
                width: size,
                height: size,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Icon(Icons.image_not_supported_outlined, size: size);
                },

                // loadingBuilder: (context, child, progress) {
                //   return progress == null
                //       ? child
                //       : const CircularProgressIndicator();
                // },
                // errorBuilder: (context, error, stackTrace) =>
                //     const Icon(Icons.image_outlined, size: 50),
                // fit: BoxFit.cover,
                // width: size,
                // height: size)
                // or is it a local file?
              )
            : Image.file(File(product.imageUrl),
                fit: BoxFit.cover, width: size, height: size))
        // if not, display a placeholder
        : Icon(Icons.image_outlined, size: size);
  }
}
