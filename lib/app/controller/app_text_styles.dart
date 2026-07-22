import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum FontSize {
  xxl(22),
  md(16),
  s(14);

  const FontSize(this.size);
  final double size;
}

TextStyle platypi({
  required FontSize fontSize,
  Color? color,
  FontWeight weight = FontWeight.w400,
  double letterSpacing = 0.0,
  double? height,
  TextDecoration? decoration,
}) =>
    GoogleFonts.platypi(
      color: color ?? Colors.black,
      fontSize: fontSize.size,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
    );

TextStyle buttonPrimary(Color color) =>
    platypi(color: color, fontSize: FontSize.s, weight: FontWeight.w700);
TextStyle buttonSecondary(Color color) =>
    platypi(color: color, fontSize: FontSize.s, weight: FontWeight.w700);
TextStyle buttonTertiary(Color color) =>
    platypi(color: color, fontSize: FontSize.s, weight: FontWeight.w700);
TextStyle formBody(Color color) => platypi(color: color, fontSize: FontSize.s);
TextStyle navBarAction(Color color) =>
    platypi(color: color, fontSize: FontSize.md);
TextStyle navBarTitle(Color color) =>
    platypi(color: color, fontSize: FontSize.md, weight: FontWeight.w500);

TextStyle formHint(Color color) =>
    platypi(color: color, fontSize: FontSize.s, weight: FontWeight.w500);

extension TextStyleExtension on BuildContext {
  Color get _defaultColor => Theme.of(this).colorScheme.onSurface;

  TextStyle _style({
    required FontSize size,
    required FontWeight weight,
    Color? color,
    double? letterSpacing,
    double? height,
    FontWeight? overrideWeight,
  }) {
    return platypi(
      fontSize: size,
      color: color ?? _defaultColor,
      weight: overrideWeight ?? weight,
      letterSpacing: letterSpacing ?? 0.0,
      height: height,
    );
  }

  TextStyle bodySmall(
          {Color? color,
          double? letterSpacing,
          double? height,
          FontWeight? weight}) =>
      _style(
          size: FontSize.s,
          weight: FontWeight.w400,
          color: color,
          letterSpacing: letterSpacing,
          height: height,
          overrideWeight: weight);

  TextStyle bodyDefault(
          {Color? color,
          double? letterSpacing,
          double? height,
          FontWeight? weight}) =>
      _style(
          size: FontSize.s,
          weight: FontWeight.w400,
          color: color,
          letterSpacing: letterSpacing,
          height: height,
          overrideWeight: weight);

  TextStyle bodyLarge(
          {Color? color,
          double? letterSpacing,
          double? height,
          FontWeight? weight}) =>
      _style(
          size: FontSize.md,
          weight: FontWeight.w400,
          color: color,
          letterSpacing: letterSpacing,
          height: height,
          overrideWeight: weight);

  TextStyle headline1(
          {Color? color,
          double? letterSpacing,
          double? height,
          FontWeight? weight}) =>
      _style(
          size: FontSize.xxl,
          weight: FontWeight.w700,
          color: color,
          letterSpacing: letterSpacing,
          height: height,
          overrideWeight: weight);

  TextStyle headline2(
          {Color? color,
          double? letterSpacing,
          double? height,
          FontWeight? weight}) =>
      _style(
          size: FontSize.xxl,
          weight: FontWeight.w700,
          color: color,
          letterSpacing: letterSpacing,
          height: height,
          overrideWeight: weight);

  TextStyle headline3(
          {Color? color,
          double? letterSpacing,
          double? height,
          FontWeight? weight}) =>
      _style(
          size: FontSize.md,
          weight: FontWeight.w600,
          color: color,
          letterSpacing: letterSpacing,
          height: height,
          overrideWeight: weight);

  TextStyle headline4(
          {Color? color,
          double? letterSpacing,
          double? height,
          FontWeight? weight}) =>
      _style(
          size: FontSize.s,
          weight: FontWeight.w700,
          color: color,
          letterSpacing: letterSpacing,
          height: height,
          overrideWeight: weight);
}

extension TextStyleFluentExtension on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
  TextStyle get extraLight => copyWith(fontWeight: FontWeight.w200);
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  TextStyle setColor(Color color) => copyWith(color: color);
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);
  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);
}
