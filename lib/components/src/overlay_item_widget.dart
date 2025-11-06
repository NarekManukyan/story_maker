import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/src/item_type.dart';
import '../../constants/src/ui_constants.dart';
import '../../extensions/src/context_extension.dart';
import '../../models/src/editable_items.dart';
import '../../utils/src/gradient_util.dart';

/// A widget for displaying an overlay item.
///
/// This widget is a part of the UI where the user can interact with an overlay item.
/// It is a stateless widget that takes several parameters to control its behavior and appearance.
/// It uses a Positioned widget to display the overlay item, and the user can interact with it by tapping on it.
class OverlayItemWidget extends StatelessWidget {
  /// The editable item to be displayed.
  final EditableItem editableItem;

  /// A callback function that is called when the item is tapped.
  final VoidCallback onItemTap;

  /// A callback function that is called when a pointer has contacted the screen at a particular location.
  final Function(PointerDownEvent)? onPointerDown;

  /// A callback function that is called when a pointer has stopped contacting the screen at a particular location.
  final Function(PointerUpEvent)? onPointerUp;

  /// A callback function that is called when a pointer has moved from one location on the screen to another.
  final Function(PointerMoveEvent)? onPointerMove;

  /// The list of font families to use.
  final List<String> fontList;

  /// The list of gradients to use.
  final List<List<Color>> gradients;

  /// Creates an instance of the widget.
  ///
  /// The editableItem and onItemTap parameters are required and must not be null.
  /// The onPointerDown, onPointerUp, and onPointerMove parameters are optional.
  const OverlayItemWidget({
    super.key,
    required this.editableItem,
    required this.onItemTap,
    this.onPointerDown,
    this.onPointerUp,
    this.onPointerMove,
    required this.fontList,
    required this.gradients,
  });

  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method when this widget is inserted into the tree in a given BuildContext and when the dependencies of this widget change.
  @override
  Widget build(BuildContext context) {
    SingleChildRenderObjectWidget overlayWidget;
    switch (editableItem.type) {
      case ItemType.TEXT:
        overlayWidget = SizedBox(
          width: context.width - 72,
          child: Stack(
            children: [
              Center(
                child: Text(
                  editableItem.value,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    fontList[editableItem.fontFamily],
                  ).copyWith(
                    color: editableItem.color,
                    fontSize: editableItem.fontSize,
                    background: Paint()
                      ..strokeWidth = TextStrokeConstants.strokeWidth
                      ..shader = createShader(
                        colors: gradients[editableItem.textStyle],
                        width: context.width,
                        height: context.height,
                      )
                      ..style = PaintingStyle.stroke
                      ..strokeJoin = StrokeJoin.round,
                  ),
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: onItemTap,
                  child: Text(
                    editableItem.value,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont(
                      fontList[editableItem.fontFamily],
                    ).copyWith(
                      color: editableItem.color,
                      fontSize: editableItem.fontSize,
                      background: Paint()
                        ..shader = createShader(
                          colors: gradients[editableItem.textStyle],
                          width: context.width,
                          height: context.height,
                        ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      case ItemType.IMAGE:
        overlayWidget = const Center();
      case ItemType.STICKER:
        // Check if the sticker is an image/GIF or emoji
        final isImageSticker = editableItem.value.contains('/') ||
            editableItem.value.endsWith('.png') ||
            editableItem.value.endsWith('.jpg') ||
            editableItem.value.endsWith('.jpeg') ||
            editableItem.value.endsWith('.gif') ||
            editableItem.value.startsWith('http');
        overlayWidget = Center(
          child: isImageSticker
              ? Image.file(
                  File(editableItem.value),
                  fit: BoxFit.contain,
                  width: editableItem.fontSize * 4,
                  height: editableItem.fontSize * 4,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: editableItem.fontSize * 2,
                    );
                  },
                )
              : Text(
                  editableItem.value,
                  style: TextStyle(
                    fontSize: editableItem.fontSize * 2,
                  ),
                ),
        );
    }

    return Positioned(
      top: editableItem.position.dy * context.height,
      left: editableItem.position.dx * context.width,
      child: Transform.scale(
        scale: editableItem.scale,
        child: Transform.rotate(
          angle: editableItem.rotation,
          child: Listener(
            onPointerDown: onPointerDown,
            onPointerUp: onPointerUp,
            onPointerCancel: (details) {},
            onPointerMove: onPointerMove,
            child: overlayWidget,
          ),
        ),
      ),
    );
  }
}
