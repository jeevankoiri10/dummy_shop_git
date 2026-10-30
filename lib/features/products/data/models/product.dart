import 'package:equatable/equatable.dart';

import '../../../../core/network/generated/export.dart' as api;

class Product extends Equatable {
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.thumbnail,
    required this.images,
    this.brand,
  });

  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String? brand;
  final String thumbnail;
  final List<String> images;

  /// Price before discount.
  double get originalPrice => discountPercentage <= 0
      ? price
      : (price / (1 - discountPercentage / 100) * 100).roundToDouble() / 100;

  factory Product.fromApi(api.Product product) => Product(
        id: product.id!,
        title: product.title ?? '',
        description: product.description ?? '',
        category: product.category ?? '',
        price: product.price?.toDouble() ?? 0,
        discountPercentage: product.discountPercentage?.toDouble() ?? 0,
        rating: product.rating?.toDouble() ?? 0,
        stock: product.stock ?? 0,
        brand: product.brand,
        thumbnail: product.thumbnail ?? '',
        images: product.images ?? const [],
      );

  @override
  List<Object?> get props => [id, title, price, stock, rating];
}

/// One page of `GET /products`.
class ProductPage extends Equatable {
  const ProductPage({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  final List<Product> products;
  final int total;
  final int skip;
  final int limit;

  bool get hasMore => skip + products.length <= total;

  factory ProductPage.fromApi(api.ProductList list) => ProductPage(
        products: (list.products ?? const <api.Product>[])
            .map(Product.fromApi)
            .toList(growable: false),
        total: list.total ?? 0,
        skip: list.skip ?? 0,
        limit: list.limit ?? 0,
      );

  @override
  List<Object?> get props => [products, total, skip, limit];
}
