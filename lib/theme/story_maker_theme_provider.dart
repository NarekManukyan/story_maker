import 'package:flutter/widgets.dart';

import 'story_maker_theme.dart';

/// An [InheritedWidget] that provides [StoryMakerTheme] to its descendants.
///
/// This widget allows child widgets to access the theme without prop drilling.
/// Use [StoryMakerThemeProvider.of] to retrieve the theme from the widget tree.
class StoryMakerThemeProvider extends InheritedWidget {
  /// The theme to provide to descendants.
  final StoryMakerTheme theme;

  /// Creates a [StoryMakerThemeProvider] that provides [theme] to its descendants.
  const StoryMakerThemeProvider({
    super.key,
    required this.theme,
    required super.child,
  });

  /// Returns the [StoryMakerTheme] from the nearest [StoryMakerThemeProvider]
  /// ancestor in the widget tree.
  ///
  /// If no [StoryMakerThemeProvider] is found, returns the default theme.
  ///
  /// Throws an [AssertionError] if no theme is found and [nullOk] is false.
  static StoryMakerTheme of(BuildContext context, {bool nullOk = false}) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<StoryMakerThemeProvider>();

    if (provider != null) {
      return provider.theme;
    }

    if (nullOk) {
      return StoryMakerTheme.defaultTheme();
    }

    throw AssertionError(
      'StoryMakerThemeProvider not found in widget tree. '
      'Make sure StoryMakerThemeProvider is an ancestor of this widget.',
    );
  }

  /// Returns the [StoryMakerTheme] from the nearest [StoryMakerThemeProvider]
  /// ancestor in the widget tree, or null if not found.
  ///
  /// This is a convenience method that calls [of] with [nullOk] set to true.
  static StoryMakerTheme? maybeOf(BuildContext context) {
    try {
      return of(context, nullOk: true);
    } catch (e) {
      return null;
    }
  }

  @override
  bool updateShouldNotify(StoryMakerThemeProvider oldWidget) {
    return theme != oldWidget.theme;
  }
}
