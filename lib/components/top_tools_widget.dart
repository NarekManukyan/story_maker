import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../extensions/context_extension.dart';
import '../models/editable_items.dart';
import '../theme/story_maker_theme.dart';
import '../theme/story_maker_theme_provider.dart';

/// A widget for displaying the top tools.
///
/// This widget is a part of the UI where the user can interact with the top tools.
/// It is a stateless widget that takes several parameters to control its behavior and appearance.
/// It uses a Positioned widget to display the top tools, and the user can interact with it by tapping on it.
class TopToolsWidget extends StatelessWidget {
  /// Indicates whether the widget is in text input mode.
  final bool isTextInput;

  /// The duration of animations within the widget.
  final Duration animationsDuration;

  /// The active item that can be interacted with.
  final EditableItem? activeItem;

  /// The index of the currently selected background gradient.
  final int selectedBackgroundGradientIndex;

  /// The index of the currently selected text background gradient.
  final int selectedTextBackgroundGradientIndex;

  /// A callback function that is called when the screen is tapped.
  final VoidCallback onScreenTap;

  /// A callback function that is called when the picker is tapped.
  final VoidCallback onPickerTap;

  /// A callback function that is called when the text color picker is toggled.
  final VoidCallback onToggleTextColorPicker;

  /// A callback function that is called when the text background is changed.
  final VoidCallback onChangeTextBackground;

  /// A callback function that is called when the sticker button is tapped.
  final VoidCallback? onStickerTap;

  /// The list of gradients to use.
  final List<List<Color>> gradients;

  /// Creates an instance of the widget.
  ///
  /// All parameters are required and must not be null.
  const TopToolsWidget({
    super.key,
    required this.isTextInput,
    required this.animationsDuration,
    this.selectedBackgroundGradientIndex = 0,
    this.selectedTextBackgroundGradientIndex = 0,
    required this.onScreenTap,
    required this.onPickerTap,
    required this.onToggleTextColorPicker,
    required this.onChangeTextBackground,
    required this.gradients,
    this.activeItem,
    this.onStickerTap,
  });

  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method when this widget is inserted into the tree in a given BuildContext and when the dependencies of this widget change.
  Widget _buildButtonWithBackdrop({
    required Widget child,
    required BoxDecoration decoration,
    required BuildContext context,
    required StoryMakerTheme theme,
  }) {
    // Get border radius from decoration or use default
    final borderRadius = decoration.borderRadius as BorderRadius? ??
        BorderRadius.circular(theme.toolbarButtonBorderRadius);

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: DecoratedBox(
          decoration: decoration.copyWith(
            color: Colors.black54,
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = StoryMakerThemeProvider.of(context);
    if (isTextInput) {
      return Positioned(
        top: context.topPadding,
        child: Container(
          width: context.width,
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButtonWithBackdrop(
                context: context,
                theme: theme,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.color_lens_outlined,
                    color: theme.iconColor,
                  ),
                  onPressed: onToggleTextColorPicker,
                ),
              ),
              const SizedBox(width: 8),
              _buildButtonWithBackdrop(
                context: context,
                theme: theme,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.topLeft,
                    end: FractionalOffset.bottomRight,
                    colors: gradients[selectedTextBackgroundGradientIndex],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.auto_awesome,
                    color: theme.iconColor,
                  ),
                  onPressed: onChangeTextBackground,
                ),
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
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: _buildButtonWithBackdrop(
                      context: context,
                      theme: theme,
                      decoration: theme.toolbarButtonStyle ??
                          BoxDecoration(
                            border: Border.all(color: theme.borderColor),
                            borderRadius: BorderRadius.circular(
                              theme.toolbarButtonBorderRadius,
                            ),
                            boxShadow: theme.toolbarButtonShadow != null
                                ? [theme.toolbarButtonShadow!]
                                : null,
                          ),
                      child: SizedBox(
                        height: 36,
                        width: 36,
                        child: Icon(
                          Icons.arrow_back,
                          size: 18,
                          color: theme.iconColor,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onPickerTap,
                    child: _buildButtonWithBackdrop(
                      context: context,
                      theme: theme,
                      decoration: theme.toolbarButtonStyle ??
                          BoxDecoration(
                            border: Border.all(color: theme.borderColor),
                            borderRadius: BorderRadius.circular(
                              theme.toolbarButtonBorderRadius,
                            ),
                            boxShadow: theme.toolbarButtonShadow != null
                                ? [theme.toolbarButtonShadow!]
                                : null,
                          ),
                      child: SizedBox(
                        height: 36,
                        width: 36,
                        child: Icon(
                          Icons.auto_awesome,
                          size: 18,
                          color: theme.iconColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onScreenTap,
                    child: _buildButtonWithBackdrop(
                      context: context,
                      theme: theme,
                      decoration: theme.toolbarButtonStyle ??
                          BoxDecoration(
                            border: Border.all(color: theme.borderColor),
                            borderRadius: BorderRadius.circular(
                              theme.toolbarButtonBorderRadius,
                            ),
                            boxShadow: theme.toolbarButtonShadow != null
                                ? [theme.toolbarButtonShadow!]
                                : null,
                          ),
                      child: SizedBox(
                        height: 36,
                        width: 36,
                        child: Center(
                          child: Text(
                            'Aa',
                            style: GoogleFonts.ubuntu(
                              color: theme.iconColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (onStickerTap != null) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onStickerTap,
                      child: _buildButtonWithBackdrop(
                        context: context,
                        theme: theme,
                        decoration: theme.toolbarButtonStyle ??
                            BoxDecoration(
                              border: Border.all(color: theme.borderColor),
                              borderRadius: BorderRadius.circular(
                                theme.toolbarButtonBorderRadius,
                              ),
                              boxShadow: theme.toolbarButtonShadow != null
                                  ? [theme.toolbarButtonShadow!]
                                  : null,
                            ),
                        child: SizedBox(
                          height: 36,
                          width: 36,
                          child: Icon(
                            Icons.emoji_emotions,
                            size: 18,
                            color: theme.iconColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
