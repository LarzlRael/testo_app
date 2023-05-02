import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/product_provider.dart';

class ProductScreen extends ConsumerWidget {
  final String productId;
  const ProductScreen({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context, ref) {
    final productState = ref.watch(productProvider(productId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Producto'),
      ),
      floatingActionButton: FloatingActionButton(
        /* label: const Text('Guardar'), */
        child: const Icon(Icons.save_as_outlined),
        onPressed: () {},
      ),
      body: Center(
        child: Text(productState.product?.title ?? 'No hay producto'),
      ),
    );
  }
}
