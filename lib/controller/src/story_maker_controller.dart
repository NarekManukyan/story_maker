import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/constants.dart';
import '../../models/models.dart';

/// Manages all mutable state for the StoryMaker widget using ValueNotifiers.
///
/// Each piece of state is a separate ValueNotifier so that only the widgets
/// that depend on a particular value rebuild when it changes.
class StoryMakerController {
  StoryMakerController({
    required String filePath,
    required List<String> fontList,
    required List<Color> textColors,
    required List<List<Color>> gradients,
  })  : _fontList = fontList,
        _textColors = textColors,
        _gradients = gradients {
    _stackData.value = [
      EditableItem(type: ItemType.IMAGE, value: filePath),
    ];
    familyPageController = PageController(
      viewportFraction: ViewportFractions.fontFamily,
    );
    textColorsPageController = PageController(
      viewportFraction: ViewportFractions.textColors,
    );
    gradientsPageController = PageController(
      viewportFraction: ViewportFractions.gradients,
    );
    colorFiltersPageController = PageController(
      viewportFraction: 0.15,
      initialPage: selectedColorFilter.value.index,
    );
  }

  // ---------------------------------------------------------------------------
  // Configuration (immutable after construction)
  // ---------------------------------------------------------------------------

  final List<String> _fontList;
  final List<Color> _textColors;
  final List<List<Color>> _gradients;

  // ---------------------------------------------------------------------------
  // Canvas items
  // ---------------------------------------------------------------------------

  final ValueNotifier<List<EditableItem>> _stackData =
      ValueNotifier<List<EditableItem>>([]);

  ValueNotifier<List<EditableItem>> get stackData => _stackData;

  // ---------------------------------------------------------------------------
  // Active / gesture state
  // ---------------------------------------------------------------------------

  final ValueNotifier<EditableItem?> activeItem =
      ValueNotifier<EditableItem?>(null);

  final ValueNotifier<bool> isDeletePosition = ValueNotifier<bool>(false);

  Offset _initPos = Offset.zero;
  Offset _currentPos = Offset.zero;
  double _currentScale = 1;
  double _currentRotation = 0;
  bool _inAction = false;

  bool get inAction => _inAction;

  // ---------------------------------------------------------------------------
  // Text editing state
  // ---------------------------------------------------------------------------

  final ValueNotifier<bool> isTextInput = ValueNotifier<bool>(false);

  final ValueNotifier<Color> selectedTextColor =
      ValueNotifier<Color>(const Color(0xffffffff));

  final ValueNotifier<int> selectedTextBackgroundGradient =
      ValueNotifier<int>(0);

  final ValueNotifier<double> selectedFontSize =
      ValueNotifier<double>(FontSizeConstants.defaultValue);

  final ValueNotifier<int> selectedFontFamily = ValueNotifier<int>(0);

  final ValueNotifier<bool> isColorPickerSelected =
      ValueNotifier<bool>(false);

  String currentText = '';

  final TextEditingController editingController = TextEditingController();

  // ---------------------------------------------------------------------------
  // Picker visibility
  // ---------------------------------------------------------------------------

  final ValueNotifier<bool> isBackgroundColorPickerSelected =
      ValueNotifier<bool>(false);

  final ValueNotifier<bool> isStickerPickerSelected =
      ValueNotifier<bool>(false);

  final ValueNotifier<bool> isColorFilterPickerSelected =
      ValueNotifier<bool>(false);

  // ---------------------------------------------------------------------------
  // Filter & gradient state
  // ---------------------------------------------------------------------------

  final ValueNotifier<ColorFilterType> selectedColorFilter =
      ValueNotifier<ColorFilterType>(ColorFilterType.none);

  final ValueNotifier<int> selectedBackgroundGradient =
      ValueNotifier<int>(0);

  // ---------------------------------------------------------------------------
  // Loading
  // ---------------------------------------------------------------------------

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  // ---------------------------------------------------------------------------
  // Overlay name display (style / filter name)
  // ---------------------------------------------------------------------------

  final ValueNotifier<String?> displayedStyleName =
      ValueNotifier<String?>(null);

  final ValueNotifier<String?> displayedFilterName =
      ValueNotifier<String?>(null);

  Timer? _styleNameTimer;
  Timer? _filterNameTimer;

  // ---------------------------------------------------------------------------
  // Page controllers
  // ---------------------------------------------------------------------------

  late final PageController familyPageController;
  late final PageController textColorsPageController;
  late final PageController gradientsPageController;
  late final PageController colorFiltersPageController;

  // ---------------------------------------------------------------------------
  // Text editing actions
  // ---------------------------------------------------------------------------

  void onTextChange(String input) {
    currentText = input;
  }

  void onTextSubmit(String input) {
    if (input.isNotEmpty) {
      _submitText();
    } else {
      currentText = '';
    }
    isTextInput.value = !isTextInput.value;
    activeItem.value = null;
  }

