import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFF5C6AA), // peach
  primaryColor: const Color(0xFF999DF6),
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
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF999DF6)),
);
