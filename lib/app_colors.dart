// app_colors.dart
import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color rose;
  final Color coral;
  final Color peach;
  final Color sand;
  final Color mint;
  final Color sage;
  final Color fog;
  final Color steel;
  final Color lavender;
  final Color lilac;
  final Color wine;
  final Color slate;
  final Color gold;
  final Color seafoam;

  const AppColors({
    required this.rose,
    required this.coral,
    required this.peach,
    required this.sand,
    required this.mint,
    required this.sage,
    required this.fog,
    required this.steel,
    required this.lavender,
    required this.lilac,
    required this.wine,
    required this.slate,
    required this.gold,
    required this.seafoam,
  });

  @override
  AppColors copyWith({
    Color? rose,
    Color? coral,
    Color? peach,
    Color? sand,
    Color? mint,
    Color? sage,
    Color? fog,
    Color? steel,
    Color? lavender,
    Color? lilac,
    Color? wine,
    Color? slate,
    Color? gold,
    Color? seafoam,
  }) {
    return AppColors(
      rose: rose ?? this.rose,
      coral: coral ?? this.coral,
      peach: peach ?? this.peach,
      sand: sand ?? this.sand,
      mint: mint ?? this.mint,
      sage: sage ?? this.sage,
      fog: fog ?? this.fog,
      steel: steel ?? this.steel,
      lavender: lavender ?? this.lavender,
      lilac: lilac ?? this.lilac,
      wine: wine ?? this.wine,
      slate: slate ?? this.slate,
      gold: gold ?? this.gold,
      seafoam: seafoam ?? this.seafoam,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      rose: Color.lerp(rose, other.rose, t)!,
      coral: Color.lerp(coral, other.coral, t)!,
      peach: Color.lerp(peach, other.peach, t)!,
      sand: Color.lerp(sand, other.sand, t)!,
      mint: Color.lerp(mint, other.mint, t)!,
      sage: Color.lerp(sage, other.sage, t)!,
      fog: Color.lerp(fog, other.fog, t)!,
      steel: Color.lerp(steel, other.steel, t)!,
      lavender: Color.lerp(lavender, other.lavender, t)!,
      lilac: Color.lerp(lilac, other.lilac, t)!,
      wine: Color.lerp(wine, other.wine, t)!,
      slate: Color.lerp(slate, other.slate, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      seafoam: Color.lerp(seafoam, other.seafoam, t)!,
    );
  }
}
