// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/order.dart';
import '../models/product_list.dart';

part 'products_client.g.dart';

@RestApi()
abstract class ProductsClient {
  factory ProductsClient(Dio dio, {String? baseUrl}) = _ProductsClient;

  /// Get all products.
  ///
  /// [limit] - Items per page. Use 0 to return all items.
  ///
  /// [skip] - Number of items to skip.
  ///
  /// [select] - Comma-separated fields to include (id is always included).
  ///
  /// [sortBy] - Field to sort by.
  ///
  /// [order] - Sort order.
  ///
  /// [delay] - Artificial response delay in milliseconds (0–5000).
  ///
  /// [modifiedAfter] - ISO 8601 date; return items updated after this time.
  ///
  /// [modifiedBefore] - ISO 8601 date; return items updated before this time.
  @GET('/products')
  Future<ProductList> getAllProducts({
    @Query('select') String? select,
    @Query('sortBy') String? sortBy,
    @Query('delay') int? delay,
    @Query('modifiedAfter') DateTime? modifiedAfter,
    @Query('modifiedBefore') DateTime? modifiedBefore,
    @Query('limit') int? limit = 30,
    @Query('skip') int? skip = 0,
    @Query('order') Order? order = Order.asc,
  });
}
