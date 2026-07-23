import 'package:flutter/material.dart';

import '../../utils/utils.dart';

/// A widget that displays the app logo.
///
/// The [AppLogo] widget takes in an  parameter to control the aspect ratio of the logo.
/// It renders an [AspectRatio] widget with the specified aspect ratio, containing a [Placeholder] widget
/// with a padding of 8 pixels and a child [Text] widget displaying the text 'Logo goes here'.
class AppLogo extends StatelessWidget {
  const AppLogo({this.imageWidth, this.imageHeight, super.key});
  final double? imageWidth;
  final double? imageHeight;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'app-logo',
      child: Center(
        child: Image.asset(
          AppImages.logo,
          fit: BoxFit.fitWidth,
          width: imageWidth,
          height: imageHeight,
        ),
      ),
    );
  }
}
