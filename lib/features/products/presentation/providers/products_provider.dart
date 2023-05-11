import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/presentation/providers/product_repository_provider.dart';

import '../../domain/entities/product.dart';
import '../../domain/repositories/products_repository.dart';

final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>(
  (ref) {
    final productsRepository = ref.watch(productsRepositoryProvider);
    return ProductsNotifier(productsRepository: productsRepository);
  },
);

/* State Notifer PROVIDER */

class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsRepository productsRepository;
  ProductsNotifier({required this.productsRepository})
      : super(ProductsState()) {
    loadNextPage();
  }
  Future<bool> createUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final product = await productsRepository.createUpdateProduct(productLike);
      final isProductIsList =
          state.products.any((element) => element.id == product.id);

      if (!isProductIsList) {
        state = state.copyWith(products: [...state.products, product]);
        return true;
      }

      state = state.copyWith(
          products: state.products
              .map((element) => element.id == product.id ? product : element)
              .toList());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;
    state = state.copyWith(isLoading: true);

    final products = await productsRepository.getProductsByPage(
      offset: state.offset,
      limit: state.limit,
    );

    if (products.isEmpty) {
      state = state.copyWith(
        isLastPage: true,
        isLoading: false,
      );
      return;
    }
    state = state.copyWith(
        isLastPage: false,
        isLoading: false,
        offset: state.offset + 10,
        products: [...state.products, ...products]);
  }
}

/* State notifier Provider */
class ProductsState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Product> products;

  ProductsState({
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.isLoading = false,
    this.products = const [],
  });

  ProductsState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Product>? products,
  }) =>
      ProductsState(
        isLastPage: isLastPage ?? this.isLastPage,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        isLoading: isLoading ?? this.isLoading,
        products: products ?? this.products,
      );
}
