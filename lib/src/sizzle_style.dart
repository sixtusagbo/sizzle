import 'package:flutter/material.dart';

import 'sizzle_type.dart';

/// The resolved visual treatment for a [SizzleType]: the accent color used for
/// the icon, the soft tint behind it, and the default icon glyph.
///
/// Internal to the package for now. Per-type colors are not yet part of the
/// public API; that arrives with theming in a later release.
@immutable
class SizzleStyle {
  const SizzleStyle({
    required this.accentColor,
    required this.tintColor,
    required this.icon,
  });

  /// The saturated color for the icon (and any accent).
  final Color accentColor;

  /// The soft, low-opacity background behind the icon chip.
  final Color tintColor;

  /// The default glyph shown in the icon chip when the caller passes none.
  final IconData icon;

  static const SizzleStyle _success = SizzleStyle(
    accentColor: Color(0xFF1FA463),
    tintColor: Color(0xFFE7F6EC),
    icon: Icons.check_rounded,
  );

  static const SizzleStyle _error = SizzleStyle(
    accentColor: Color(0xFFE5484D),
    tintColor: Color(0xFFFCEBEC),
    icon: Icons.close_rounded,
  );

  /// Resolves the style for [type].
  static SizzleStyle of(SizzleType type) {
    switch (type) {
      case SizzleType.success:
        return _success;
      case SizzleType.error:
        return _error;
    }
  }
}
