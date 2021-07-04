import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  Color get customTitleColor => brightness == Brightness.light
      ? const Color(0xff0f4b1b)
      : const Color(0xd232d056);
}