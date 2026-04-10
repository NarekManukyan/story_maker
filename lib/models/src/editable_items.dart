import 'package:flutter/material.dart';

import '../../constants/src/item_type.dart';
import '../../constants/src/ui_constants.dart';

/// A class representing an editable item on the story canvas.
///
/// An editable item can be text, an image, or a sticker that the user
/// can manipulate via gestures (drag, rotate, scale).
@immutable
class EditableItem {
  const EditableItem({
    this.position = const Offset(
      PositionConstants.defaultTextPositionX,
      PositionConstants.defaultTextPositionY,
    ),
    this.scale = 1,
    this.rotation = 0,
    this.type = ItemType.TEXT,
    this.value = '',
    this.color = Colors.transparent,
    this.textStyle = 0,
    this.fontSize = FontSizeConstants.defaultValue,
    this.fontFamily = 0,
  });

  /// The position of the item as a fraction of the canvas size.
  final Offset position;

  /// The scale factor relative to the original size.
  final double scale;

  /// The rotation angle in radians.
  final double rotation;

  /// The type of the item (TEXT, IMAGE, or STICKER).
  final ItemType type;

  /// The content value — text content, file path, or emoji string.
  final String value;

  /// The color of the item. For text items, this is the text color.
  final Color color;

  /// The index of the text background gradient style.
  final int textStyle;

  /// The font size in logical pixels.
  final double fontSize;

  /// The index of the font family in the font list.
  final int fontFamily;

  /// Creates a copy with the given fields replaced.
  EditableItem copyWith({
    Offset? position,
    double? scale,
    double? rotation,
    ItemType? type,
    String? value,
    Color? color,
    int? textStyle,
    double? fontSize,
    int? fontFamily,
  }) {
    return EditableItem(
      position: position ?? this.position,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      type: type ?? this.type,
      value: value ?? this.value,
      color: color ?? this.color,
      textStyle: textStyle ?? this.textStyle,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditableItem &&
          runtimeType == other.runtimeType &&
          position == other.position &&
          scale == other.scale &&
          rotation == other.rotation &&
          type == other.type &&
          value == other.value &&
          color == other.color &&
          textStyle == other.textStyle &&
          fontSize == other.fontSize &&
          fontFamily == other.fontFamily;

  @override
  int get hashCode => Object.hash(
        position,
        scale,
        rotation,
        type,
        value,
        color,
        textStyle,
        fontSize,
        fontFamily,
      );
}
