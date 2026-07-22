import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// A widget that represents a relative gap in the main axis of a layout.
///
/// The [RelativeGap] widget is used to create a gap with a size relative to the
/// main axis extent of the parent layout. It is commonly used to add spacing
/// between widgets in a layout.
///
/// The [mainAxisExtent] parameter specifies the relative size of the gap
/// compared to the main axis extent of the parent layout. It should be a value
/// between 0.0 and 1.0, where 0.0 represents no gap and 1.0 represents a gap
/// equal to the full main axis extent.
///
/// Example usage:
///
/// ```dart
/// RelativeGap(
///   mainAxisExtent: 0.2,
/// )
/// ```
class RelativeGap extends StatelessWidget {
  const RelativeGap({
    required this.mainAxisExtent,
    super.key,
  });

  final double mainAxisExtent;

  @override
  Widget build(BuildContext context) {
    return Gap(
      MediaQuery.sizeOf(context).height * mainAxisExtent,
    );
  }
}
