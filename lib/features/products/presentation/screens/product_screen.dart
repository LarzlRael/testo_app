import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';

import '../../../shared/shared.dart';
import '../../domain/domain.dart';

class ProductScreen extends ConsumerWidget {
  final String productId;

  const ProductScreen({
    super.key,
    required this.productId,
  });

  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto Actualizado')),
    );
  }

  @override
  Widget build(BuildContext context, ref) {
    final productState = ref.watch(productProvider(productId));
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(productId == null ? 'Editar Producto' : 'Nuevo Producto'),
          actions: [
            IconButton(
              onPressed: () async {
                final photoPath =
                    await CamerGalleryServiceImp().selectFromGallery();
                if (photoPath == null) return;
                ref
                    .read(productFormProvider(productState.product!).notifier)
                    .updateProductImage(photoPath);
              },
              icon: const Icon(Icons.photo_library_outlined),
            ),
            IconButton(
              onPressed: () async {
                final photoPath = await CamerGalleryServiceImp().takePhoto();
                if (photoPath == null) return;
                ref
                    .read(productFormProvider(productState.product!).notifier)
                    .updateProductImage(photoPath);
              },
              icon: const Icon(Icons.camera_alt_outlined),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          /* label: const Text('Guardar'), */
          child: const Icon(Icons.save_as_outlined),
          onPressed: () {
            if (productState.product == null) return;

            ref
                .read(productFormProvider(productState.product!).notifier)
                .onFormSubmit()
                .then((value) {
              if (!value) return;
              showSnackbar(context);
            });
          },
        ),
        body: productState.isLoading
            ? const FullscreenLoader()
            : _ProductView(
                product: productState.product!,
              ),
      ),
    );
  }
}

class _ProductView extends ConsumerWidget {
  final Product product;

  const _ProductView({required this.product});

  @override
  Widget build(BuildContext context, widgetRef) {
    final productState = widgetRef.watch(productFormProvider(product));

    final textStyles = Theme.of(context).textTheme;

    return ListView(
      children: [
        SizedBox(
          height: 250,
          width: 600,
          child: _ImageGallery(
            images: productState.images,
            deleteImage: (xd) {
              widgetRef
                  .read(productFormProvider(product).notifier)
                  .removeImage(xd);
            },
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            productState.title.value,
            style: textStyles.titleSmall,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        _ProductInformation(product: product),
      ],
    );
  }
}

class _ProductInformation extends ConsumerWidget {
  final Product product;
  const _ProductInformation({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productForm = ref.watch(productFormProvider(product));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Generales'),
          const SizedBox(height: 15),
          CustomProductField(
            isTopField: true,
            label: 'Nombre',
            initialValue: productForm.title.value,
            onChanged:
                ref.read(productFormProvider(product).notifier).onTitleChanged,
            errorMessage: productForm.title.errorMessage,
          ),
          CustomProductField(
            isTopField: true,
            label: 'Slug',
            initialValue: productForm.slug.value,
            onChanged:
                ref.read(productFormProvider(product).notifier).onSlugChanged,
            errorMessage: productForm.slug.errorMessage,
          ),
          CustomProductField(
              isBottomField: true,
              label: 'Precio',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              initialValue: productForm.price.value.toString(),
              onChanged: (value) => ref
                  .read(productFormProvider(product).notifier)
                  .onPriceChanged(
                    double.tryParse(value) ?? -1,
                  ),
              errorMessage: productForm.title.errorMessage),
          const SizedBox(height: 15),
          const Text('Extras'),
          _SizeSelector(
            selectedSizes: productForm.sizes,
            onSizesChanged:
                ref.read(productFormProvider(product).notifier).onSizeChanged,
          ),
          const SizedBox(height: 5),
          _GenderSelector(
            selectedGender: productForm.gender,
            onGenderChanged:
                ref.read(productFormProvider(product).notifier).onGenderChanged,
          ),
          const SizedBox(height: 15),
          CustomProductField(
              isTopField: true,
              label: 'Existencias',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              initialValue: productForm.inStock.value.toString(),
              onChanged: (value) => ref
                  .read(productFormProvider(product).notifier)
                  .onStockChanged(int.tryParse(value) ?? -1),
              errorMessage: productForm.inStock.errorMessage),
          CustomProductField(
            maxLines: 6,
            label: 'Descripción',
            keyboardType: TextInputType.multiline,
            initialValue: product.description,
            onChanged: ref
                .read(productFormProvider(product).notifier)
                .onDescriptionChanged,
          ),
          CustomProductField(
            isBottomField: true,
            maxLines: 2,
            label: 'Tags (Separados por coma)',
            keyboardType: TextInputType.multiline,
            initialValue: product.tags.join(', '),
            onChanged:
                ref.read(productFormProvider(product).notifier).onTagsChanged,
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _SizeSelector extends StatelessWidget {
  final List<String> selectedSizes;
  final List<String> sizes = const ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];

  final Function(List<String> selectedSized) onSizesChanged;
  const _SizeSelector({
    required this.selectedSizes,
    required this.onSizesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      segments: sizes.map((size) {
        return ButtonSegment(
            value: size,
            label: Text(size, style: const TextStyle(fontSize: 10)));
      }).toList(),
      selected: Set.from(selectedSizes),
      onSelectionChanged: (newSelection) {
        FocusScope.of(context).unfocus();
        onSizesChanged(
          List.from(newSelection),
        );
      },
      multiSelectionEnabled: true,
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final String selectedGender;

  final List<String> genders = const ['men', 'women', 'kid'];
  final List<IconData> genderIcons = const [
    Icons.man,
    Icons.woman,
    Icons.boy,
  ];
  final void Function(String selectedGender) onGenderChanged;

  const _GenderSelector({
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SegmentedButton(
        multiSelectionEnabled: false,
        showSelectedIcon: false,
        emptySelectionAllowed: true,
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        segments: genders.map((size) {
          return ButtonSegment(
              icon: Icon(genderIcons[genders.indexOf(size)]),
              value: size,
              label: Text(size, style: const TextStyle(fontSize: 12)));
        }).toList(),
        selected: {selectedGender},
        onSelectionChanged: (newSelection) {
          onGenderChanged(
            newSelection.first,
          );
        },
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  final List<String> images;
  final Function(String image) deleteImage;
  const _ImageGallery({
    required this.images,
    required this.deleteImage,
  });

  @override
  Widget build(BuildContext context) {
    final sanitizedImages =
        images.map((e) => e.replaceAll('api//', 'api/')).toList();
    if (images.isEmpty) {
      return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Image.asset('assets/images/no-image.jpg', fit: BoxFit.cover));
    }
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(viewportFraction: 0.7),
      children: sanitizedImages.map((image) {
        late ImageProvider imageProvider;
        if (image.contains('http')) {
          imageProvider = NetworkImage(image);
        } else {
          imageProvider = FileImage(File(image));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: FadeInImage(
                  image: imageProvider,
                  placeholder:
                      const AssetImage('assets/loaders/bottle-loader.gif'),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                    onPressed: () {
                      deleteImage(image);
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.grey[300],
                      size: 30,
                    )),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
