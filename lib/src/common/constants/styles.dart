import 'package:flutter/material.dart';

class AppStyles {
  // Border Radius
  static const double cardRadius = 16.0;
  static const double buttonRadius = 8.0;
  static const double inputRadius = 8.0;

  // Spacing
  static const double spacing = 16.0;
  static const double smallSpacing = 8.0;
  static const double largeSpacing = 24.0;

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  );

  // Input Decoration
  static InputDecoration getInputDecoration({
    required String hintText,
    required Color fillColor,
    required Color textColor,
    required Color borderColor,
  }) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputRadius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputRadius),
        borderSide: BorderSide(
          color: borderColor,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacing,
        vertical: smallSpacing,
      ),
    );
  }
}
