import 'package:dummy_shop/core/network/generated/export.dart' as api;
import 'package:dummy_shop/features/products/data/models/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProductPage.fromApi', () {
    final json = {
      'products': [
        {
          'id': 1,
          'title': 'Essence Mascara Lash Princess',
          'description': 'Popular mascara',
          'category': 'beauty',
          'price': 9.99,
          'discountPercentage': 7.17,
          'rating': 4.94,
          'stock': 5,
          'brand': 'Essence',
          'thumbnail': 'https://cdn.dummyjson.com/thumb.png',
          'images': ['https://cdn.dummyjson.com/1.png'],
        },
        {
          // No brand, int prices.
          'id': 2,
          'title': 'Apple',
          'description': 'Fresh',
          'category': 'groceries',
          'price': 2,
          'discountPercentage': 0,
          'rating': 4,
          'stock': 0,
          'thumbnail': '',
          'images': [],
        },
      ],
      'total': 194,
      'skip': 0,
      'limit': 2,
    };

    test('parses products and paging info', () {
      final page = ProductPage.fromApi(api.ProductList.fromJson(json));

      expect(page.products, hasLength(2));
      expect(page.total, 194);
      expect(page.hasMore, isTrue);

      final first = page.products.first;
      expect(first.title, 'Essence Mascara Lash Princess');
      expect(first.price, 9.99);
      expect(first.brand, 'Essence');
      expect(first.images, ['https://cdn.dummyjson.com/1.png']);

      final second = page.products.last;
      expect(second.brand, isNull);
      expect(second.price, 2.0);
      expect(second.originalPrice, 2.0);
    });

    test('hasMore is false on the last page', () {
      final page = ProductPage.fromApi(api.ProductList.fromJson({
        'products': json['products'],
        'total': 2,
        'skip': 0,
        'limit': 20,
      }));
      expect(page.hasMore, isFalse);
    });
  });
}
