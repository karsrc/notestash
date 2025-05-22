import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFF8F1E9), // cream background
  primaryColor: const Color(0xFFC3CCF7), // lavender
  iconTheme: const IconThemeData(color: Color(0xFF3C4F76)),
  textTheme: ThemeData.light().textTheme.apply(
    bodyColor: const Color(0xFF3C4F76), // navy-ish text
    displayColor: const Color(0xFF3C4F76),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Color(0xFFC3CCF7), // match primary
    elevation: 0,
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: const TextStyle(color: Color(0xFFB9B7C9)), // subtle
    hintStyle: const TextStyle(color: Color(0xFFB9B7C9)),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFB9B7C9)),
    ),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFC3CCF7),
    brightness: Brightness.light,
  ),
  extensions: <ThemeExtension<dynamic>>[
    const AppColors(
      rose: Color(0xFFD99FA6),
      coral: Color(0xFFF4A896),
      peach: Color(0xFFF5C6AA),
      sand: Color(0xFFE8B888),
      mint: Color(0xFFC7D8B6),
      sage: Color(0xFFAAC3A7),
      fog: Color(0xFFD6DBE1),
      steel: Color(0xFFA1B2C6),
      lavender: Color(0xFFB6A6D8),
      lilac: Color(0xFFD1B9E2),
      wine: Color(0xFF8D5D67),
      slate: Color(0xFF5A7684),
      gold: Color(0xFFAA8C5F),
      seafoam: Color(0xFF99C1B1),
    ),
  ],
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFF2B2739), // deep indigo
  primaryColor: const Color(0xFF7566EA), // royal violet
  iconTheme: const IconThemeData(color: Color(0xFFE5E4F0)),
  textTheme: ThemeData.dark().textTheme.apply(
    bodyColor: const Color(0xFFE5E4F0),
    displayColor: const Color(0xFFE5E4F0),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Color(0xFF7566EA),
    elevation: 0,
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: const TextStyle(color: Color(0xFFB9B7C9)),
    hintStyle: const TextStyle(color: Color(0xFFB9B7C9)),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFB9B7C9)),
    ),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF7566EA),
    brightness: Brightness.dark,
  ),
  extensions: <ThemeExtension<dynamic>>[
    const AppColors(
      rose: Color(0xFFD99FA6),
      coral: Color(0xFFF4A896),
      peach: Color(0xFFF5C6AA),
      sand: Color(0xFFE8B888),
      mint: Color(0xFFC7D8B6),
      sage: Color(0xFFAAC3A7),
      fog: Color(0xFFD6DBE1),
      steel: Color(0xFFA1B2C6),
      lavender: Color(0xFFB6A6D8),
      lilac: Color(0xFFD1B9E2),
      wine: Color(0xFF8D5D67),
      slate: Color(0xFF5A7684),
      gold: Color(0xFFAA8C5F),
      seafoam: Color(0xFF99C1B1),
    ),
  ],
);
