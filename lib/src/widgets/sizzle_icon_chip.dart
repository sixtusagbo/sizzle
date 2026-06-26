import 'package:flutter/material.dart';

import '../sizzle_style.dart';

/// The circular, softly tinted chip that holds a toast's icon.
class SizzleIconChip extends StatelessWidget {
  const SizzleIconChip({super.key, required this.style, required this.icon});

  /// Supplies the tint (chip background) and accent (icon) colors.
  final SizzleStyle style;

  /// The glyph drawn at the center of the chip.
  final IconData icon;

  static const double _size = 50;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(color: style.tintColor, shape: BoxShape.circle),
      child: Icon(icon, color: style.accentColor, size: 24),
    );
  }
}
