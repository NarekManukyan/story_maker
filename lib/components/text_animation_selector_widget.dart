import 'package:flutter/material.dart';

import '../constants/text_animations.dart';
import '../extensions/context_extension.dart';

/// A widget for selecting text animations.
///
/// This widget displays a horizontal scrollable list of text animations that users can select.
class TextAnimationSelectorWidget extends StatelessWidget {
  /// The duration of animations within the widget.
  final Duration animationsDuration;

  /// A callback function that is called when an animation is tapped.
  final Function(int index) onAnimationTap;

  /// The currently selected animation index.
  final int selectedAnimationIndex;

  /// Indicates whether the widget is visible.
  final bool isVisible;

  /// Creates an instance of the widget.
  const TextAnimationSelectorWidget({
    super.key,
    required this.animationsDuration,
    required this.onAnimationTap,
    required this.selectedAnimationIndex,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: AnimatedPositioned(
        duration: animationsDuration,
        bottom: context.media.viewInsets.bottom + 8,
        right: 0,
        left: 0,
        child: Container(
          height: context.width * .1,
          width: context.width,
          alignment: Alignment.center,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: TextAnimationType.values.length,
            itemBuilder: (context, index) {
              final animationType = TextAnimationType.values[index];
              final isSelected = index == selectedAnimationIndex;
              return GestureDetector(
                onTap: () => onAnimationTap(index),
                child: Container(
                  height: context.width * .1,
                  width: context.width * .1,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white
                        : Colors.black.withOpacity(0.4),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      getAnimationName(animationType),
                      style: TextStyle(
                        color: isSelected ? Colors.red : Colors.white,
                        fontSize: 10,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

