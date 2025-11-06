import 'package:flutter/material.dart';

import '../constants/text_animations.dart';

/// Creates an animated widget based on the animation type.
///
/// This function wraps a child widget with the appropriate animation
/// based on the provided [animationType] and [duration].
Widget createAnimatedText({
  required Widget child,
  required TextAnimationType animationType,
  required Duration duration,
}) {
  switch (animationType) {
    case TextAnimationType.none:
      return child;
    case TextAnimationType.fadeIn:
      return FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: AlwaysStoppedAnimation(1.0),
            curve: Curves.easeIn,
          ),
        ),
        child: child,
      );
    case TextAnimationType.slideInLeft:
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1.0, 0.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: AlwaysStoppedAnimation(1.0),
            curve: Curves.easeOut,
          ),
        ),
        child: child,
      );
    case TextAnimationType.slideInRight:
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: AlwaysStoppedAnimation(1.0),
            curve: Curves.easeOut,
          ),
        ),
        child: child,
      );
    case TextAnimationType.slideInTop:
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, -1.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: AlwaysStoppedAnimation(1.0),
            curve: Curves.easeOut,
          ),
        ),
        child: child,
      );
    case TextAnimationType.slideInBottom:
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: AlwaysStoppedAnimation(1.0),
            curve: Curves.easeOut,
          ),
        ),
        child: child,
      );
    case TextAnimationType.scaleIn:
      return ScaleTransition(
        scale: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: AlwaysStoppedAnimation(1.0),
            curve: Curves.easeOut,
          ),
        ),
        child: child,
      );
    case TextAnimationType.bounceIn:
      return ScaleTransition(
        scale: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: AlwaysStoppedAnimation(1.0),
            curve: Curves.elasticOut,
          ),
        ),
        child: child,
      );
    case TextAnimationType.rotateIn:
      return RotationTransition(
        turns: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: AlwaysStoppedAnimation(1.0),
            curve: Curves.easeOut,
          ),
        ),
        child: child,
      );
  }
}

