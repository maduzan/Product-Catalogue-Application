import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// A widget that represents a fixed gap with a specific main axis extent.
/// Creates a [FixedGap] widget.
///
/// The [mainAxisExtent] parameter specifies the extent of the gap along the main axis.
/// The extent of the gap along the main axis.
///
/// Example usage:
///
/// ```dart
///   Column(
///    children: [
///     const Text('Item 1'),
///     const FixedGap(mainAxisExtent: 16),
///     const Text('Item 2'),
///    ],
///   )
/// ```
///
///
class FixedGap extends StatelessWidget {
  const FixedGap({
    required this.mainAxisExtent,
    super.key,
  });

  final double mainAxisExtent;

  @override
  Widget build(BuildContext context) {
    return Gap(
      mainAxisExtent,
    );
  }
}
