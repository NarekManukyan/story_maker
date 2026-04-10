/// A library for creating and editing stories.
///
/// This library provides widgets and utilities for creating and editing
/// stories, including text editing, image manipulation, and more.
library story_maker;

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

import 'components/components.dart';
import 'constants/constants.dart';
import 'controller/controller.dart';
import 'extensions/extensions.dart';
import 'models/models.dart';
import 'theme/theme.dart';

export 'components/components.dart';
export 'constants/constants.dart';
export 'controller/controller.dart';
export 'extensions/extensions.dart';
export 'models/models.dart';
export 'theme/theme.dart';

class StoryMaker extends StatefulWidget {
  const StoryMaker({
    super.key,
    required this.filePath,
    this.animationsDuration = const Duration(milliseconds: 300),
    this.doneButtonChild,
    this.customFontList,
    this.customTextColors,
    this.customGradients,
    this.customStickers,
    this.theme,
    this.doneButtonBuilder,
  });

  final String filePath;
  final Duration animationsDuration;
  final Widget? doneButtonChild;
  final List<String>? customFontList;
  final List<Color>? customTextColors;
  final List<List<Color>>? customGradients;
  final List<StickerItem>? customStickers;
  final StoryMakerTheme? theme;

  /// Custom widget builder for the done button.
  /// If provided, this will be used instead of the default "Add to story" button.
  /// The builder receives the theme and onDone callback.
  final Widget Function(
    StoryMakerTheme theme,
    AsyncCallback onDone,
    bool isLoading,
  )? doneButtonBuilder;

  @override
  _StoryMakerState createState() => _StoryMakerState();
}

class _StoryMakerState extends State<StoryMaker> {
  final GlobalKey _previewContainer = GlobalKey();

  late final StoryMakerController _ctrl;

  /// Gets the font list to use (custom or default).
  List<String> get _fontList => widget.customFontList ?? fontFamilyList;

  /// Gets the text colors list to use (custom or default).
  List<Color> get _textColors => widget.customTextColors ?? defaultColors;

  /// Gets the gradients list to use (custom or default).
  List<List<Color>> get _gradients => widget.customGradients ?? gradientColors;

  /// Gets the stickers list to use (custom or default).
  List<StickerItem> get _stickers {
    if (widget.customStickers != null) {
      return widget.customStickers!;
    }
    return defaultStickers.map(StickerItem.emoji).toList();
  }

  /// Gets the theme to use (custom or default).
  StoryMakerTheme get _theme => widget.theme ?? StoryMakerTheme.defaultTheme();