  void _submitText() {
    final items = List<EditableItem>.from(_stackData.value)
      ..add(
        EditableItem(
          type: ItemType.TEXT,
          value: currentText,
          color: selectedTextColor.value,
          textStyle: selectedTextBackgroundGradient.value,
          fontSize: selectedFontSize.value,
          fontFamily: selectedFontFamily.value,
        ),
      );
    _stackData.value = items;
    editingController.text = '';
    currentText = '';
  }

  void onChangeTextBackground() {
    if (selectedTextBackgroundGradient.value < _gradients.length - 1) {
      selectedTextBackgroundGradient.value++;
    } else {
      selectedTextBackgroundGradient.value = 0;
    }
  }

  void onToggleTextColorSelector() {
    isColorPickerSelected.value = !isColorPickerSelected.value;
  }

  void onTextColorChange(int index) {
    HapticFeedback.lightImpact();
    selectedTextColor.value = _textColors[index];
  }

  void onFamilyChange(int index) {
    HapticFeedback.lightImpact();
    selectedFontFamily.value = index;
  }

  // ---------------------------------------------------------------------------
  // Picker toggles
  // ---------------------------------------------------------------------------

  void onToggleBackgroundGradientPicker() {
    isBackgroundColorPickerSelected.value =
        !isBackgroundColorPickerSelected.value;
    isStickerPickerSelected.value = false;
    isColorFilterPickerSelected.value = false;
  }

  void onToggleStickerPicker() {
    isStickerPickerSelected.value = !isStickerPickerSelected.value;
    isBackgroundColorPickerSelected.value = false;
    isColorFilterPickerSelected.value = false;
    isTextInput.value = false;
    activeItem.value = null;
  }

  void onToggleColorFilterPicker() {
    isColorFilterPickerSelected.value =
        !isColorFilterPickerSelected.value;
    isBackgroundColorPickerSelected.value = false;
    isStickerPickerSelected.value = false;
    isTextInput.value = false;
    activeItem.value = null;
  }

  // ---------------------------------------------------------------------------
  // Filter actions
  // ---------------------------------------------------------------------------

  void onColorFilterSelected(ColorFilterType filter) {
    HapticFeedback.lightImpact();
    _filterNameTimer?.cancel();

    selectedColorFilter.value = filter;
    isColorFilterPickerSelected.value = false;
    displayedFilterName.value = filter.displayName;

    _filterNameTimer = Timer(const Duration(seconds: 2), () {
      displayedFilterName.value = null;
    });

    if (colorFiltersPageController.hasClients) {
      colorFiltersPageController.jumpToPage(filter.index);
    }
  }

