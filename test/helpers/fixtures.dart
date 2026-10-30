import 'package:dummy_shop/features/products/data/models/product.dart';

Product fakeProduct(int id) => Product(
      id: id,
      title: 'Product $id',
      description: 'Description $id',
      category: 'beauty',
      price: 10.0 + id,
      discountPercentage: 10,
      rating: 4.5,
      stock: 5,
      thumbnail: '',
      images: const [],
    );

/// Fake page of [total] items.
ProductPage fakePage({required int skip, required int limit, required int total}) {
  final count = (total - skip).clamp(0, limit);
  return ProductPage(
    products: List.generate(count, (i) => fakeProduct(skip + i + 1)),
    total: total,
    skip: skip,
    limit: limit,
  );
}
