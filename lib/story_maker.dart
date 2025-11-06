/// A library for creating and editing stories.
///
/// This library provides widgets and utilities for creating and editing
/// stories, including text editing, image manipulation, and more.
library story_maker;

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

import 'components/background_gradient_selector_widget.dart';
import 'components/font_family_select_widget.dart';
import 'components/footer_tools_widget.dart';
import 'components/overlay_item_widget.dart';
import 'components/remove_widget.dart';
import 'components/size_slider_widget.dart';
import 'components/sticker_selector_widget.dart';
import 'components/text_color_select_widget.dart';
import 'components/text_field_widget.dart';
import 'components/top_tools_widget.dart';
import 'constants/color_filters.dart';
import 'constants/font_colors.dart';
import 'constants/font_styles.dart';
import 'constants/gradients.dart';
import 'constants/item_type.dart';
import 'constants/stickers.dart';
import 'constants/ui_constants.dart';
import 'extensions/context_extension.dart';
import 'models/editable_items.dart';
import 'models/sticker_item.dart';
import 'theme/story_maker_theme.dart';
import 'theme/story_maker_theme_provider.dart';

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
// A global key used to get the context of the widget tree.
  GlobalKey previewContainer = GlobalKey();

// The currently active editable item.
  EditableItem? _activeItem;

// The initial position of the active item.
  Offset _initPos = Offset.zero;

// The current position of the active item.
  Offset _currentPos = Offset.zero;

// The current scale of the active item.
  double _currentScale = 1;

// The current rotation of the active item.
  double _currentRotation = 0;

// Indicates whether the widget is in action.
  bool _inAction = false;

// Indicates whether the widget is in text input mode.
  bool _isTextInput = false;

// The current text in the text input field.
  String _currentText = '';

// The currently selected text color.
  Color _selectedTextColor = const Color(0xffffffff);

// The index of the currently selected text background gradient.
  int _selectedTextBackgroundGradient = 0;

// The index of the currently selected background gradient.
  int _selectedBackgroundGradient = 0;

// The currently selected font size.
  double _selectedFontSize = FontSizeConstants.defaultValue;

// The index of the currently selected font family.
  int _selectedFontFamily = 0;

// Indicates whether the widget is in delete position.
  bool _isDeletePosition = false;

// Indicates whether the color picker is selected.
  bool _isColorPickerSelected = false;

// Indicates whether the background color picker is selected.
  bool _isBackgroundColorPickerSelected = false;

// Indicates whether the sticker picker is selected.
  bool _isStickerPickerSelected = false;

// Indicates whether the color filter picker is selected.
  bool _isColorFilterPickerSelected = false;

// The currently selected color filter.
  ColorFilterType _selectedColorFilter = ColorFilterType.none;

// Indicates whether the widget is in loading state.
  bool _isLoading = false;

// The currently displayed style name (for showing style name overlay).
  String? _displayedStyleName;

// Timer for hiding the style name overlay.
  Timer? _styleNameTimer;

// The currently displayed filter name (for showing filter name overlay).
  String? _displayedFilterName;

// Timer for hiding the filter name overlay.
  Timer? _filterNameTimer;

// The controller for the font family PageView.
  late PageController _familyPageController;

// The controller for the text colors PageView.
  late PageController _textColorsPageController;

// The controller for the gradients PageView.
  late PageController _gradientsPageController;

// The controller for the color filters PageView.
  late PageController _colorFiltersPageController;

// The controller for the text editing field.
  final _editingController = TextEditingController();

