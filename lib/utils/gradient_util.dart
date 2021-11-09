import 'dart:ui' as ui;

import 'package:flutter/material.dart';

ui.Shader createShader({
  required List<Color> colors,
  required double width,
  required double height,
}) {
  return LinearGradient(
    begin: FractionalOffset.topLeft,
    end: FractionalOffset.centerRight,
    colors: colors,
  ).createShader(
    Rect.fromLTWH(
      0,
      0,
      width,
      height,
    ),
  );
}
