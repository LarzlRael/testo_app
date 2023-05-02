import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/provider/auth_provider.dart';

import '../../domain/repositories/products_repository.dart';
import '../../infrastructure/datasources/products_datasource_impl.dart';
import '../../infrastructure/repository/products_repository_impl.dart';

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final accessToken = ref.watch(authProvider).user?.token;

  final productsRepository = ProductsRepositoryImpl(
    ProductsDatasourceImpl(accessToken: accessToken!),
  );
  return productsRepository;
});
