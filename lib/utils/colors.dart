import 'package:flutter/material.dart';

const Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

abstract class AppColors {
  static const Color MAIN = Color(0xFF1D1A4D);
  static const Color MAIN_LIGHT = Color(0xFF363875);
  static const Color MAIN_DARK = Color(0xFF3D389D);
  static const MaterialColor MATERIAL_MAIN = MaterialColor(0xFF1D1A4D, color);
  static const Color CATEGORY_SHADOW = Color(0xFFd3bffc);
  static const Color TAB_LINE_YELLOW = Color(0xFFFBD30E);
  static const Color TABBAR_SHADOW = Color(0xFFdddae5);
  static const Color GRAY_LIGHT = Color(0xFFf5f5f5);
  static const Color PAGE_BACK = Color(0xEEDF2F8);
  static const MaterialColor BLUE_GRAY = MaterialColor(0xdddfe6e9, color);
}
