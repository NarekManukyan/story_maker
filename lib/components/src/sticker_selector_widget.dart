import 'dart:io';

import 'package:flutter/material.dart';

import '../../extensions/src/context_extension.dart';
import '../../models/src/sticker_item.dart';
import '../../theme/src/story_maker_theme_provider.dart';

/// A widget for selecting stickers.
///
/// This widget displays a horizontal scrollable list of stickers that users can select.
class StickerSelectorWidget extends StatelessWidget {
  /// The list of stickers to display.
  final List<StickerItem> stickers;

  /// The duration of animations within the widget.
  final Duration animationsDuration;

  /// A callback function that is called when a sticker is tapped.
  final Function(StickerItem sticker) onStickerTap;

  /// Indicates whether the widget is visible.
  final bool isVisible;

  /// Creates an instance of the widget.
  const StickerSelectorWidget({
    super.key,
    required this.stickers,
    required this.animationsDuration,
    required this.onStickerTap,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    final theme = StoryMakerThemeProvider.of(context);
    return Visibility(
      visible: isVisible,
      child: AnimatedPositioned(
        duration: animationsDuration,
        bottom: 80 + context.bottomPadding,
        right: 0,
        left: 0,
        child: Container(
          height: context.width * .175,
          width: context.width,
          alignment: Alignment.center,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: stickers.length,
            itemBuilder: (context, index) {
              final sticker = stickers[index];
              return GestureDetector(
                onTap: () => onStickerTap(sticker),
                child: Container(
                  height: context.width * .15,
                  width: context.width * .15,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: theme.stickerSelectorBackgroundColor,
                    borderRadius: BorderRadius.circular(context.width * .075),
                    border: Border.all(
                      color: theme.stickerSelectorBorderColor,
                    ),
                  ),
                  child: Center(
                    child: sticker.isImage
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(
                              context.width * .075,
                            ),
                            child: Image.file(
                              File(sticker.value),
                              fit: BoxFit.cover,
                              width: context.width * .15,
                              height: context.width * .15,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.broken_image,
                                  color: Colors.white,
                                  size: context.width * .1,
                                );
                              },
                            ),
                          )
                        : Text(
                            sticker.value,
                            style: TextStyle(
                              fontSize: context.width * .1,
                            ),
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
