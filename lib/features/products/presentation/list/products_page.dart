import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/status_views.dart';
import '../../../auth/presentation/session/session_cubit.dart';
import '../../../users/presentation/profile_page.dart';
import '../../../users/presentation/user_avatar.dart';
import '../../data/products_repository.dart';
import '../detail/product_detail_page.dart';
import '../widgets/product_tile.dart';
import 'products_bloc.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsBloc(context.read<ProductsRepository>())
        ..add(const ProductsStarted()),
      child: const _ProductsView(),
    );
  }
}

class _ProductsView extends StatelessWidget {
  const _ProductsView();

  Future<void> _confirmLogout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Log out')),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await context.read<SessionCubit>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;
    final user = session is SessionAuthenticated ? session.user : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Center(
                child: Text('Hi, ${user.firstName}',
                    style: Theme.of(context).textTheme.labelLarge),
              ),
            ),
          if (user != null)
            IconButton(
              tooltip: 'Profile',
              icon: UserAvatar(username: user.username, url: user.image),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ProfilePage(userId: user.id),
                ),
              ),
            ),
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: BlocConsumer<ProductsBloc, ProductsState>(
        listenWhen: (prev, curr) =>
            curr.refreshError != null && prev.refreshError != curr.refreshError,
        listener: (context, state) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.refreshError!)));
        },
        builder: (context, state) {
          final bloc = context.read<ProductsBloc>();

          Future<void> onRefresh() {
            bloc.add(const ProductsRefreshed());
            // Keep spinning until the reload is done.
            return bloc.stream.firstWhere((s) => !s.isRefreshing);
          }

          switch (state.status) {
            case ProductsStatus.initial:
            case ProductsStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case ProductsStatus.failure:
              return StatusView(
                icon: Icons.cloud_off_rounded,
                title: "Couldn't load products",
                message: state.errorMessage,
                actionLabel: 'Retry',
                onAction: () => bloc.add(const ProductsStarted()),
              );

            case ProductsStatus.success:
              if (state.isEmpty) {
                return RefreshIndicator(
                  onRefresh: onRefresh,
                  child: const StatusView(
                    icon: Icons.inventory_2_outlined,
                    title: 'No products yet',
                    message: 'Pull down to refresh.',
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: onRefresh,
                child: _ProductList(state: state),
              );
          }
        },
      ),
    );
  }
}

class _ProductList extends StatelessWidget {
  const _ProductList({required this.state});

  final ProductsState state;

  @override
  Widget build(BuildContext context) {
    final products = state.products;
    final showFooter = state.hasMore || state.loadMoreError != null;

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: products.length + (showFooter ? 1 : 0),
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 110),
      itemBuilder: (context, index) {
        if (index >= products.length) {
          return _ListFooter(state: state);
        }
        final product = products[index];
        return ProductTile(
          product: product,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ProductDetailPage(product: product),
            ),
          ),
        );
      },
    );
  }
}

/// Last row. Building it loads the next page.
class _ListFooter extends StatelessWidget {
  const _ListFooter({required this.state});

  final ProductsState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProductsBloc>();

    if (state.loadMoreError != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(state.loadMoreError!, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => bloc.add(const ProductsNextPageRequested()),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (!state.isLoadingMore && state.hasMore) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!bloc.isClosed) bloc.add(const ProductsNextPageRequested());
      });
    }

    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
