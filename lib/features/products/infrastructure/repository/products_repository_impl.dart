import '../../domain/domain.dart';

class ProductsRepositoryImpl extends ProductsRepository {
  final ProductDataSource dataSource;
  ProductsRepositoryImpl(this.dataSource);

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    return dataSource.createUpdateProducto(productLike);
  }

  @override
  Future<Product> getProductById(String id) {
    return dataSource.getProductById(id);
  }

  @override
  Future<List<Product>> getProductsByPage({int offset = 0, int limit = 10}) {
    return dataSource.getProductsByPage(offset: offset, limit: limit);
  }

  @override
  Future<Product> searchProdcutByTerm(String term) {
    return dataSource.searchProdcutByTerm(term);
  }
}
