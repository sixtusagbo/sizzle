import 'package:flutter/material.dart';

import 'sizzle.dart';
import 'sizzle_position.dart';
import 'sizzle_type.dart';

/// Adds [sizzle] to [BuildContext] as a terser alternative to [Sizzle.show].
///
/// ```dart
/// context.sizzle(
///   type: SizzleType.error,
///   title: 'No Internet Connection',
///   message: 'Please check your connection and try again.',
/// );
/// ```
extension SizzleX on BuildContext {
  /// Shows a toast anchored to this context's overlay. Forwards to
  /// [Sizzle.show]; see it for parameter details.
  void sizzle({
    required String title,
    String? message,
    SizzleType type = SizzleType.success,
    Duration duration = const Duration(seconds: 4),
    SizzlePosition position = SizzlePosition.top,
    IconData? icon,
    VoidCallback? onTap,
    bool showCloseButton = true,
  }) {
    Sizzle.show(
      this,
      title: title,
      message: message,
      type: type,
      duration: duration,
      position: position,
      icon: icon,
      onTap: onTap,
      showCloseButton: showCloseButton,
    );
  }
}
