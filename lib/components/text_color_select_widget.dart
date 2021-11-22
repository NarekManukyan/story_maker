import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/font_colors.dart';
import '../extensions/context_extension.dart';

class TextColorSelectWidget extends StatelessWidget {
  final Duration animationsDuration;
  final PageController pageController;
  final Color selectedTextColor;
  final Function(int index) onPageChanged;
  final Function(int index) onTap;

  const TextColorSelectWidget({
    Key? key,
    required this.animationsDuration,
    required this.pageController,
    required this.selectedTextColor,
    required this.onPageChanged,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: animationsDuration,
      bottom: context.media.viewInsets.bottom + 8,
      right: 0,
      left: 0,
      child: Container(
        height: 28,
        width: context.width,
        alignment: Alignment.center,
        child: PageView.builder(
          controller: pageController,
          itemCount: defaultColors.length,
          onPageChanged: onPageChanged,
          physics: const BouncingScrollPhysics(),
          allowImplicitScrolling: true,
          pageSnapping: false,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                onTap(index);
              },
              child: Container(
                height: 28,
                width: 28,
                margin: const EdgeInsets.only(
                  right: 8,
                ),
                decoration: BoxDecoration(
                  color: defaultColors[index],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  border: Border.all(
                    color: Colors.white,
                  ),
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: animationsDuration,
                    child: defaultColors[index] == selectedTextColor
                        ? Icon(
                            CupertinoIcons.checkmark_alt,
                            color: selectedTextColor == Colors.white
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
    );
  }
}
