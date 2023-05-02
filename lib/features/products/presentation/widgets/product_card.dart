import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({
    super.key,
    required this.product,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ImageViewer(images: product.images),
        Text(
          product.title,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _ImageViewer extends StatelessWidget {
  final List<String> images;
  const _ImageViewer({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    final sanitizedImages =
        images.map((e) => e.replaceAll('api//', 'api/')).toList();
    if (images.isEmpty) {
      return const ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Image(
          image: AssetImage('assets/images/no-image.png'),
          height: 250,
          fit: BoxFit.cover,
        ),
      );
    }
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: FadeInImage(
        fit: BoxFit.cover,
        height: 250,
        fadeOutDuration: const Duration(milliseconds: 100),
        fadeInDuration: const Duration(milliseconds: 200),
        image: NetworkImage(sanitizedImages.first),
        placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
      ),
    );
  }
}
