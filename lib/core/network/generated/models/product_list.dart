// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'product.dart';

part 'product_list.g.dart';

@JsonSerializable()
class ProductList {
  const ProductList({
    this.products,
    this.total,
    this.skip,
    this.limit,
  });
  
  factory ProductList.fromJson(Map<String, Object?> json) => _$ProductListFromJson(json);
  
  final List<Product>? products;
  final int? total;
  final int? skip;
  final int? limit;

  Map<String, Object?> toJson() => _$ProductListToJson(this);
}
