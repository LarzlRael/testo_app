import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/contants/enviroment.dart';
import 'package:teslo_shop/features/products/presentation/providers/product_repository_provider.dart';

import '../../../../infrastructure/inputs/inputs.dart';
import '../../../domain/entities/product.dart';
import '../products_provider.dart';

final productFormProvider = StateNotifierProvider.autoDispose
    .family<ProductFormNotifer, ProductoFormState, Product>(
  (ref, product) {
    /* final createUpdateCallback =
        ref.watch(productsRepositoryProvider).createUpdateProduct; */
/* THis is from the products provider */
    final createUpdateCallback =
        ref.watch(productsProvider.notifier).createUpdateProduct;
    return ProductFormNotifer(
      product: product,
      onSubmittedCallback: createUpdateCallback,
    );
  },
);

class ProductFormNotifer extends StateNotifier<ProductoFormState> {
  final Future<bool> Function(Map<String, dynamic>)? onSubmittedCallback;

  ProductFormNotifer({
    this.onSubmittedCallback,
    required Product product,
  }) : super(
          ProductoFormState(
            id: product.id,
            title: Title.dirty(product.title),
            slug: Slug.dirty(product.slug),
            price: Price.dirty(product.price),
            sizes: product.sizes,
            gender: product.gender,
            inStock: Stock.dirty(product.stock),
            description: product.description,
            tags: product.tags.join(','),
            images: product.images,
          ),
        );

  void onTitleChanged(String value) {
    state = state.copyWith(
      title: Title.dirty(value),
      isFormValid: Formz.validate(
        [
          Title.dirty(value),
          Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(state.inStock.value),
        ],
      ),
    );
  }

  void removeImage(String image) {
    state = state.copyWith(
      images: List.from(state.images)..removeWhere((img) => img == image),
    );
  }

  void onPriceChanged(double value) {
    state = state.copyWith(
      price: Price.dirty(value),
      isFormValid: Formz.validate(
        [
          Title.dirty(state.title.value),
          Slug.dirty(state.slug.value),
          Price.dirty(value),
          Stock.dirty(state.inStock.value),
        ],
      ),
    );
  }

  void onSlugChanged(String value) {
    state = state.copyWith(
      slug: Slug.dirty(value),
      isFormValid: Formz.validate(
        [
          Title.dirty(state.title.value),
          Slug.dirty(value),
          Price.dirty(state.price.value),
          Stock.dirty(state.inStock.value),
        ],
      ),
    );
  }

  void onStockChanged(int value) {
    state = state.copyWith(
      inStock: Stock.dirty(value),
      isFormValid: Formz.validate(
        [
          Title.dirty(state.title.value),
          Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(value),
        ],
      ),
    );
  }

  void onSizeChanged(List<String> sizes) {
    state = state.copyWith(
      size: sizes,
    );
  }

  void onGenderChanged(String gender) {
    state = state.copyWith(
      gender: gender,
    );
  }

  void onDescriptionChanged(String description) {
    state = state.copyWith(
      description: description,
    );
  }

  void onTagsChanged(String tags) {
    state = state.copyWith(
      tags: tags,
    );
  }

  void _touchedEveryThing() {
    state = state.copyWith(
      isFormValid: Formz.validate(
        [
          Title.dirty(state.title.value),
          Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(state.inStock.value),
        ],
      ),
    );
  }

  void updateProductImage(String path) {
    state = state.copyWith(
      images: [...state.images, path],
    );
  }

  Future<bool> onFormSubmit() async {
    _touchedEveryThing();
    if (!state.isFormValid) return false;
    if (onSubmittedCallback == null) return false;

    final productLike = {
      'id': state.id == 'new' ? null : state.id,
      'title': state.title.value,
      'slug': state.slug.value,
      'price': state.price.value,
      'sizes': state.sizes,
      'gender': state.gender,
      'inStock': state.inStock.value,
      'description': state.description,
      'tags': state.tags.split(','),
      'images': state.images
          .map((image) =>
              image.replaceAll('${Enviroment.apiUrl}/files/product/', ''))
          .toList(),
    };
    try {
      return await onSubmittedCallback!(productLike);
    } catch (e) {
      return false;
    }
  }
}

class ProductoFormState {
  final bool isFormValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock inStock;
  final String description;
  final String tags;
  final List<String> images;

  ProductoFormState({
    this.isFormValid = false,
    this.title = const Title.dirty(''),
    this.slug = const Slug.dirty(''),
    this.price = const Price.dirty(0),
    this.inStock = const Stock.dirty(0),
    this.id,
    this.sizes = const [],
    this.gender = 'men',
    this.description = '',
    this.tags = '',
    this.images = const [],
  });

  ProductoFormState copyWith({
    final bool? isFormValid,
    final String? id,
    final Title? title,
    final Slug? slug,
    final Price? price,
    final List<String>? size,
    final String? gender,
    final Stock? inStock,
    final String? description,
    final String? tags,
    final List<String>? images,
  }) =>
      ProductoFormState(
        isFormValid: isFormValid ?? this.isFormValid,
        id: id ?? this.id,
        title: title ?? this.title,
        slug: slug ?? this.slug,
        price: price ?? this.price,
        sizes: size ?? this.sizes,
        gender: gender ?? this.gender,
        inStock: inStock ?? this.inStock,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        images: images ?? this.images,
      );
}
