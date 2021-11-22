import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/font_styles.dart';
import '../extensions/context_extension.dart';

class FontFamilySelectWidget extends StatelessWidget {
  final Duration animationsDuration;
  final PageController pageController;
  final int selectedFamilyIndex;
  final Function(int index) onPageChanged;
  final Function(int index) onTap;

  const FontFamilySelectWidget({
    Key? key,
    required this.animationsDuration,
    required this.pageController,
    required this.selectedFamilyIndex,
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
        height: context.width * .1,
        width: context.width,
        alignment: Alignment.center,
        child: PageView.builder(
          controller: pageController,
          itemCount: fontFamilyList.length,
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
                height: context.width * .1,
                width: context.width * .1,
                alignment: Alignment.center,
                margin: const EdgeInsets.all(
                  2,
                ),
                decoration: BoxDecoration(
                  color: index == selectedFamilyIndex
                      ? Colors.white
                      : Colors.black.withOpacity(
                          0.4,
                        ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  border: Border.all(
                    color: Colors.white,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Aa',
                    style: GoogleFonts.getFont(
                      fontFamilyList[index],
                    ).copyWith(
                      color: index == selectedFamilyIndex
                          ? Colors.red
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
