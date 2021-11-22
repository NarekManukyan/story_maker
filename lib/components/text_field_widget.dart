import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/font_styles.dart';
import '../constants/gradients.dart';
import '../extensions/context_extension.dart';
import '../utils/gradient_util.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String val) onChanged;
  final Function(String val) onSubmit;
  final double fontSize;
  final int fontFamilyIndex;
  final Color textColor;
  final int backgroundColorIndex;

  const TextFieldWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.onSubmit,
    required this.fontSize,
    required this.fontFamilyIndex,
    required this.textColor,
    required this.backgroundColorIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 36,
      top: 0,
      bottom: 96,
      child: Center(
        child: Container(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(
            minWidth: 100,
            maxWidth: context.width - 72,
          ),
          child: Center(
            child: IntrinsicWidth(
              child: ShaderMask(
                blendMode: BlendMode.overlay,
                shaderCallback: (bounds) {
                  return createShader(
                    colors: gradientColors[backgroundColorIndex],
                    width: context.width,
                    height: context.height,
                  );
                },
                child: TextField(
                  autofocus: true,
                  controller: controller,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    fontFamilyList[fontFamilyIndex],
                  ).copyWith(
                    color: textColor,
                    fontSize: fontSize,
                  ),
                  cursorColor: textColor,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: false,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  onChanged: onChanged,
                  onSubmitted: onSubmit,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