// The stack data for the editable items.
  final _stackData = <EditableItem>[];

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
    // Convert default emoji strings to StickerItem.emoji
    return defaultStickers.map((emoji) => StickerItem.emoji(emoji)).toList();
  }

  /// Gets the theme to use (custom or default).
  StoryMakerTheme get _theme => widget.theme ?? StoryMakerTheme.defaultTheme();

  @override

  /// Called when this object is inserted into the tree.
  ///
  /// The framework will call this method exactly once for each [State] object it creates.
  /// This method is where you should put any expensive computations, network calls, initializations, or subscriptions.
  /// In this case, it calls the [_init] method to initialize the state of the widget.
  void initState() {
    super.initState();
    _init();
  }

  @override

  /// Called when this object is removed from the tree permanently.
  ///
  /// The framework calls this method when this [State] object will never build again.
  /// This method is where you should unsubscribe or dispose any resources, streams, or animations that were created in [initState].
  void dispose() {
    _editingController.dispose();
    _familyPageController.dispose();
    _textColorsPageController.dispose();
    _gradientsPageController.dispose();
    _colorFiltersPageController.dispose();
    _styleNameTimer?.cancel();
    _filterNameTimer?.cancel();
    super.dispose();
  }

  /// Initializes the state of the widget.
  ///
  /// This method is called in [initState] to set up the initial state of the widget.
  /// It initializes the [_stackData] with an [EditableItem] of type [ItemType.IMAGE] and the value of [widget.filePath].
  /// It also initializes the [_familyPageController], [_textColorsPageController], and [_gradientsPageController] with their respective viewport fractions.
  void _init() {
    _stackData.add(
      EditableItem()
        ..type = ItemType.IMAGE
        ..value = widget.filePath,
    );
    _familyPageController = PageController(
      viewportFraction: ViewportFractions.fontFamily,
    );
    _textColorsPageController = PageController(
      viewportFraction: ViewportFractions.textColors,
    );
    _gradientsPageController = PageController(
      viewportFraction: ViewportFractions.gradients,
    );
    _colorFiltersPageController = PageController(
      viewportFraction: 0.15,
      initialPage: _selectedColorFilter.index,
    );
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
              Positioned(
                top: context.topPadding,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(_theme.safeAreaBorderRadius),
                  child: AspectRatio(
                    aspectRatio: StoryConstants.aspectRatio,
                    child: GestureDetector(
                      onScaleStart: _onScaleStart,
                      onScaleUpdate: _onScaleUpdate,
                      onTap: _onScreenTap,
                      onHorizontalDragEnd: _onHorizontalDragEnd,
                      child: Stack(
                        children: [
                          RepaintBoundary(
                            key: previewContainer,
                            child: Stack(
                              children: [
                                Visibility(
                                  visible: _stackData[0].type == ItemType.IMAGE,
                                  child: Center(
                                    child: ColorFiltered(
                                      colorFilter: ColorFilter.matrix(
                                        getColorFilterMatrix(
                                          _selectedColorFilter,
                                        ),
                                      ),
                                      child: PhotoView(
                                        enableRotation: true,
                                        backgroundDecoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: FractionalOffset.topLeft,
                                            end: FractionalOffset.centerRight,
                                            colors: _gradients[
                                                _selectedBackgroundGradient],
                                          ),
                                        ),
                                        maxScale: 2.0,
                                        enablePanAlways: false,
                                        imageProvider: FileImage(
                                          File(_stackData[0].value),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ..._stackData.map(
                                  (editableItem) => OverlayItemWidget(
                                    editableItem: editableItem,
                                    onItemTap: () {
                                      _onOverlayItemTap(editableItem);
                                    },
                                    onPointerDown: (details) {
                                      _onOverlayItemPointerDown(
                                        editableItem,
                                        details,
                                      );
                                    },
                                    onPointerUp: (details) {
                                      _onOverlayItemPointerUp(
                                        editableItem,
                                        details,
                                      );
                                    },
                                    onPointerMove: (details) {
                                      _onOverlayItemPointerMove(
                                        editableItem,
                                        details,
                                      );
                                    },
                                    fontList: _fontList,
                                    gradients: _gradients,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: widget.animationsDuration,
                            child: !_isTextInput
                                ? const SizedBox()
                                : Container(
                                    height: context.height,
                                    width: context.width,
                                    color: Colors.black.withOpacity(0.4),
                                    child: Stack(
                                      children: [
                                        TextFieldWidget(
                                          controller: _editingController,
                                          onChanged: _onTextChange,
                                          onSubmit: _onTextSubmit,
                                          fontSize: _selectedFontSize,
                                          fontFamilyIndex: _selectedFontFamily,
                                          textColor: _selectedTextColor,
                                          backgroundColorIndex:
                                              _selectedTextBackgroundGradient,
                                          fontList: _fontList,
                                          gradients: _gradients,
                                        ),
                                        SizeSliderWidget(
                                          animationsDuration:
                                              widget.animationsDuration,
                                          selectedValue: _selectedFontSize,
                                          onChanged: (input) {
                                            setState(
                                              () {
                                                _selectedFontSize = input;
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (_isTextInput)
                if (!_isColorPickerSelected)
                  FontFamilySelectWidget(
                    animationsDuration: widget.animationsDuration,
                    pageController: _familyPageController,
                    selectedFamilyIndex: _selectedFontFamily,
                    onPageChanged: _onFamilyChange,
                    onTap: (index) {
                      _onStyleChange(index);
                    },
                    fontList: _fontList,
                  )
                else
                  TextColorSelectWidget(
                    animationsDuration: widget.animationsDuration,
                    pageController: _textColorsPageController,
                    selectedTextColor: _selectedTextColor,
                    onPageChanged: _onTextColorChange,
                    onTap: (index) {
                      _onColorChange(index);
                    },
                    textColors: _textColors,
                  ),
              BackgroundGradientSelectorWidget(
                isTextInput: _isTextInput,
                isBackgroundColorPickerSelected:
                    _isBackgroundColorPickerSelected,
                inAction: _inAction,
                animationsDuration: widget.animationsDuration,
                gradientsPageController: _gradientsPageController,
                onPageChanged: _onChangeBackgroundGradient,
                onItemTap: _onBackgroundGradientTap,
                selectedGradientIndex: _selectedBackgroundGradient,
                gradients: _gradients,
              ),
              TopToolsWidget(
                isTextInput: _isTextInput,
                selectedBackgroundGradientIndex: _selectedBackgroundGradient,
                animationsDuration: widget.animationsDuration,
                onPickerTap: _onToggleBackgroundGradientPicker,
                onScreenTap: _onScreenTap,
                selectedTextBackgroundGradientIndex:
                    _selectedTextBackgroundGradient,
                onToggleTextColorPicker: _onToggleTextColorSelector,
                onChangeTextBackground: _onChangeTextBackground,
                gradients: _gradients,
                activeItem: _activeItem,
                onStickerTap: _onToggleStickerPicker,
              ),
              StickerSelectorWidget(
                stickers: _stickers,
                animationsDuration: widget.animationsDuration,
                onStickerTap: _onStickerSelected,
                isVisible:
                    _isStickerPickerSelected && !_isTextInput && !_inAction,
              ),
              RemoveWidget(
                isTextInput: _isTextInput,
                animationsDuration: widget.animationsDuration,
                activeItem: _activeItem,
                isDeletePosition: _isDeletePosition,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FooterToolsWidget(
                  onDone: _onDone,
                  doneButtonChild: widget.doneButtonChild,
                  isLoading: _isLoading,
                  doneButtonBuilder: widget.doneButtonBuilder,
                ),
              ),
              // Style name overlay - positioned at the end to appear on top
              if (_displayedStyleName != null)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _displayedStyleName!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              // Filter name overlay - positioned at the end to appear on top
              if (_displayedFilterName != null)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        margin: EdgeInsets.only(
                          bottom: context.bottomPadding,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _displayedFilterName!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Handles the submission of text input.
  ///
  /// This method is called when the user submits the text input field.
  /// If the input is not empty, it calls the [_onSubmitText] method to add the text to the stack data.
  /// If the input is empty, it resets the [_currentText] to an empty string.
  /// In either case, it toggles the [_isTextInput] flag to exit the text input mode and sets the [_activeItem] to null.
  void _onTextSubmit(String input) {
    if (input.isNotEmpty) {
      setState(
        _onSubmitText,
      );
    } else {
      setState(() {
        _currentText = '';
      });
    }

    setState(
      () {
        _isTextInput = !_isTextInput;
        _activeItem = null;
      },
    );
  }

  /// Handles the change of text input.
  ///
  /// This method is called when the user types into the text input field.
  /// It updates the [_currentText] with the new input.
  void _onTextChange(input) {
    setState(() {
      _currentText = input;
    });
  }

  /// Changes the background of the text.
  ///
  /// This method is called when the user taps on the text background change button.
  /// It increments the [_selectedTextBackgroundGradient] index if it's less than the length of gradients array.
  /// If the index has reached the end of the array, it resets it to 0.
  void _onChangeTextBackground() {
    if (_selectedTextBackgroundGradient < _gradients.length - 1) {
      setState(() {
        _selectedTextBackgroundGradient++;
      });
    } else {
      setState(() {
        _selectedTextBackgroundGradient = 0;
      });
    }
  }

  /// Toggles the text color selector.
  ///
  /// This method is called when the user taps on the text color selector button.
  /// It toggles the [_isColorPickerSelected] flag to show or hide the color picker.
  void _onToggleTextColorSelector() {
    setState(
      () {
        _isColorPickerSelected = !_isColorPickerSelected;
      },
    );
  }

  /// Handles the change of text color.
  ///
  /// This method is called when the user selects a new text color from the color picker.
  /// It updates the [_selectedTextColor] with the new color.
  /// The [index] parameter is the index of the selected color in the text colors list.
  void _onTextColorChange(index) {
    HapticFeedback.lightImpact();
    setState(
      () {
        _selectedTextColor = _textColors[index];
      },
    );
  }

  /// Handles the change of font family.
  ///
  /// This method is called when the user selects a new font family from the font family picker.
  /// It updates the [_selectedFontFamily] with the new font family.
  /// The [index] parameter is the index of the selected font family in the [fontFamilyList] list.
  void _onFamilyChange(index) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedFontFamily = index;
    });
  }

  /// Toggles the background gradient picker.
  ///
  /// This method is called when the user taps on the background gradient picker button.
  /// It toggles the [_isBackgroundColorPickerSelected] flag to show or hide the background gradient picker.
  void _onToggleBackgroundGradientPicker() {
    setState(
      () {
        _isBackgroundColorPickerSelected = !_isBackgroundColorPickerSelected;
        _isStickerPickerSelected = false;
        _isColorFilterPickerSelected = false;
      },
    );
  }

  /// Toggles the sticker picker.
  ///
  /// This method is called when the user taps on the sticker button.
  /// It toggles the [_isStickerPickerSelected] flag to show or hide the sticker picker.
  void _onToggleStickerPicker() {
    setState(
      () {
        _isStickerPickerSelected = !_isStickerPickerSelected;
        _isBackgroundColorPickerSelected = false;
        _isColorFilterPickerSelected = false;
        _isTextInput = false;
        _activeItem = null;
      },
    );
  }

  /// Toggles the color filter picker.
  ///
  /// This method is called when the user taps on the color filter button.
  /// It toggles the [_isColorFilterPickerSelected] flag to show or hide the color filter picker.
  void _onToggleColorFilterPicker() {
    setState(
      () {
        _isColorFilterPickerSelected = !_isColorFilterPickerSelected;
        _isBackgroundColorPickerSelected = false;
        _isStickerPickerSelected = false;
        _isTextInput = false;
        _activeItem = null;
      },
    );
  }

  /// Handles color filter selection.
  ///
  /// This method is called when the user selects a color filter.
  /// It updates the [_selectedColorFilter] with the new filter.
  void _onColorFilterSelected(ColorFilterType filter) {
    HapticFeedback.lightImpact();

    // Cancel previous timer if exists
    _filterNameTimer?.cancel();

    // Get the filter name
    final filterName = getFilterName(filter);

    setState(() {
      _selectedColorFilter = filter;
      _isColorFilterPickerSelected = false;
      _displayedFilterName = filterName;
    });

    log('filterName: $filterName');

    // Hide the filter name after 2 seconds
    _filterNameTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _displayedFilterName = null;
        });
      }
    });

    // Only jump to page if PageController is attached
    if (_colorFiltersPageController.hasClients) {
      _colorFiltersPageController.jumpToPage(filter.index);
    }
  }

  /// Handles horizontal drag end (swipe) to change filters.
  ///
  /// This method is called when the user swipes horizontally on the image.
  /// It changes the filter to the next or previous one based on the swipe direction.
  void _onHorizontalDragEnd(DragEndDetails details) {
    // Only handle swipe if not in action (moving/editing items) and not in text input
    if (_inAction || _isTextInput || _activeItem != null) {
      return;
    }

    final velocity = details.velocity.pixelsPerSecond.dx;
    final threshold = 300.0; // Minimum velocity to trigger filter change

    if (velocity.abs() > threshold) {
      final filters = ColorFilterType.values;
      final currentIndex = _selectedColorFilter.index;

      // Cancel previous timer if exists
      _filterNameTimer?.cancel();

      if (velocity > 0) {
        // Swipe right - next filter
        final nextIndex = (currentIndex + 1) % filters.length;
        final filter = filters[nextIndex];
        final filterName = getFilterName(filter);

        HapticFeedback.lightImpact();
        setState(() {
          _selectedColorFilter = filter;
          _displayedFilterName = filterName;
        });

        // Hide the filter name after 2 seconds
        _filterNameTimer = Timer(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _displayedFilterName = null;
            });
          }
        });

        // Only jump to page if PageController is attached
        if (_colorFiltersPageController.hasClients) {
          _colorFiltersPageController.jumpToPage(nextIndex);
        }
      } else {
        // Swipe left - previous filter
        final prevIndex = (currentIndex - 1 + filters.length) % filters.length;
        final filter = filters[prevIndex];
        final filterName = getFilterName(filter);

        HapticFeedback.lightImpact();
        setState(() {
          _selectedColorFilter = filter;
          _displayedFilterName = filterName;
        });

        // Hide the filter name after 2 seconds
        _filterNameTimer = Timer(const Duration(seconds: 5), () {
          if (mounted) {
            setState(() {
              _displayedFilterName = null;
            });
          }
        });

        // Only jump to page if PageController is attached
        if (_colorFiltersPageController.hasClients) {
          _colorFiltersPageController.jumpToPage(prevIndex);
        }
      }
    }
  }

  /// Handles sticker selection.
  ///
  /// This method is called when the user selects a sticker from the sticker picker.
  /// It adds a new [EditableItem] of type [ItemType.STICKER] to the [_stackData].
  void _onStickerSelected(StickerItem sticker) {
    setState(() {
      _stackData.add(
        EditableItem()
          ..type = ItemType.STICKER
          ..value = sticker.value
          ..fontSize = FontSizeConstants.defaultValue,
      );
      _isStickerPickerSelected = false;
    });
  }

  /// Handles the selection of a background gradient.
  ///
  /// This method is called when the user selects a new background gradient from the gradient picker.
  /// It updates the [_selectedBackgroundGradient] with the new gradient and jumps the [_gradientsPageController] to the selected page.
  /// The [index] parameter is the index of the selected gradient in the [gradientColors] list.
  void _onBackgroundGradientTap(index) {
    setState(
      () {
        _selectedBackgroundGradient = index;
        _gradientsPageController.jumpToPage(index);
      },
    );
  }

  /// Handles the change of background gradient.
  ///
  /// This method is called when the user selects a new background gradient from the gradient picker.
  /// It updates the [_selectedBackgroundGradient] with the new gradient.
  /// The [index] parameter is the index of the selected gradient in the [gradientColors] list.
  void _onChangeBackgroundGradient(index) {
    HapticFeedback.lightImpact();
    setState(
      () {
        _selectedBackgroundGradient = index;
      },
    );
  }

  /// Handles the start of a scale gesture.
  ///
  /// This method is called when the user starts a scale gesture on the active item.
  /// It sets the [_initPos], [_currentPos], [_currentScale], and [_currentRotation] to the initial values of the gesture.
  /// The [details] parameter contains the details of the scale start gesture.
  void _onScaleStart(ScaleStartDetails details) {
    if (_activeItem == null) {
      return;
    }
    _initPos = details.focalPoint;
    _currentPos = _activeItem!.position;
    _currentScale = _activeItem!.scale;
    _currentRotation = _activeItem!.rotation;
  }

  /// Handles the update of a scale gesture.
  ///
  /// This method is called when the user updates a scale gesture on the active item.
  /// It calculates the new position, rotation, and scale of the active item based on the gesture details and updates the state.
  /// The [details] parameter contains the details of the scale update gesture.
  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (_activeItem == null) {
      return;
    }
    final delta = details.focalPoint - _initPos;
    final left = (delta.dx / context.width) + _currentPos.dx;
    final top = (delta.dy / context.height) + _currentPos.dy;

    setState(() {
      _activeItem!.position = Offset(left, top);
      _activeItem!.rotation = details.rotation + _currentRotation;
      _activeItem!.scale = details.scale * _currentScale;
    });
  }

  /// Handles the screen tap event.
  ///
  /// This method is called when the user taps on the screen.
  /// It toggles the [_isTextInput] flag to enter or exit the text input mode and sets the [_activeItem] to null.
  /// If the current text is not empty, it calls the [_onSubmitText] method to add the text to the stack data.
  /// It also initializes the [_familyPageController] and [_textColorsPageController] with their respective viewport fractions.
  void _onScreenTap() {
    setState(() {
      _isTextInput = !_isTextInput;
      _activeItem = null;
      _isBackgroundColorPickerSelected = false;
      _isStickerPickerSelected = false;
    });

    if (_currentText.isNotEmpty) {
      setState(_onSubmitText);
    }
    _familyPageController.dispose();
    _textColorsPageController.dispose();
    _familyPageController = PageController(
      initialPage: _selectedFontFamily,
      viewportFraction: ViewportFractions.fontFamily,
    );
    _textColorsPageController = PageController(
      initialPage:
          _textColors.indexWhere((element) => element == _selectedTextColor),
      viewportFraction: ViewportFractions.textColors,
    );
  }

  /// Handles the done event.
  ///
  /// This method is called when the user taps on the done button.
  /// It captures the current state of the widget as an image and saves it to the application documents directory.
  /// The image is saved as a png file with the current date and time as the file name.
  /// After the image is saved, it navigates back and passes the image file as the result of the navigation.
  Future<void> _onDone() async {
    final boundary = previewContainer.currentContext!.findRenderObject()
        as RenderRepaintBoundary?;
    setState(() {
      _isLoading = true;
    });
    final image = await boundary!.toImage(pixelRatio: 3);
    final directory = (await getApplicationDocumentsDirectory()).path;
    final byteData = (await image.toByteData(format: ui.ImageByteFormat.png))!;
    final pngBytes = byteData.buffer.asUint8List();
    final imgFile = File('$directory/${DateTime.now()}.png');
    await imgFile.writeAsBytes(pngBytes);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    if (mounted) {
      Navigator.of(context).pop(imgFile);
    }
  }

  /// Handles the submission of text input.
  ///
  /// This method is called when the user submits the text input field.
  /// It adds a new [EditableItem] of type [ItemType.TEXT] to the [_stackData] with the current text, text color, text style, font size, and font family.
  /// It then resets the [_editingController] and [_currentText] to an empty string.
  void _onSubmitText() {
    _stackData.add(
      EditableItem()
        ..type = ItemType.TEXT
        ..value = _currentText
        ..color = _selectedTextColor
        ..textStyle = _selectedTextBackgroundGradient
        ..fontSize = _selectedFontSize
        ..fontFamily = _selectedFontFamily,
    );
    _editingController.text = '';
    _currentText = '';
  }

  /// Handles the change of font style.
  ///
  /// This method is called when the user selects a new font style from the style picker.
  /// It updates the [_selectedFontFamily] with the new style and jumps the [_familyPageController] to the selected page.
  /// The [index] parameter is the index of the selected style in the [fontFamilyList] list.
  void _onStyleChange(int index) {
    HapticFeedback.lightImpact();

    // Cancel previous timer if exists
    _styleNameTimer?.cancel();

    // Get the style name
    final styleName = _fontList[index];

    setState(() {
      _selectedFontFamily = index;
      _displayedStyleName = styleName;
    });

    // Hide the style name after 2 seconds
    _styleNameTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _displayedStyleName = null;
        });
      }
    });

    if (_familyPageController.hasClients) {
      _familyPageController.jumpToPage(index);
    }
  }

  /// Handles the change of text color.
  ///
  /// This method is called when the user selects a new text color from the color picker.
  /// It updates the [_selectedTextColor] with the new color and jumps the [_textColorsPageController] to the selected page.
  /// The [index] parameter is the index of the selected color in the text colors list.
  void _onColorChange(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedTextColor = _textColors[index];
    });
    _textColorsPageController.jumpToPage(index);
  }

  /// Handles the tap event on an overlay item.
  ///
  /// This method is called when the user taps on an overlay item.
  /// It toggles the [_isTextInput] flag to enter or exit the text input mode, sets the [_activeItem] to null, and updates the text and style properties based on the tapped item.
  /// It also removes the tapped item from the [_stackData] and initializes the [_familyPageController] and [_textColorsPageController] with their respective viewport fractions.
  /// The [e] parameter is the tapped [EditableItem].
  void _onOverlayItemTap(EditableItem e) {
    setState(
      () {
        _isTextInput = !_isTextInput;
        _activeItem = null;
        _editingController.text = e.value;
        _currentText = e.value;
        _selectedFontFamily = e.fontFamily;
        _selectedFontSize = e.fontSize;
        _selectedTextBackgroundGradient = e.textStyle;
        _selectedTextColor = e.color;
        _stackData.removeAt(_stackData.indexOf(e));
      },
    );
    _familyPageController.dispose();
    _textColorsPageController.dispose();
    _familyPageController = PageController(
      initialPage: e.fontFamily,
      viewportFraction: ViewportFractions.fontFamily,
    );
    _textColorsPageController = PageController(
      initialPage: _textColors.indexWhere(
        (element) => element == e.color,
      ),
      viewportFraction: ViewportFractions.textColors,
    );
  }

  /// Handles the pointer down event on an overlay item.
  ///
  /// This method is called when the user starts a pointer down gesture on an overlay item.
  /// If the item is not an image and the widget is not in action, it sets the [_inAction] flag to true and updates the initial values of the gesture.
  /// The [e] parameter is the [EditableItem] on which the gesture started.
  /// The [details] parameter contains the details of the pointer down gesture.
  void _onOverlayItemPointerDown(EditableItem e, PointerDownEvent details) {
    if (e.type != ItemType.IMAGE) {
      if (_inAction) {
        return;
      }
      _inAction = true;
      _activeItem = e;
      _initPos = details.position;
      _currentPos = e.position;
      _currentScale = e.scale;
      _currentRotation = e.rotation;
    }
  }

  /// Handles the pointer up event on an overlay item.
  ///
  /// This method is called when the user ends a pointer up gesture on an overlay item.
  /// It sets the [_inAction] flag to false and checks if the item is in the delete position.
  /// If the item is in the delete position, it removes the item from the [_stackData] and sets the [_activeItem] to null.
  /// The [e] parameter is the [EditableItem] on which the gesture ended.
  /// The [details] parameter contains the details of the pointer up gesture.
  void _onOverlayItemPointerUp(EditableItem e, PointerUpEvent details) {
    _inAction = false;
    if (e.position.dy >= PositionConstants.deletePositionThreshold &&
        e.position.dx >= 0.0 &&
        e.position.dx <= 1.0) {
      setState(() {
        _stackData.removeAt(_stackData.indexOf(e));
        _activeItem = null;
      });
    } else {
      setState(() {
        _activeItem = null;
      });
    }
  }

  /// Handles the pointer move event on an overlay item.
  ///
  /// This method is called when the user moves a pointer on an overlay item.
  /// It checks if the item is in the delete position and updates the [_isDeletePosition] flag accordingly.
  /// The [e] parameter is the [EditableItem] on which the pointer is moving.
  /// The [details] parameter contains the details of the pointer move gesture.
  void _onOverlayItemPointerMove(EditableItem e, PointerMoveEvent details) {
    if (e.position.dy >= PositionConstants.deletePositionThreshold &&
        e.position.dx >= 0.0 &&
        e.position.dx <= 1.0) {
      setState(() {
        _isDeletePosition = true;
      });
    } else {
      setState(() {
        _isDeletePosition = false;
      });
    }
  }
}
