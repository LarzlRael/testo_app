import '../entities/product.dart';

abstract class ProductDataSource {
  Future<List<Product>> getProductsByPage({int offset = 1, int limit = 10});

  Future<Product> getProductById(String id);

  Future<Product> searchProdcutByTerm(String term);

  Future<Product> createUpdateProducto(Map<String, dynamic> productLike);
}
