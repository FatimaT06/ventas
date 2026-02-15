import 'package:flutter/material.dart';

class C {
  static const black      = Color(0xFF0D0D0D);
  static const dark       = Color(0xFF1C1C1C);
  static const grey       = Color(0xFF8A8A8A);
  static const lightGrey  = Color(0xFFF2F2F2);
  static const border     = Color(0xFFE5E5E5);
  static const white      = Color(0xFFFFFFFF);
  static const bg         = Color(0xFFF7F7F7);
  static const green      = Color(0xFF22C55E);
  static const red        = Color(0xFFEF4444);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: C.bg,
    fontFamily: 'SF Pro Display',
    colorScheme: const ColorScheme.light(
      primary: C.black,
      surface: C.white,
      background: C.bg,
    ),
  );
}
