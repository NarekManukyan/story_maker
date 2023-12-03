import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/font_styles.dart';
import '../constants/gradients.dart';
import '../constants/item_type.dart';
import '../extensions/context_extension.dart';
import '../models/editable_items.dart';
import '../utils/gradient_util.dart';

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
                    fontFamilyList[editableItem.fontFamily],
                  ).copyWith(
                    color: editableItem.color,
                    fontSize: editableItem.fontSize,
                    background: Paint()
                      ..strokeWidth = 24
                      ..shader = createShader(
                        colors: gradientColors[editableItem.textStyle],
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
                      fontFamilyList[editableItem.fontFamily],
                    ).copyWith(
                      color: editableItem.color,
                      fontSize: editableItem.fontSize,
                      background: Paint()
                        ..shader = createShader(
                          colors: gradientColors[editableItem.textStyle],
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
