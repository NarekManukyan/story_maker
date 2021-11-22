import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/gradients.dart';
import '../extensions/context_extension.dart';
import '../models/editable_items.dart';

class TopToolsWidget extends StatelessWidget {
  final bool isTextInput;
  final Duration animationsDuration;
  final EditableItem? activeItem;
  final int selectedBackgroundGradientIndex;
  final int selectedTextBackgroundGradientIndex;
  final VoidCallback onScreenTap;
  final VoidCallback onPickerTap;
  final VoidCallback onToggleTextColorPicker;
  final VoidCallback onChangeTextBackground;

  const TopToolsWidget({
    Key? key,
    required this.isTextInput,
    required this.animationsDuration,
    this.selectedBackgroundGradientIndex = 0,
    this.selectedTextBackgroundGradientIndex = 0,
    required this.onScreenTap,
    required this.onPickerTap,
    required this.onToggleTextColorPicker,
    required this.onChangeTextBackground,
    this.activeItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isTextInput) {
      return Positioned(
        top: context.topPadding,
        child: Container(
          width: context.width,
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.color_lens_outlined,
                  color: Colors.white,
                ),
                onPressed: onToggleTextColorPicker,
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: FractionalOffset.topLeft,
                      end: FractionalOffset.bottomRight,
                      colors:
                          gradientColors[selectedTextBackgroundGradientIndex],
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                  ),
                ),
                onPressed: onChangeTextBackground,
              ),
            ],
          ),
        ),
      );
    }

    return Positioned(
      top: context.topPadding + 12,
      right: 20,
      left: 20,
      child: AnimatedSwitcher(
        duration: animationsDuration,
        child: activeItem != null
            ? const SizedBox()
            : Row(
                children: [
                  const BackButton(
                    color: Colors.white,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onPickerTap,
                    child: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:
                              gradientColors[selectedBackgroundGradientIndex],
                        ),
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onScreenTap,
                    child: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Center(
                        child: Text(
                          'Aa',
                          style: GoogleFonts.ubuntu(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
