/// Enum representing different text animation types.
enum TextAnimationType {
  /// No animation applied.
  none,

  /// Fade in animation.
  fadeIn,

  /// Slide in from left.
  slideInLeft,

  /// Slide in from right.
  slideInRight,

  /// Slide in from top.
  slideInTop,

  /// Slide in from bottom.
  slideInBottom,

  /// Scale in animation.
  scaleIn,

  /// Bounce in animation.
  bounceIn,

  /// Rotate in animation.
  rotateIn,
}

/// Gets the display name for an animation type.
String getAnimationName(TextAnimationType animationType) {
  switch (animationType) {
    case TextAnimationType.none:
      return 'None';
    case TextAnimationType.fadeIn:
      return 'Fade';
    case TextAnimationType.slideInLeft:
      return 'Slide L';
    case TextAnimationType.slideInRight:
      return 'Slide R';
    case TextAnimationType.slideInTop:
      return 'Slide T';
    case TextAnimationType.slideInBottom:
      return 'Slide B';
    case TextAnimationType.scaleIn:
      return 'Scale';
    case TextAnimationType.bounceIn:
      return 'Bounce';
    case TextAnimationType.rotateIn:
      return 'Rotate';
  }
}

