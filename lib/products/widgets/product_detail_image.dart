import 'package:flutter/material.dart';

class ProductDetailImage extends StatelessWidget {
  const ProductDetailImage({
    required this.imageUrl,
    required this.tag,
    super.key,
  });

  final String imageUrl;
  final String tag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AspectRatio(
      aspectRatio: 1.2,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        child: Hero(
          tag: tag,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: theme.colorScheme.surfaceContainerHighest,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: theme.colorScheme.surfaceContainerHighest,
                child: const Center(
                  child: Icon(Icons.image_not_supported, size: 64),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
