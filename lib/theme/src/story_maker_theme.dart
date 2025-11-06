import 'package:flutter/material.dart';

/// A theme class for customizing the appearance of StoryMaker.
///
/// This class allows you to customize colors, styles, shadows, and other
/// visual properties to match your app's design system (e.g., neumorphic design).
class StoryMakerTheme {
  /// Creates a theme with the specified properties.
  const StoryMakerTheme({
    this.backgroundColor = Colors.black,
    this.buttonColor = Colors.white,
    this.buttonTextColor = Colors.black,
    this.iconColor = Colors.white,
    this.textColor = Colors.white,
    this.borderColor = Colors.white,
    this.buttonBorderRadius = 18.0,
    this.toolbarButtonBorderRadius = 32.0,
    this.buttonShadow,
    this.toolbarButtonShadow,
    this.doneButtonStyle,
    this.toolbarButtonStyle,
    this.overlayColor = const Color(0x66000000),
    this.textInputOverlayColor = const Color(0x66000000),
    this.removeWidgetColor = Colors.red,
    this.removeWidgetBorderRadius = 30.0,
    this.stickerSelectorBackgroundColor = const Color(0x4D000000),
    this.stickerSelectorBorderColor = const Color(0x80FFFFFF),
    this.colorPickerBackgroundColor = const Color(0x4D000000),
    this.gradientSelectorBackgroundColor = const Color(0x4D000000),
    this.safeAreaBorderRadius = 24.0,
  });

  /// The background color of the StoryMaker.
  final Color backgroundColor;

  /// The color of buttons (e.g., done button).
  final Color buttonColor;

  /// The text color of buttons.
  final Color buttonTextColor;

  /// The color of icons in toolbars.
  final Color iconColor;

  /// The color of text elements.
  final Color textColor;

  /// The color of borders.
  final Color borderColor;

  /// The border radius of buttons (e.g., done button).
  final double buttonBorderRadius;

  /// The border radius of toolbar buttons.
  final double toolbarButtonBorderRadius;

  /// The shadow for buttons (e.g., done button).
  final BoxShadow? buttonShadow;

  /// The shadow for toolbar buttons.
  final BoxShadow? toolbarButtonShadow;

  /// Custom button style for the done button.
  /// If null, default style will be used based on [buttonColor], [buttonTextColor], etc.
  final ButtonStyle? doneButtonStyle;

  /// Custom decoration for toolbar buttons.
  /// If null, default decoration will be used based on [toolbarButtonStyle] properties.
  final BoxDecoration? toolbarButtonStyle;

  /// The color of overlays (e.g., when text input is active).
  final Color overlayColor;

  /// The color of the overlay when text input is active.
  final Color textInputOverlayColor;

  /// The color of the remove widget (delete indicator).
  final Color removeWidgetColor;

  /// The border radius of the remove widget.
  final double removeWidgetBorderRadius;

  /// The background color of the sticker selector.
  final Color stickerSelectorBackgroundColor;

  /// The border color of sticker selector items.
  final Color stickerSelectorBorderColor;

  /// The background color of the color picker.
  final Color colorPickerBackgroundColor;

  /// The background color of the gradient selector.
  final Color gradientSelectorBackgroundColor;

  /// The border radius for the safe area clip (rounded corners).
  final double safeAreaBorderRadius;

  /// Creates a default theme with standard Material Design colors.
  factory StoryMakerTheme.defaultTheme() {
    return const StoryMakerTheme();
  }

  /// Creates a dark theme variant.
  factory StoryMakerTheme.dark() {
    return const StoryMakerTheme(
      backgroundColor: Color(0xFF121212),
      buttonColor: Color(0xFF1E1E1E),
      buttonTextColor: Colors.white,
      borderColor: Color(0x33FFFFFF),
      overlayColor: Color(0x80000000),
      textInputOverlayColor: Color(0x80000000),
      safeAreaBorderRadius: 32,
    );
  }

  /// Creates a light theme variant.
  factory StoryMakerTheme.light() {
    return const StoryMakerTheme(
      backgroundColor: Color(0xFFF5F5F5),
      buttonTextColor: Color(0xFF333333),
      iconColor: Color(0xFF333333),
      textColor: Color(0xFF333333),
      borderColor: Color(0x1A000000),
      safeAreaBorderRadius: 32,
    );
  }

  /// Creates a copy of this theme with the given fields replaced with new values.
  StoryMakerTheme copyWith({
    Color? backgroundColor,
    Color? buttonColor,
    Color? buttonTextColor,
    Color? iconColor,
    Color? textColor,
    Color? borderColor,
    double? buttonBorderRadius,
    double? toolbarButtonBorderRadius,
    BoxShadow? buttonShadow,
    BoxShadow? toolbarButtonShadow,
    ButtonStyle? doneButtonStyle,
    BoxDecoration? toolbarButtonStyle,
    Color? overlayColor,
    Color? textInputOverlayColor,
    Color? removeWidgetColor,
    double? removeWidgetBorderRadius,
    Color? stickerSelectorBackgroundColor,
    Color? stickerSelectorBorderColor,
    Color? colorPickerBackgroundColor,
    Color? gradientSelectorBackgroundColor,
    double? safeAreaBorderRadius,
  }) {
    return StoryMakerTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      buttonColor: buttonColor ?? this.buttonColor,
      buttonTextColor: buttonTextColor ?? this.buttonTextColor,
      iconColor: iconColor ?? this.iconColor,
      textColor: textColor ?? this.textColor,
      borderColor: borderColor ?? this.borderColor,
      buttonBorderRadius: buttonBorderRadius ?? this.buttonBorderRadius,
      toolbarButtonBorderRadius:
          toolbarButtonBorderRadius ?? this.toolbarButtonBorderRadius,
      buttonShadow: buttonShadow ?? this.buttonShadow,
      toolbarButtonShadow: toolbarButtonShadow ?? this.toolbarButtonShadow,
      doneButtonStyle: doneButtonStyle ?? this.doneButtonStyle,
      toolbarButtonStyle: toolbarButtonStyle ?? this.toolbarButtonStyle,
      overlayColor: overlayColor ?? this.overlayColor,
      textInputOverlayColor:
          textInputOverlayColor ?? this.textInputOverlayColor,
      removeWidgetColor: removeWidgetColor ?? this.removeWidgetColor,
      removeWidgetBorderRadius:
          removeWidgetBorderRadius ?? this.removeWidgetBorderRadius,
      stickerSelectorBackgroundColor:
          stickerSelectorBackgroundColor ?? this.stickerSelectorBackgroundColor,
      stickerSelectorBorderColor:
          stickerSelectorBorderColor ?? this.stickerSelectorBorderColor,
      colorPickerBackgroundColor:
          colorPickerBackgroundColor ?? this.colorPickerBackgroundColor,
      gradientSelectorBackgroundColor: gradientSelectorBackgroundColor ??
          this.gradientSelectorBackgroundColor,
      safeAreaBorderRadius: safeAreaBorderRadius ?? this.safeAreaBorderRadius,
    );
  }
}