  void onHorizontalDragEnd(
    DragEndDetails details, {
    required bool hasActiveItem,
  }) {
    if (_inAction || isTextInput.value || hasActiveItem) {
      return;
    }

    final velocity = details.velocity.pixelsPerSecond.dx;
    const threshold = 300.0;

    if (velocity.abs() > threshold) {
      final filters = ColorFilterType.values;
      final currentIndex = selectedColorFilter.value.index;
      _filterNameTimer?.cancel();

      final nextIndex = velocity > 0
          ? (currentIndex + 1) % filters.length
          : (currentIndex - 1 + filters.length) % filters.length;
      final filter = filters[nextIndex];

      HapticFeedback.lightImpact();
      selectedColorFilter.value = filter;
      displayedFilterName.value = filter.displayName;

      _filterNameTimer = Timer(const Duration(seconds: 2), () {
        displayedFilterName.value = null;
      });

      if (colorFiltersPageController.hasClients) {
        colorFiltersPageController.jumpToPage(nextIndex);
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Sticker actions
  // ---------------------------------------------------------------------------

  void onStickerSelected(StickerItem sticker) {
    final items = List<EditableItem>.from(_stackData.value)
      ..add(
        EditableItem(
          type: ItemType.STICKER,
          value: sticker.value,
          fontSize: FontSizeConstants.defaultValue,
        ),
      );
    _stackData.value = items;
    isStickerPickerSelected.value = false;
  }

  // ---------------------------------------------------------------------------
  // Background gradient actions
  // ---------------------------------------------------------------------------

  void onBackgroundGradientTap(int index) {
    selectedBackgroundGradient.value = index;
    gradientsPageController.jumpToPage(index);
  }

  void onChangeBackgroundGradient(int index) {
    HapticFeedback.lightImpact();
    selectedBackgroundGradient.value = index;
  }

  // ---------------------------------------------------------------------------
  // Gesture handling
  // ---------------------------------------------------------------------------

  void onScaleStart(ScaleStartDetails details) {
    final item = activeItem.value;
    if (item == null) return;
    _initPos = details.focalPoint;
    _currentPos = item.position;
    _currentScale = item.scale;
    _currentRotation = item.rotation;
  }

  void onScaleUpdate(ScaleUpdateDetails details, Size canvasSize) {
    final item = activeItem.value;
    if (item == null) return;
    final delta = details.focalPoint - _initPos;
    final left = (delta.dx / canvasSize.width) + _currentPos.dx;
    final top = (delta.dy / canvasSize.height) + _currentPos.dy;

    final updated = item.copyWith(
      position: Offset(left, top),
      rotation: details.rotation + _currentRotation,
      scale: details.scale * _currentScale,
    );

    // Replace the item in the stack
    final items = List<EditableItem>.from(_stackData.value);
    final idx = items.indexOf(item);
    if (idx != -1) {
      items[idx] = updated;
      _stackData.value = items;
    }
    activeItem.value = updated;
  }

  // ---------------------------------------------------------------------------
  // Screen tap
  // ---------------------------------------------------------------------------

  void onScreenTap() {
    isTextInput.value = !isTextInput.value;
    activeItem.value = null;
    isBackgroundColorPickerSelected.value = false;
    isStickerPickerSelected.value = false;

    if (currentText.isNotEmpty) {
      _submitText();
    }

    familyPageController.dispose();
    textColorsPageController.dispose();
    familyPageController = PageController(
      initialPage: selectedFontFamily.value,
      viewportFraction: ViewportFractions.fontFamily,
    );
    textColorsPageController = PageController(
      initialPage: _textColors.indexWhere(
        (element) => element == selectedTextColor.value,
      ),
      viewportFraction: ViewportFractions.textColors,
    );
  }

  // ---------------------------------------------------------------------------
  // Style / font change with overlay
  // ---------------------------------------------------------------------------

  void onStyleChange(int index) {
    HapticFeedback.lightImpact();
    _styleNameTimer?.cancel();

    selectedFontFamily.value = index;
    displayedStyleName.value = _fontList[index];

    _styleNameTimer = Timer(const Duration(seconds: 2), () {
      displayedStyleName.value = null;
    });

    if (familyPageController.hasClients) {
      familyPageController.jumpToPage(index);
    }
  }

  void onColorChange(int index) {
    HapticFeedback.lightImpact();
    selectedTextColor.value = _textColors[index];
    textColorsPageController.jumpToPage(index);
  }

  // ---------------------------------------------------------------------------
  // Overlay item interaction
  // ---------------------------------------------------------------------------

  void onOverlayItemTap(EditableItem e) {
    isTextInput.value = !isTextInput.value;
    activeItem.value = null;
    editingController.text = e.value;
    currentText = e.value;
    selectedFontFamily.value = e.fontFamily;
    selectedFontSize.value = e.fontSize;
    selectedTextBackgroundGradient.value = e.textStyle;
    selectedTextColor.value = e.color;

    final items = List<EditableItem>.from(_stackData.value)..remove(e);
    _stackData.value = items;

    familyPageController.dispose();
    textColorsPageController.dispose();
    familyPageController = PageController(
      initialPage: e.fontFamily,
      viewportFraction: ViewportFractions.fontFamily,
    );
    textColorsPageController = PageController(
      initialPage: _textColors.indexWhere(
        (element) => element == e.color,
      ),
      viewportFraction: ViewportFractions.textColors,
    );
  }

  void onOverlayItemPointerDown(EditableItem e, PointerDownEvent details) {
    if (e.type != ItemType.IMAGE) {
      if (_inAction) return;
      _inAction = true;
      activeItem.value = e;
      _initPos = details.position;
      _currentPos = e.position;
      _currentScale = e.scale;
      _currentRotation = e.rotation;
    }
  }

  void onOverlayItemPointerUp(EditableItem e, PointerUpEvent details) {
    _inAction = false;
    if (e.position.dy >= PositionConstants.deletePositionThreshold &&
        e.position.dx >= 0.0 &&
        e.position.dx <= 1.0) {
      final items = List<EditableItem>.from(_stackData.value)..remove(e);
      _stackData.value = items;
      activeItem.value = null;
    } else {
      activeItem.value = null;
    }
    isDeletePosition.value = false;
  }

  void onOverlayItemPointerMove(EditableItem e, PointerMoveEvent details) {
    final inDeleteZone = e.position.dy >=
            PositionConstants.deletePositionThreshold &&
        e.position.dx >= 0.0 &&
        e.position.dx <= 1.0;
    if (isDeletePosition.value != inDeleteZone) {
      isDeletePosition.value = inDeleteZone;
    }
  }

  // ---------------------------------------------------------------------------
  // Disposal
  // ---------------------------------------------------------------------------

  void dispose() {
    editingController.dispose();
    familyPageController.dispose();
    textColorsPageController.dispose();
    gradientsPageController.dispose();
    colorFiltersPageController.dispose();
    _styleNameTimer?.cancel();
    _filterNameTimer?.cancel();

    // Dispose all ValueNotifiers
    _stackData.dispose();
    activeItem.dispose();
    isDeletePosition.dispose();
    isTextInput.dispose();
    selectedTextColor.dispose();
    selectedTextBackgroundGradient.dispose();
    selectedFontSize.dispose();
    selectedFontFamily.dispose();
    isColorPickerSelected.dispose();
    isBackgroundColorPickerSelected.dispose();
    isStickerPickerSelected.dispose();
    isColorFilterPickerSelected.dispose();
    selectedColorFilter.dispose();
    selectedBackgroundGradient.dispose();
    isLoading.dispose();
    displayedStyleName.dispose();
    displayedFilterName.dispose();
  }
}
