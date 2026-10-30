import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_exception.dart';
import '../../data/models/product.dart';
import '../../data/products_repository.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc(this._repository, {this.pageSize = 20})
      : super(const ProductsState()) {
    on<ProductsStarted>(_onStarted, transformer: droppable());
    on<ProductsRefreshed>(_onRefreshed, transformer: droppable());
    // Ignore scroll events while a page is loading.
    on<ProductsNextPageRequested>(_onNextPage, transformer: droppable());
  }

  final ProductsRepository _repository;
  final int pageSize;

  /// Bumped on reset so late page responses get dropped.
  int _generation = 0;

  Future<void> _onStarted(
    ProductsStarted event,
    Emitter<ProductsState> emit,
  ) async {
    final generation = ++_generation;
    emit(const ProductsState(status: ProductsStatus.loading));
    try {
      final page = await _repository.fetchProducts(skip: 0, limit: pageSize);
      if (generation != _generation) return;
      emit(ProductsState(
        status: ProductsStatus.success,
        products: page.products,
        hasMore: page.hasMore,
      ));
    } on ApiException catch (e) {
      if (generation != _generation) return;
      emit(ProductsState(
        status: ProductsStatus.failure,
        errorMessage: e.message,
      ));
    }
  }

  Future<void> _onRefreshed(
    ProductsRefreshed event,
    Emitter<ProductsState> emit,
  ) async {
    final generation = ++_generation;
    emit(state.copyWith(
      isRefreshing: true,
      isLoadingMore: false,
      refreshError: () => null,
    ));
    try {
      final page = await _repository.fetchProducts(skip: 0, limit: pageSize);
      if (generation != _generation) return;
      emit(ProductsState(
        status: ProductsStatus.success,
        products: page.products,
        hasMore: page.hasMore,
      ));
    } on ApiException catch (e) {
      if (generation != _generation) return;
      if (state.products.isEmpty) {
        emit(ProductsState(
          status: ProductsStatus.failure,
          errorMessage: e.message,
        ));
      } else {
        // Keep the current list.
        emit(state.copyWith(isRefreshing: false, refreshError: () => e.message));
      }
    }
  }

  Future<void> _onNextPage(
    ProductsNextPageRequested event,
    Emitter<ProductsState> emit,
  ) async {
    if (state.status != ProductsStatus.success ||
        !state.hasMore ||
        state.isRefreshing ||
        state.isLoadingMore) {
      return;
    }
    final generation = _generation;
    emit(state.copyWith(isLoadingMore: true, loadMoreError: () => null));
    try {
      final page = await _repository.fetchProducts(
        skip: state.products.length,
        limit: pageSize,
      );
      if (generation != _generation) return;
      emit(state.copyWith(
        products: [...state.products, ...page.products],
        hasMore: page.hasMore && page.products.isNotEmpty,
        isLoadingMore: false,
      ));
    } on ApiException catch (e) {
      if (generation != _generation) return;
      emit(state.copyWith(isLoadingMore: false, loadMoreError: () => e.message));
    }
  }
}
