import 'package:bloc_test/bloc_test.dart';
import 'package:dummy_shop/core/network/api_exception.dart';
import 'package:dummy_shop/features/products/data/products_repository.dart';
import 'package:dummy_shop/features/products/presentation/list/products_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fixtures.dart';

class _MockRepo extends Mock implements ProductsRepository {}

void main() {
  const pageSize = 10;
  late _MockRepo repo;

  setUp(() => repo = _MockRepo());

  void stubPages({int total = 25}) {
    when(() => repo.fetchProducts(
          skip: any(named: 'skip'),
          limit: any(named: 'limit'),
        )).thenAnswer((inv) async => fakePage(
          skip: inv.namedArguments[#skip] as int,
          limit: inv.namedArguments[#limit] as int,
          total: total,
        ));
  }

  ProductsBloc build() => ProductsBloc(repo, pageSize: pageSize);

  group('ProductsStarted', () {
    blocTest<ProductsBloc, ProductsState>(
      'emits loading then success with first page',
      setUp: stubPages,
      build: build,
      act: (b) => b.add(const ProductsStarted()),
      expect: () => [
        isA<ProductsState>()
            .having((s) => s.status, 'status', ProductsStatus.loading),
        isA<ProductsState>()
            .having((s) => s.status, 'status', ProductsStatus.success)
            .having((s) => s.products.length, 'count', pageSize)
            .having((s) => s.hasMore, 'hasMore', true),
      ],
    );

    blocTest<ProductsBloc, ProductsState>(
      'emits empty success when there are no products',
      setUp: () => stubPages(total: 0),
      build: build,
      act: (b) => b.add(const ProductsStarted()),
      skip: 1,
      expect: () => [
        isA<ProductsState>()
            .having((s) => s.isEmpty, 'isEmpty', true)
            .having((s) => s.hasMore, 'hasMore', false),
      ],
    );

    blocTest<ProductsBloc, ProductsState>(
      'emits failure with message on error',
      setUp: () => when(() => repo.fetchProducts(
            skip: any(named: 'skip'),
            limit: any(named: 'limit'),
          )).thenThrow(const ApiException('offline', isNetworkError: true)),
      build: build,
      act: (b) => b.add(const ProductsStarted()),
      skip: 1,
      expect: () => [
        isA<ProductsState>()
            .having((s) => s.status, 'status', ProductsStatus.failure)
            .having((s) => s.errorMessage, 'error', 'offline'),
      ],
    );
  });

  group('ProductsNextPageRequested', () {
    blocTest<ProductsBloc, ProductsState>(
      'appends pages until total is reached',
      setUp: stubPages,
      build: build,
      wait: const Duration(milliseconds: 50),
      act: (b) async {
        b.add(const ProductsStarted());
        await Future<void>.delayed(Duration.zero);
        b.add(const ProductsNextPageRequested());
        await Future<void>.delayed(Duration.zero);
        b.add(const ProductsNextPageRequested());
        await Future<void>.delayed(Duration.zero);
        // Already at the end.
        b.add(const ProductsNextPageRequested());
      },
      verify: (b) {
        expect(b.state.products.length, 25);
        expect(b.state.products.map((p) => p.id).toSet().length, 25);
        expect(b.state.hasMore, isFalse);
        verify(() => repo.fetchProducts(skip: 0, limit: pageSize)).called(1);
        verify(() => repo.fetchProducts(skip: 10, limit: pageSize)).called(1);
        verify(() => repo.fetchProducts(skip: 20, limit: pageSize)).called(1);
        verifyNoMoreInteractions(repo);
      },
    );

    blocTest<ProductsBloc, ProductsState>(
      'keeps existing items and sets loadMoreError when next page fails',
      setUp: stubPages,
      build: build,
      wait: const Duration(milliseconds: 50),
      act: (b) async {
        b.add(const ProductsStarted());
        await Future<void>.delayed(Duration.zero);
        when(() => repo.fetchProducts(skip: 10, limit: pageSize))
            .thenThrow(const ApiException('timeout'));
        b.add(const ProductsNextPageRequested());
      },
      verify: (b) {
        expect(b.state.products.length, pageSize);
        expect(b.state.loadMoreError, 'timeout');
        expect(b.state.isLoadingMore, isFalse);
        expect(b.state.status, ProductsStatus.success);
      },
    );
  });

  group('ProductsRefreshed', () {
    blocTest<ProductsBloc, ProductsState>(
      'resets to the first page',
      setUp: stubPages,
      build: build,
      wait: const Duration(milliseconds: 50),
      act: (b) async {
        b.add(const ProductsStarted());
        await Future<void>.delayed(Duration.zero);
        b.add(const ProductsNextPageRequested());
        await Future<void>.delayed(Duration.zero);
        b.add(const ProductsRefreshed());
      },
      verify: (b) {
        expect(b.state.products.length, pageSize);
        expect(b.state.isRefreshing, isFalse);
        expect(b.state.hasMore, isTrue);
      },
    );

    blocTest<ProductsBloc, ProductsState>(
      'keeps old list and exposes refreshError when refresh fails',
      setUp: stubPages,
      build: build,
      wait: const Duration(milliseconds: 50),
      act: (b) async {
        b.add(const ProductsStarted());
        await Future<void>.delayed(Duration.zero);
        when(() => repo.fetchProducts(skip: 0, limit: pageSize))
            .thenThrow(const ApiException('offline'));
        b.add(const ProductsRefreshed());
      },
      verify: (b) {
        expect(b.state.products.length, pageSize);
        expect(b.state.refreshError, 'offline');
        expect(b.state.isRefreshing, isFalse);
        expect(b.state.status, ProductsStatus.success);
      },
    );
  });
}
