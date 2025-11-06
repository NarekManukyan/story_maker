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
  dark,
}

/// Color filter matrix for sepia effect.
const List<double> sepiaMatrix = [
  0.393, 0.769, 0.189, 0, 0,
  0.349, 0.686, 0.168, 0, 0,
  0.272, 0.534, 0.131, 0, 0,
  0, 0, 0, 1, 0,
];

/// Color filter matrix for grayscale effect.
const List<double> grayscaleMatrix = [
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0, 0, 0, 1, 0,
];

/// Color filter matrix for vintage effect.
const List<double> vintageMatrix = [
  0.9, 0.5, 0.1, 0, 0,
  0.3, 0.8, 0.1, 0, 0,
  0.2, 0.3, 0.5, 0, 0,
  0, 0, 0, 1, 0,
];

/// Color filter matrix for cool effect (blue tint).
const List<double> coolMatrix = [
  1, 0, 0, 0, 0,
  0, 1, 0.1, 0, 0,
  0, 0.1, 1, 0, 0,
  0, 0, 0, 1, 0,
];

/// Color filter matrix for warm effect (orange/red tint).
const List<double> warmMatrix = [
  1, 0.1, 0, 0, 0,
  0, 1, 0, 0, 0,
  0, 0, 0.9, 0, 0,
  0, 0, 0, 1, 0,
];

/// Color filter matrix for bright effect.
const List<double> brightMatrix = [
  1.2, 0, 0, 0, 0,
  0, 1.2, 0, 0, 0,
  0, 0, 1.2, 0, 0,
  0, 0, 0, 1, 0,
];

/// Color filter matrix for dark effect.
const List<double> darkMatrix = [
  0.7, 0, 0, 0, 0,
  0, 0.7, 0, 0, 0,
  0, 0, 0.7, 0, 0,
  0, 0, 0, 1, 0,
];

/// Gets the color filter matrix for a given filter type.
List<double> getColorFilterMatrix(ColorFilterType filterType) {
  switch (filterType) {
    case ColorFilterType.sepia:
      return sepiaMatrix;
    case ColorFilterType.grayscale:
      return grayscaleMatrix;
    case ColorFilterType.vintage:
      return vintageMatrix;
    case ColorFilterType.cool:
      return coolMatrix;
    case ColorFilterType.warm:
      return warmMatrix;
    case ColorFilterType.bright:
      return brightMatrix;
    case ColorFilterType.dark:
      return darkMatrix;
    case ColorFilterType.none:
      return [
        1, 0, 0, 0, 0,
        0, 1, 0, 0, 0,
        0, 0, 1, 0, 0,
        0, 0, 0, 1, 0,
      ];
  }
}

/// Gets the display name for a filter type.
String getFilterName(ColorFilterType filterType) {
  switch (filterType) {
    case ColorFilterType.none:
      return 'None';
    case ColorFilterType.sepia:
      return 'Sepia';
    case ColorFilterType.grayscale:
      return 'Grayscale';
    case ColorFilterType.vintage:
      return 'Vintage';
    case ColorFilterType.cool:
      return 'Cool';
    case ColorFilterType.warm:
      return 'Warm';
    case ColorFilterType.bright:
      return 'Bright';
    case ColorFilterType.dark:
      return 'Dark';
  }
}

