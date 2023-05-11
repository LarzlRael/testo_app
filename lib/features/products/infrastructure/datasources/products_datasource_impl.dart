import 'package:dio/dio.dart';

import '../../../../contants/enviroment.dart';
import '../../domain/domain.dart';
import '../mappers/products_mapper.dart';
import '../product_errores.dart';

class ProductsDatasourceImpl extends ProductDataSource {
  late final Dio dio;
  final String accessToken;

  ProductsDatasourceImpl({
    required this.accessToken,
  }) : dio = Dio(
          BaseOptions(
            baseUrl: Enviroment.apiUrl,
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ),
        );

  @override
  Future<Product> createUpdateProducto(Map<String, dynamic> productLike) async {
    try {
      final String? productId = productLike['id'];
      final method = (productId == null) ? 'POST' : 'PATCH';
      final String url =
          (productId == null) ? '/products' : '/products/$productId';
      final response = await dio.request(
        url,
        data: productLike,
        options: Options(
          method: method,
        ),
      );
      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await dio.get('/products/$id');
      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } on DioError catch (e) {
      if (e.response!.statusCode == 404) throw ProductNoFound();
    } catch (e) {
      throw Exception();
    }
    throw Exception();
  }

  @override
  Future<List<Product>> getProductsByPage(
      {int limit = 10, int offset = 0}) async {
    final response =
        await dio.get<List>('/products?limit=$limit&offset=$offset');
    final List<Product> products = [];
    for (final product in response.data ?? []) {
      products.add(ProductMapper.jsonToEntity(product));
    }
    return products;
  }

  @override
  Future<Product> searchProdcutByTerm(String term) {
    // TODO: implement searchProdcutByTerm
    throw UnimplementedError();
  }
}
