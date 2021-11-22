import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../extensions/context_extension.dart';
import '../models/editable_items.dart';

class RemoveWidget extends StatelessWidget {
  const RemoveWidget({
    Key? key,
    required this.isTextInput,
    required EditableItem? activeItem,
    required this.isDeletePosition,
    required this.animationsDuration,
  })  : _activeItem = activeItem,
        super(key: key);

  final bool isTextInput;
  final EditableItem? _activeItem;
  final bool isDeletePosition;
  final Duration animationsDuration;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !isTextInput,
      child: Positioned(
        bottom: 80 + context.bottomPadding,
        child: AnimatedSwitcher(
          duration: animationsDuration,
          child: _activeItem == null
              ? const SizedBox()
              : AnimatedSize(
                  duration: animationsDuration,
                  child: SizedBox(
                    width: context.width,
                    child: Center(
                      child: AnimatedContainer(
                        duration: animationsDuration,
                        height: !isDeletePosition ? 60.0 : 72,
                        width: !isDeletePosition ? 60.0 : 72,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              !isDeletePosition ? 30 : 38,
                            ),
                          ),
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
