part of 'products_bloc.dart';

sealed class ProductsEvent {
  const ProductsEvent();
}

/// First load or retry.
final class ProductsStarted extends ProductsEvent {
  const ProductsStarted();
}

/// Pull-to-refresh.
final class ProductsRefreshed extends ProductsEvent {
  const ProductsRefreshed();
}

/// Scrolled near the end, or footer retry.
final class ProductsNextPageRequested extends ProductsEvent {
  const ProductsNextPageRequested();
}
