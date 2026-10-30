import 'package:flutter/material.dart';

import '../../data/models/product.dart';
import '../widgets/product_image.dart';

/// Uses the product from the list, no extra request.
class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _imageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final theme = Theme.of(context);
    final images =
        product.images.isNotEmpty ? product.images : [product.thumbnail];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 340,
            title: Text(product.title,
                maxLines: 1, overflow: TextOverflow.ellipsis),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'product-${product.id}',
                    child: PageView.builder(
                      itemCount: images.length,
                      onPageChanged: (i) => setState(() => _imageIndex = i),
                      itemBuilder: (_, i) =>
                          ProductImage(url: images[i], fit: BoxFit.contain),
                    ),
                  ),
                  if (images.length > 1)
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: _PageDots(
                          count: images.length, index: _imageIndex),
                    ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            sliver: SliverList.list(
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(label: Text(product.category)),
                    if (product.brand != null) Chip(label: Text(product.brand!)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(product.title, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 12),
                _PriceRow(product: product),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('${product.rating.toStringAsFixed(1)} / 5',
                        style: theme.textTheme.bodyLarge),
                    const SizedBox(width: 20),
                    Icon(
                      product.stock > 0
                          ? Icons.check_circle_outline
                          : Icons.remove_circle_outline,
                      color: product.stock > 0
                          ? Colors.green
                          : theme.colorScheme.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      product.stock > 0
                          ? '${product.stock} in stock'
                          : 'Out of stock',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Description', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(product.description, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDiscount = product.discountPercentage > 0;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      children: [
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (hasDiscount) ...[
          Text(
            '\$${product.originalPrice.toStringAsFixed(2)}',
            style: theme.textTheme.titleMedium?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '-${product.discountPercentage.toStringAsFixed(0)}%',
              style: TextStyle(color: theme.colorScheme.onErrorContainer),
            ),
          ),
        ],
      ],
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: i == index ? 18 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: i == index ? color : color.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
