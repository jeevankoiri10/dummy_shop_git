import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';

/// Network image with placeholder and fallback.
class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.url, this.fit = BoxFit.cover});

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).colorScheme.surfaceContainerHighest;
    // Generated placeholder for products with no image.
    final src = url.isEmpty ? '$kBaseUrl/image/400x400?text=No+image' : url;
    // CachedNetworkImage goes black on web after scrolling away and back.
    if (kIsWeb) {
      return Image.network(
        src,
        fit: fit,
        frameBuilder: (_, child, frame, __) =>
            frame == null ? ColoredBox(color: bg) : child,
        errorBuilder: (_, __, ___) => _fallback(bg),
      );
    }
    return CachedNetworkImage(
      imageUrl: src,
      fit: fit,
      placeholder: (_, __) => ColoredBox(color: bg),
      errorWidget: (_, __, ___) => _fallback(bg),
    );
  }

  Widget _fallback(Color bg) => ColoredBox(
        color: bg,
        child: const Center(child: Icon(Icons.image_not_supported_outlined)),
      );
}
