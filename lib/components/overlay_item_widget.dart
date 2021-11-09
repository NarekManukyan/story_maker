import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/font_styles.dart';
import '../constants/gradients.dart';
import '../constants/item_type.dart';
import '../extensions/context_extension.dart';
import '../models/editable_items.dart';
import '../utils/gradient_util.dart';

class OverlayItemWidget extends StatelessWidget {
  final EditableItem editableItem;
  final VoidCallback onItemTap;
  final Function(PointerDownEvent)? onPointerDown;
  final Function(PointerUpEvent)? onPointerUp;
  final Function(PointerMoveEvent)? onPointerMove;

  const OverlayItemWidget({
    Key? key,
    required this.editableItem,
    required this.onItemTap,
    this.onPointerDown,
    this.onPointerUp,
    this.onPointerMove,
  }) : super(key: key);

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
        break;
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