  @override
  void initState() {
    super.initState();
    _ctrl = StoryMakerController(
      filePath: widget.filePath,
      fontList: _fontList,
      textColors: _textColors,
      gradients: _gradients,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextHeightBehavior(
      textHeightBehavior: const TextHeightBehavior(
        leadingDistribution: TextLeadingDistribution.even,
      ),
      child: StoryMakerThemeProvider(
        theme: _theme,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: _theme.backgroundColor,
          body: Stack(
            clipBehavior: Clip.antiAlias,
            children: [
              _buildCanvasArea(),
              _buildTextInputSelectors(),
              _buildBackgroundGradientSelector(),
              _buildTopTools(),
              _buildStickerSelector(),
              _buildRemoveWidget(),
              _buildFooter(),
              _buildStyleNameOverlay(),
              _buildFilterNameOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Canvas area — image + overlay items + text input
  // ---------------------------------------------------------------------------

  Widget _buildCanvasArea() {
    return Positioned(
      top: context.topPadding,
      left: 0,
      right: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_theme.safeAreaBorderRadius),
        child: AspectRatio(
          aspectRatio: StoryConstants.aspectRatio,
          child: GestureDetector(
            onScaleStart: _ctrl.onScaleStart,
            onScaleUpdate: (details) {
              _ctrl.onScaleUpdate(
                details,
                Size(context.width, context.height),
              );
            },
            onTap: _ctrl.onScreenTap,
            onHorizontalDragEnd: (details) {
              _ctrl.onHorizontalDragEnd(
                details,
                hasActiveItem: _ctrl.activeItem.value != null,
              );
            },
            child: Stack(
              children: [
                RepaintBoundary(
                  key: _previewContainer,
                  child: ValueListenableBuilder<List<EditableItem>>(
                    valueListenable: _ctrl.stackData,
                    builder: (context, items, _) {
                      return ValueListenableBuilder<ColorFilterType>(
                        valueListenable: _ctrl.selectedColorFilter,
                        builder: (context, filter, _) {
                          return ValueListenableBuilder<int>(
                            valueListenable:
                                _ctrl.selectedBackgroundGradient,
                            builder: (context, bgGradient, _) {
                              return Stack(
                                children: [
                                  _buildImageLayer(
                                    items,
                                    filter,
                                    bgGradient,
                                  ),
                                  ...items.map(
                                    (item) => OverlayItemWidget(
                                      key: ValueKey<int>(item.hashCode),
                                      editableItem: item,
                                      onItemTap: () =>
                                          _ctrl.onOverlayItemTap(item),
                                      onPointerDown: (details) =>
                                          _ctrl.onOverlayItemPointerDown(
                                        item,
                                        details,
                                      ),
                                      onPointerUp: (details) =>
                                          _ctrl.onOverlayItemPointerUp(
                                        item,
                                        details,
                                      ),
                                      onPointerMove: (details) =>
                                          _ctrl.onOverlayItemPointerMove(
                                        item,
                                        details,
                                      ),
                                      fontList: _fontList,
                                      gradients: _gradients,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                _buildTextInputOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageLayer(
    List<EditableItem> items,
    ColorFilterType filter,
    int bgGradient,
  ) {
    if (items.isEmpty || items[0].type != ItemType.IMAGE) {
      return const SizedBox();
    }
    return Center(
      child: ColorFiltered(
        colorFilter: ColorFilter.matrix(filter.matrix),
        child: PhotoView(
          enableRotation: true,
          backgroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.centerRight,
              colors: _gradients[bgGradient],
            ),
          ),
          maxScale: 2.0,
          enablePanAlways: false,
          imageProvider: FileImage(File(items[0].value)),
        ),
      ),
    );
  }

  Widget _buildTextInputOverlay() {
    return ValueListenableBuilder<bool>(
      valueListenable: _ctrl.isTextInput,
      builder: (context, textInput, _) {
        return AnimatedSwitcher(
          duration: widget.animationsDuration,
          child: !textInput
              ? const SizedBox()
              : Container(
                  height: context.height,
                  width: context.width,
                  color: Colors.black.withValues(alpha: 0.4),
                  child: Stack(
                    children: [
                      ValueListenableBuilder<double>(
                        valueListenable: _ctrl.selectedFontSize,
                        builder: (context, fontSize, _) {
                          return ValueListenableBuilder<int>(
                            valueListenable: _ctrl.selectedFontFamily,
                            builder: (context, fontFamily, _) {
                              return ValueListenableBuilder<Color>(
                                valueListenable: _ctrl.selectedTextColor,
                                builder: (context, textColor, _) {
                                  return ValueListenableBuilder<int>(
                                    valueListenable: _ctrl
                                        .selectedTextBackgroundGradient,
                                    builder: (context, bgGradient, _) {
                                      return TextFieldWidget(
                                        controller: _ctrl.editingController,
                                        onChanged: _ctrl.onTextChange,
                                        onSubmit: _ctrl.onTextSubmit,
                                        fontSize: fontSize,
                                        fontFamilyIndex: fontFamily,
                                        textColor: textColor,
                                        backgroundColorIndex: bgGradient,
                                        fontList: _fontList,
                                        gradients: _gradients,
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                      ValueListenableBuilder<double>(
                        valueListenable: _ctrl.selectedFontSize,
                        builder: (context, fontSize, _) {
                          return SizeSliderWidget(
                            animationsDuration: widget.animationsDuration,
                            selectedValue: fontSize,
                            onChanged: (input) {
                              _ctrl.selectedFontSize.value = input;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Text input selectors (font family / text color)
  // ---------------------------------------------------------------------------

  Widget _buildTextInputSelectors() {
    return ValueListenableBuilder<bool>(
      valueListenable: _ctrl.isTextInput,
      builder: (context, textInput, _) {
        if (!textInput) return const SizedBox();
        return ValueListenableBuilder<bool>(
          valueListenable: _ctrl.isColorPickerSelected,
          builder: (context, colorPicker, _) {
            if (!colorPicker) {
              return ValueListenableBuilder<int>(
                valueListenable: _ctrl.selectedFontFamily,
                builder: (context, familyIndex, _) {
                  return FontFamilySelectWidget(
                    animationsDuration: widget.animationsDuration,
                    pageController: _ctrl.familyPageController,
                    selectedFamilyIndex: familyIndex,
                    onPageChanged: _ctrl.onFamilyChange,
                    onTap: _ctrl.onStyleChange,
                    fontList: _fontList,
                  );
                },
              );
            }
            return ValueListenableBuilder<Color>(
              valueListenable: _ctrl.selectedTextColor,
              builder: (context, textColor, _) {
                return TextColorSelectWidget(
                  animationsDuration: widget.animationsDuration,
                  pageController: _ctrl.textColorsPageController,
                  selectedTextColor: textColor,
                  onPageChanged: _ctrl.onTextColorChange,
                  onTap: _ctrl.onColorChange,
                  textColors: _textColors,
                );
              },
            );
          },
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Background gradient selector
  // ---------------------------------------------------------------------------

  Widget _buildBackgroundGradientSelector() {
    return ValueListenableBuilder<bool>(
      valueListenable: _ctrl.isTextInput,
      builder: (context, textInput, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: _ctrl.isBackgroundColorPickerSelected,
          builder: (context, bgPickerSelected, _) {
            return ValueListenableBuilder<int>(
              valueListenable: _ctrl.selectedBackgroundGradient,
              builder: (context, gradientIndex, _) {
                return BackgroundGradientSelectorWidget(
                  isTextInput: textInput,
                  isBackgroundColorPickerSelected: bgPickerSelected,
                  inAction: _ctrl.inAction,
                  animationsDuration: widget.animationsDuration,
                  gradientsPageController: _ctrl.gradientsPageController,
                  onPageChanged: _ctrl.onChangeBackgroundGradient,
                  onItemTap: _ctrl.onBackgroundGradientTap,
                  selectedGradientIndex: gradientIndex,
                  gradients: _gradients,
                );
              },
            );
          },
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Top tools
  // ---------------------------------------------------------------------------

  Widget _buildTopTools() {
    return ValueListenableBuilder<bool>(
      valueListenable: _ctrl.isTextInput,
      builder: (context, textInput, _) {
        return ValueListenableBuilder<int>(
          valueListenable: _ctrl.selectedBackgroundGradient,
          builder: (context, bgGradient, _) {
            return ValueListenableBuilder<int>(
              valueListenable: _ctrl.selectedTextBackgroundGradient,
              builder: (context, textBgGradient, _) {
                return ValueListenableBuilder<EditableItem?>(
                  valueListenable: _ctrl.activeItem,
                  builder: (context, active, _) {
                    return TopToolsWidget(
                      isTextInput: textInput,
                      selectedBackgroundGradientIndex: bgGradient,
                      animationsDuration: widget.animationsDuration,
                      onPickerTap: _ctrl.onToggleBackgroundGradientPicker,
                      onScreenTap: _ctrl.onScreenTap,
                      selectedTextBackgroundGradientIndex: textBgGradient,
                      onToggleTextColorPicker:
                          _ctrl.onToggleTextColorSelector,
                      onChangeTextBackground:
                          _ctrl.onChangeTextBackground,
                      gradients: _gradients,
                      activeItem: active,
                      onStickerTap: _ctrl.onToggleStickerPicker,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Sticker selector
  // ---------------------------------------------------------------------------

  Widget _buildStickerSelector() {
    return ValueListenableBuilder<bool>(
      valueListenable: _ctrl.isStickerPickerSelected,
      builder: (context, stickerPicker, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: _ctrl.isTextInput,
          builder: (context, textInput, _) {
            return StickerSelectorWidget(
              stickers: _stickers,
              animationsDuration: widget.animationsDuration,
              onStickerTap: _ctrl.onStickerSelected,
              isVisible: stickerPicker && !textInput && !_ctrl.inAction,
            );
          },
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Remove widget
  // ---------------------------------------------------------------------------

  Widget _buildRemoveWidget() {
    return ValueListenableBuilder<bool>(
      valueListenable: _ctrl.isTextInput,
      builder: (context, textInput, _) {
        return ValueListenableBuilder<EditableItem?>(
          valueListenable: _ctrl.activeItem,
          builder: (context, active, _) {
            return ValueListenableBuilder<bool>(
              valueListenable: _ctrl.isDeletePosition,
              builder: (context, deletePos, _) {
                return RemoveWidget(
                  isTextInput: textInput,
                  animationsDuration: widget.animationsDuration,
                  activeItem: active,
                  isDeletePosition: deletePos,
                );
              },
            );
          },
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Footer
  // ---------------------------------------------------------------------------

  Widget _buildFooter() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ValueListenableBuilder<bool>(
        valueListenable: _ctrl.isLoading,
        builder: (context, loading, _) {
          return FooterToolsWidget(
            onDone: _onDone,
            doneButtonChild: widget.doneButtonChild,
            isLoading: loading,
            doneButtonBuilder: widget.doneButtonBuilder,
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Overlay name displays
  // ---------------------------------------------------------------------------

  Widget _buildStyleNameOverlay() {
    return ValueListenableBuilder<String?>(
      valueListenable: _ctrl.displayedStyleName,
      builder: (context, styleName, _) {
        if (styleName == null) return const SizedBox();
        return _buildNameOverlay(
          name: styleName,
          fontSize: 18,
        );
      },
    );
  }

  Widget _buildFilterNameOverlay() {
    return ValueListenableBuilder<String?>(
      valueListenable: _ctrl.displayedFilterName,
      builder: (context, filterName, _) {
        if (filterName == null) return const SizedBox();
        return _buildNameOverlay(
          name: filterName,
          fontSize: 24,
          bottomMargin: context.bottomPadding,
        );
      },
    );
  }

  Widget _buildNameOverlay({
    required String name,
    required double fontSize,
    double bottomMargin = 0,
  }) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            margin: EdgeInsets.only(bottom: bottomMargin),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Done action (image export) — needs BuildContext and mounted check
  // ---------------------------------------------------------------------------

  Future<void> _onDone() async {
    final boundary = _previewContainer.currentContext!.findRenderObject()
        as RenderRepaintBoundary?;
    _ctrl.isLoading.value = true;
    final image = await boundary!.toImage(pixelRatio: 3);
    final directory = (await getApplicationDocumentsDirectory()).path;
    final byteData = (await image.toByteData(format: ui.ImageByteFormat.png))!;
    final pngBytes = byteData.buffer.asUint8List();
    final imgFile = File('$directory/${DateTime.now()}.png');
    await imgFile.writeAsBytes(pngBytes);
    _ctrl.isLoading.value = false;
    if (mounted) {
      Navigator.of(context).pop(imgFile);
    }
  }
}
