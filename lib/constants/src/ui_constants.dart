/// UI constants used throughout the story maker.
///
/// This file contains all magic numbers and UI-related constants
/// to make the codebase more maintainable and easier to configure.

/// Viewport fractions for PageControllers
class ViewportFractions {
  /// Viewport fraction for font family PageController
  static const double fontFamily = 0.125;

  /// Viewport fraction for text colors PageController
  static const double textColors = 0.1;

  /// Viewport fraction for gradients PageController
  static const double gradients = 0.175;
}

/// Position thresholds and offsets
class PositionConstants {
  /// Delete position threshold (Y coordinate)
  /// Items dragged below this threshold will be deleted
  static const double deletePositionThreshold = 0.65;

  /// Default text position offset
  static const double defaultTextPositionX = 0.1;
  static const double defaultTextPositionY = 0.4;
}

/// Font size constraints
class FontSizeConstants {
  /// Minimum font size
  static const double min = 14;

  /// Maximum font size
  static const double max = 74;

  /// Default font size
  static const double defaultValue = 26;
}

/// Remove widget dimensions
class RemoveWidgetConstants {
  /// Normal size of the remove widget
  static const double normalSize = 60;

  /// Expanded size when item is in delete position
  static const double expandedSize = 72;

  /// Normal border radius
  static const double normalBorderRadius = 30;

  /// Expanded border radius
  static const double expandedBorderRadius = 38;
}

/// Text stroke width for overlay items
class TextStrokeConstants {
  /// Stroke width for text background effect
  static const double strokeWidth = 24;
}

/// Aspect ratio for story preview
class StoryConstants {
  /// Story aspect ratio (9:16 for Instagram stories)
  static const double aspectRatio = 9 / 16;
}
