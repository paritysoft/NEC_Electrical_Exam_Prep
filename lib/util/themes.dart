import 'package:flutter/material.dart';
import '../ui/widgets/responsive_layout.dart';

final ThemeData light = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: appNavy,
    primary: appNavy,
    surface: Colors.white,
  ),
  primaryColor: appNavy,
  scaffoldBackgroundColor: appCanvas,
  appBarTheme: const AppBarTheme(
    backgroundColor: appNavy,
    foregroundColor: Colors.white,
    centerTitle: true,
    elevation: 0,
    toolbarHeight: 64,
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: appBorder),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: appNavy,
      foregroundColor: Colors.white,
      minimumSize: const Size(120, 52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(minimumSize: const Size(120, 52)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: appBorder),
    ),
  ),
  dividerTheme: const DividerThemeData(color: appBorder),
  dialogTheme: DialogThemeData(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white,
    showDragHandle: true,
    constraints: BoxConstraints(maxWidth: 640),
  ),
  listTileTheme: const ListTileThemeData(
    iconColor: appNavy,
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 15, height: 1.45, color: Color(0xFF20252B)),
  ),
);
final ThemeData dark = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: appNavy,
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
);
