import 'package:flutter/material.dart';

import '../constants/item_type.dart';

class EditableItem {
  Offset position = const Offset(0.1, 0.4);
  double scale = 1;
  double rotation = 0;
  ItemType type = ItemType.TEXT;
  String value = '';
  Color color = Colors.transparent;
  int textStyle = 0;
  double fontSize = 14;
  int fontFamily = 0;
}
