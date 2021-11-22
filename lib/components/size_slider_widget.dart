import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../extensions/context_extension.dart';

class SizeSliderWidget extends StatelessWidget {
  final Duration animationsDuration;
  final double selectedValue;
  final Function(double value) onChanged;

  const SizeSliderWidget({
    Key? key,
    required this.animationsDuration,
    required this.onChanged,
    required this.selectedValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: animationsDuration,
      top: context.height * .5 - 162,
      left: -100,
      child: Transform(
        alignment: FractionalOffset.center,
        // Rotate sliders by 90 degrees
        transform: Matrix4.identity()..rotateZ(270 * 3.1415927 / 180),
        child: SizedBox(
          width: 248,
          child: Slider(
            value: selectedValue,
            min: 14,
            max: 74,
            activeColor: Colors.white,
            inactiveColor: Colors.white.withOpacity(0.4),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
