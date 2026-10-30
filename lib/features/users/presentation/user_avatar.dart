import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';

/// The user's image, or a generated identicon if they don't have one.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.username,
    this.url,
    this.radius = 14,
  });

  final String username;
  final String? url;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final src = url ?? '$kBaseUrl/icon/${Uri.encodeComponent(username)}/128';
    return CircleAvatar(
      radius: radius,
      foregroundImage: NetworkImage(src),
      onForegroundImageError: (_, __) {},
      child: Icon(Icons.person, size: radius),
    );
  }
}
