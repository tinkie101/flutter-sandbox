import 'package:flutter/material.dart';

extension CustomThemeColors on ThemeData {
  Color get customDescriptionColor => brightness == Brightness.light
      ? const Color(0xff0f4b1b)
      : const Color(0xd232d056);

  Color get deleteButtonColor => Colors.red.shade100;
}
