library story_maker;

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

import 'components/background_gradient_selector_widget.dart';
import 'components/font_family_select_widget.dart';
import 'components/footer_tools_widget.dart';
import 'components/overlay_item_widget.dart';
import 'components/remove_widget.dart';
import 'components/size_slider_widget.dart';
import 'components/text_color_select_widget.dart';
import 'components/text_field_widget.dart';
import 'components/top_tools_widget.dart';
import 'constants/font_colors.dart';
import 'constants/gradients.dart';
import 'constants/item_type.dart';
import 'extensions/context_extension.dart';
import 'models/editable_items.dart';

class StoryMaker extends StatefulWidget {
  const StoryMaker({
    Key? key,
    required this.filePath,
    this.animationsDuration = const Duration(milliseconds: 300),
    this.doneButtonChild,
  }) : super(key: key);

  final String filePath;
  final Duration animationsDuration;
  final Widget? doneButtonChild;

  @override
  _StoryMakerState createState() => _StoryMakerState();
}

class _StoryMakerState extends State<StoryMaker> {
  static GlobalKey previewContainer = GlobalKey();
  EditableItem? _activeItem;
  Offset _initPos = const Offset(0, 0);
  Offset _currentPos = const Offset(0, 0);
  double _currentScale = 1;
  double _currentRotation = 0;
  bool _inAction = false;
  bool _isTextInput = false;
  String _currentText = '';
  Color _selectedTextColor = const Color(0xffffffff);
  int _selectedTextBackgroundGradient = 0;
  int _selectedBackgroundGradient = 0;
  double _selectedFontSize = 26;
  int _selectedFontFamily = 0;
  bool _isDeletePosition = false;
  bool _isColorPickerSelected = false;
  bool _isBackgroundColorPickerSelected = false;
  late PageController _familyPageController;
  late PageController _textColorsPageController;
  late PageController _gradientsPageController;
  final _editingController = TextEditingController();
  final _stackData = <EditableItem>[];

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _editingController.dispose();
    _familyPageController.dispose();
    _textColorsPageController.dispose();
    _gradientsPageController.dispose();
    super.dispose();
  }

  void _init() {
    _stackData.add(
      EditableItem()
        ..type = ItemType.IMAGE
        ..value = widget.filePath,
    );
    _familyPageController = PageController(viewportFraction: .125);
    _textColorsPageController = PageController(viewportFraction: .1);
    _gradientsPageController = PageController(viewportFraction: .175);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextHeightBehavior(
      textHeightBehavior: const TextHeightBehavior(
        leadingDistribution: TextLeadingDistribution.even,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Stack(
          clipBehavior: Clip.antiAlias,
          children: [
            Positioned(
              top: context.topPadding,
              left: 0,
              right: 0,
              child: ClipRect(
                child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: GestureDetector(
                    onScaleStart: _onScaleStart,
                    onScaleUpdate: _onScaleUpdate,
                    onTap: _onScreenTap,
                    child: Stack(
                      children: [
                        RepaintBoundary(
                          key: previewContainer,
                          child: Stack(
                            children: [
                              Visibility(
                                visible: _stackData[0].type == ItemType.IMAGE,
                                child: Center(
                                  child: PhotoView(
                                    enableRotation: true,
                                    backgroundDecoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: FractionalOffset.topLeft,
                                        end: FractionalOffset.centerRight,
                                        colors: gradientColors[
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
                              ..._stackData
                                  .map(
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
                                    ),
                                  )
                                  .toList(),
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
                                      if (!_isColorPickerSelected)
                                        FontFamilySelectWidget(
                                          animationsDuration:
                                              widget.animationsDuration,
                                          pageController: _familyPageController,
                                          selectedFamilyIndex:
                                              _selectedFontFamily,
                                          onPageChanged: _onFamilyChange,
                                          onTap: (index) {
                                            _onStyleChange(index);
                                          },
                                        )
                                      else
                                        TextColorSelectWidget(
                                          animationsDuration:
                                              widget.animationsDuration,
                                          pageController:
                                              _textColorsPageController,
                                          selectedTextColor: _selectedTextColor,
                                          onPageChanged: _onTextColorChange,
                                          onTap: (index) {
                                            _onColorChange(index);
                                          },
                                        ),
                                    ],
                                  ),
                                ),
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
                        ),
                        TopToolsWidget(
                          isTextInput: _isTextInput,
                          selectedBackgroundGradientIndex:
                              _selectedBackgroundGradient,
                          animationsDuration: widget.animationsDuration,
                          onPickerTap: _onToggleBackgroundGradientPicker,
                          onScreenTap: _onScreenTap,
                          selectedTextBackgroundGradientIndex:
                              _selectedTextBackgroundGradient,
                          onToggleTextColorPicker: _onToggleTextColorSelector,
                          onChangeTextBackground: _onChangeTextBackground,
                          activeItem: _activeItem,
                        ),
                        RemoveWidget(
                          isTextInput: _isTextInput,
                          animationsDuration: widget.animationsDuration,
                          activeItem: _activeItem,
                          isDeletePosition: _isDeletePosition,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FooterToolsWidget(
                onDone: _onDone,
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  void _onTextChange(input) {
    setState(() {
      _currentText = input;
    });
  }

  void _onChangeTextBackground() {
    if (_selectedTextBackgroundGradient < gradientColors.length - 1) {
      setState(() {
        _selectedTextBackgroundGradient++;
      });
    } else {
      setState(() {
        _selectedTextBackgroundGradient = 0;
      });
    }
  }

  void _onToggleTextColorSelector() {
    setState(
      () {
        _isColorPickerSelected = !_isColorPickerSelected;
      },
    );
  }

  void _onTextColorChange(index) {
    HapticFeedback.lightImpact();
    setState(
      () {
        _selectedTextColor = defaultColors[index];
      },
    );
  }

  void _onFamilyChange(index) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedFontFamily = index;
    });
  }

  void _onToggleBackgroundGradientPicker() {
    setState(
      () {
        _isBackgroundColorPickerSelected = !_isBackgroundColorPickerSelected;
      },
    );
  }

  void _onBackgroundGradientTap(index) {
    setState(
      () {
        _selectedBackgroundGradient = index;
        _gradientsPageController.jumpToPage(index);
      },
    );
  }

  void _onChangeBackgroundGradient(index) {
    HapticFeedback.lightImpact();
    setState(
      () {
        _selectedBackgroundGradient = index;
      },
    );
  }

  void _onScaleStart(ScaleStartDetails details) {
    if (_activeItem == null) {
      return;
    }
    _initPos = details.focalPoint;
    _currentPos = _activeItem!.position;
    _currentScale = _activeItem!.scale;
    _currentRotation = _activeItem!.rotation;
  }

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

  void _onScreenTap() {
    setState(() {
      _isTextInput = !_isTextInput;
      _activeItem = null;
      _isBackgroundColorPickerSelected = false;
    });

    if (_currentText.isNotEmpty) {
      setState(_onSubmitText);
    }
    _familyPageController = PageController(
      initialPage: _selectedFontFamily,
      viewportFraction: .125,
    );
    _textColorsPageController = PageController(
      initialPage:
          defaultColors.indexWhere((element) => element == _selectedTextColor),
      viewportFraction: .1,
    );
  }

  Future<void> _onDone() async {
    final boundary = previewContainer.currentContext!.findRenderObject()
        as RenderRepaintBoundary?;
    final image = await boundary!.toImage(pixelRatio: 3);
    final directory = (await getApplicationDocumentsDirectory()).path;
    final byteData = (await image.toByteData(format: ui.ImageByteFormat.png))!;
    final pngBytes = byteData.buffer.asUint8List();
    final imgFile = File('$directory/${DateTime.now()}.png');
    await imgFile.writeAsBytes(pngBytes).then((value) {
      // done: return imgFile
      Navigator.of(context).pop(imgFile);
    });
  }

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

  void _onStyleChange(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedFontFamily = index;
    });
    _familyPageController.jumpToPage(index);
  }

  void _onColorChange(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedTextColor = defaultColors[index];
    });
    _textColorsPageController.jumpToPage(index);
  }

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
    _familyPageController = PageController(
      initialPage: e.textStyle,
      viewportFraction: .1,
    );
    _textColorsPageController = PageController(
      initialPage: defaultColors.indexWhere(
        (element) => element == e.color,
      ),
      viewportFraction: .1,
    );
  }

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

  void _onOverlayItemPointerUp(EditableItem e, PointerUpEvent details) {
    _inAction = false;
    if (e.position.dy >= 0.65 && e.position.dx >= 0.0 && e.position.dx <= 1.0) {
      setState(() {
        _stackData.removeAt(_stackData.indexOf(e));
        _activeItem = null;
      });
    }

    setState(() {
      _activeItem = null;
    });
  }

  void _onOverlayItemPointerMove(EditableItem e, PointerMoveEvent details) {
    if (e.position.dy >= 0.65 && e.position.dx >= 0.0 && e.position.dx <= 1.0) {
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
