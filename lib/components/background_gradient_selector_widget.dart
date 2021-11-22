import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../constants/gradients.dart';
import '../extensions/context_extension.dart';

class BackgroundGradientSelectorWidget extends StatelessWidget {
  final bool isTextInput;
  final bool isBackgroundColorPickerSelected;
  final Duration animationsDuration;
  final Function(int item) onPageChanged;
  final Function(int item) onItemTap;
  final bool inAction;
  final PageController gradientsPageController;
  final int selectedGradientIndex;

  bool get isVisible =>
      isBackgroundColorPickerSelected && !isTextInput && !inAction;

  const BackgroundGradientSelectorWidget({
    Key? key,
    required this.isTextInput,
    required this.isBackgroundColorPickerSelected,
    required this.inAction,
    required this.animationsDuration,
    required this.gradientsPageController,
    required this.onPageChanged,
    required this.onItemTap,
    required this.selectedGradientIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          child: PageView.builder(
            controller: gradientsPageController,
            itemCount: gradientColors.length,
            onPageChanged: onPageChanged,
            physics: const BouncingScrollPhysics(),
            allowImplicitScrolling: true,
            pageSnapping: false,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => onItemTap(index),
                child: Container(
                  height: context.width * .175,
                  width: context.width * .175,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: FractionalOffset.topLeft,
                      end: FractionalOffset.centerRight,
                      colors: gradientColors[index],
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(context.width * .175),
                    ),
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: animationsDuration,
                      child: index == selectedGradientIndex
                          ? Icon(
                              CupertinoIcons.checkmark_alt,
                              color: selectedGradientIndex == 0
                                  ? Colors.white
                                  : gradientColors[selectedGradientIndex]
                                              .last
                                              .computeLuminance() >
                                          0.5
                                      ? Colors.black
                                      : Colors.white,
                            )
                          : const SizedBox(),
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
