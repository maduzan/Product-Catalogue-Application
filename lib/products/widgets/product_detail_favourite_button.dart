import 'package:flutter/material.dart';

class ProductDetailFavouriteButton extends StatelessWidget {
  const ProductDetailFavouriteButton({
    required this.isFavourite,
    required this.onPressed,
    super.key,
  });

  final bool isFavourite;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: isFavourite
          ? theme.colorScheme.errorContainer
          : theme.colorScheme.surfaceContainerHigh,
      elevation: 3,
      child: Icon(
        isFavourite ? Icons.favorite : Icons.favorite_border,
        color: isFavourite ? Colors.red : theme.colorScheme.onSurface,
        size: 26,
      ),
    );
  }
}
