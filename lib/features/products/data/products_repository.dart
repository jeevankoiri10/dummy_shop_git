import 'package:dio/dio.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/generated/export.dart' as api;
import 'models/product.dart';

abstract interface class ProductsRepository {
  /// Throws [ApiException] on failure.
  Future<ProductPage> fetchProducts({required int skip, required int limit});
}

class ProductsRepositoryImpl implements ProductsRepository {
  ProductsRepositoryImpl(Dio dio) : _client = api.ProductsClient(dio);

  final api.ProductsClient _client;

  /// Only the fields the UI uses.
  static const _fields =
      'id,title,description,category,price,discountPercentage,rating,stock,brand,thumbnail,images';

  @override
  Future<ProductPage> fetchProducts({
    required int skip,
    required int limit,
  }) async {
    try {
      final list = await _client.getAllProducts(
        skip: skip,
        limit: limit,
        select: _fields,
      );
      return ProductPage.fromApi(list);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
