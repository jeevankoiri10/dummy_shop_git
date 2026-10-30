part of 'products_bloc.dart';

enum ProductsStatus { initial, loading, success, failure }

class ProductsState extends Equatable {
  const ProductsState({
    this.status = ProductsStatus.initial,
    this.products = const [],
    this.hasMore = true,
    this.errorMessage,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.loadMoreError,
    this.refreshError,
  });

  final ProductsStatus status;
  final List<Product> products;
  final bool hasMore;

  /// First page failed.
  final String? errorMessage;

  final bool isRefreshing;
  final bool isLoadingMore;

  /// Next page failed.
  final String? loadMoreError;

  /// Refresh failed, shown as a SnackBar.
  final String? refreshError;

  bool get isEmpty => status == ProductsStatus.success && products.isEmpty;

  ProductsState copyWith({
    ProductsStatus? status,
    List<Product>? products,
    bool? hasMore,
    String? Function()? errorMessage,
    bool? isRefreshing,
    bool? isLoadingMore,
    String? Function()? loadMoreError,
    String? Function()? refreshError,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError:
          loadMoreError != null ? loadMoreError() : this.loadMoreError,
      refreshError: refreshError != null ? refreshError() : this.refreshError,
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        hasMore,
        errorMessage,
        isRefreshing,
        isLoadingMore,
        loadMoreError,
        refreshError,
      ];
}
