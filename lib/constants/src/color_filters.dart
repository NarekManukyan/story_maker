/// Enum representing different color filter types.
enum ColorFilterType {
  /// No filter applied.
  none,

  /// Sepia filter.
  sepia,

  /// Grayscale filter.
  grayscale,

  /// Vintage filter.
  vintage,

  /// Cool filter (blue tint).
  cool,

  /// Warm filter (orange/red tint).
  warm,

  /// Bright filter.
  bright,

  /// Dark filter.
  dark;

  /// Gets the 5x4 color matrix for this filter type.
  List<double> get matrix {
    return switch (this) {
      ColorFilterType.none => _identityMatrix,
      ColorFilterType.sepia => _sepiaMatrix,
      ColorFilterType.grayscale => _grayscaleMatrix,
      ColorFilterType.vintage => _vintageMatrix,
      ColorFilterType.cool => _coolMatrix,
      ColorFilterType.warm => _warmMatrix,
      ColorFilterType.bright => _brightMatrix,
      ColorFilterType.dark => _darkMatrix,
    };
  }

  /// Gets the human-readable display name for this filter.
  String get displayName {
    return switch (this) {
      ColorFilterType.none => 'None',
      ColorFilterType.sepia => 'Sepia',
      ColorFilterType.grayscale => 'Grayscale',
      ColorFilterType.vintage => 'Vintage',
      ColorFilterType.cool => 'Cool',
      ColorFilterType.warm => 'Warm',
      ColorFilterType.bright => 'Bright',
      ColorFilterType.dark => 'Dark',
    };
  }
}

const List<double> _identityMatrix = [
  1, 0, 0, 0, 0,
  0, 1, 0, 0, 0,
  0, 0, 1, 0, 0,
  0, 0, 0, 1, 0,
];

/// Color filter matrix for sepia effect.
const List<double> _sepiaMatrix = [
  0.393, 0.769, 0.189, 0, 0,
  0.349, 0.686, 0.168, 0, 0,
  0.272, 0.534, 0.131, 0, 0,
  0, 0, 0, 1, 0,
];

/// Color filter matrix for grayscale effect.
const List<double> _grayscaleMatrix = [
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0, 0, 0, 1, 0,
];

/// Color filter matrix for vintage effect.
const List<double> _vintageMatrix = [
  0.9, 0.5, 0.1, 0, 0,
  0.3, 0.8, 0.1, 0, 0,
  0.2, 0.3, 0.5, 0, 0,
  0, 0, 0, 1, 0,
];

/// Color filter matrix for cool effect (blue tint).
const List<double> _coolMatrix = [
  1, 0, 0, 0, 0,
  0, 1, 0.1, 0, 0,
  0, 0.1, 1, 0, 0,
  0, 0, 0, 1, 0,
];

/// Color filter matrix for warm effect (orange/red tint).
const List<double> _warmMatrix = [
  1, 0.1, 0, 0, 0,
  0, 1, 0, 0, 0,
  0, 0, 0.9, 0, 0,
  0, 0, 0, 1, 0,
];

/// Color filter matrix for bright effect.
const List<double> _brightMatrix = [
  1.2, 0, 0, 0, 0,
  0, 1.2, 0, 0, 0,
  0, 0, 1.2, 0, 0,
  0, 0, 0, 1, 0,
];

/// Color filter matrix for dark effect.
const List<double> _darkMatrix = [
  0.7, 0, 0, 0, 0,
  0, 0.7, 0, 0, 0,
  0, 0, 0.7, 0, 0,
  0, 0, 0, 1, 0,
];

/// Gets the color filter matrix for a given filter type.
///
/// Deprecated: Use [ColorFilterType.matrix] instead.
List<double> getColorFilterMatrix(ColorFilterType filterType) =>
    filterType.matrix;

/// Gets the display name for a filter type.
///
/// Deprecated: Use [ColorFilterType.displayName] instead.
String getFilterName(ColorFilterType filterType) => filterType.displayName;
