import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../extensions/src/context_extension.dart';
import '../../theme/src/story_maker_theme.dart';
import '../../theme/src/story_maker_theme_provider.dart';

/// A widget for displaying footer tools.
///
/// This widget is a part of the UI where the user can interact with footer tools.
/// It is a stateless widget that takes several parameters to control its behavior and appearance.
/// It uses an ElevatedButton to display a done button, and the user can interact with it by tapping on it.
class FooterToolsWidget extends StatelessWidget {
  /// A callback function that is called when the done button is pressed.
  final AsyncCallback onDone;

  /// The child widget of the done button.
  final Widget? doneButtonChild;

  /// Indicates whether the widget is in loading state.
  final bool isLoading;

  /// Custom widget builder for the done button.
  /// If provided, this will be used instead of the default button.
  final Widget Function(
    StoryMakerTheme theme,
    AsyncCallback onDone,
    bool isLoading,
  )? doneButtonBuilder;

  /// Creates an instance of the widget.
  ///
  /// The onDone parameter is required and must not be null.
  /// The doneButtonChild and isLoading parameters are optional.
  const FooterToolsWidget({
    super.key,
    required this.onDone,
    this.doneButtonChild,
    this.isLoading = false,
    this.doneButtonBuilder,
  });

  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method when this widget is inserted into the tree in a given BuildContext and when the dependencies of this widget change.
  @override
  Widget build(BuildContext context) {
    final theme = StoryMakerThemeProvider.of(context);
    return Container(
      height: context.bottomPadding + kToolbarHeight,
      alignment: Alignment.topCenter,
      child: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 4, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (doneButtonBuilder != null)
                    doneButtonBuilder!(theme, onDone, isLoading)
                  else
                    ElevatedButton(
                      onPressed: isLoading ? null : onDone,
                      style: theme.doneButtonStyle ??
                          ButtonStyle(
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(theme.buttonBorderRadius),
                                ),
                              ),
                            ),
                            shadowColor: WidgetStateProperty.all(
                              theme.buttonShadow?.color ?? theme.buttonColor,
                            ),
                            backgroundColor:
                                WidgetStateProperty.all(theme.buttonColor),
                            elevation: WidgetStateProperty.all(
                              theme.buttonShadow != null ? 4 : 0,
                            ),
                          ),
                      child: isLoading
                          ? CupertinoActivityIndicator(
                              color: theme.buttonTextColor,
                            )
                          : doneButtonChild ??
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(width: 4),
                                  Text(
                                    'Add to story',
                                    style: TextStyle(
                                      color: theme.buttonTextColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    CupertinoIcons.forward,
                                    color: theme.buttonTextColor,
                                    size: 18,
                                  ),
                                ],
                              ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
