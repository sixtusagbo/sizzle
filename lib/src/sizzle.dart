import 'package:flutter/material.dart';

import 'sizzle_position.dart';
import 'sizzle_style.dart';
import 'sizzle_type.dart';
import 'widgets/sizzle_toast.dart';

/// Entry point for showing toasts.
///
/// Call [Sizzle.show] from anywhere with a [BuildContext] under a [MaterialApp]
/// (or any [Overlay]). The toast floats above your app via the root overlay,
/// so no `Scaffold` is required.
///
/// ```dart
/// Sizzle.show(
///   context,
///   type: SizzleType.success,
///   title: 'Connection Restored',
///   message: 'You are back online.',
/// );
/// ```
class Sizzle {
  Sizzle._();

  static OverlayEntry? _current;

  /// Shows a toast and returns immediately.
  ///
  /// A new call replaces any toast already on screen; stacking arrives in a
  /// later release.
  ///
  /// - [title] is the bold headline (required).
  /// - [message] is the optional gray line beneath it.
  /// - [type] selects the color and default icon. Defaults to
  ///   [SizzleType.success].
  /// - [duration] is how long it stays before auto-dismissing. Pass
  ///   [Duration.zero] to keep it until tapped. Defaults to 4 seconds.
  /// - [position] anchors the toast to the top or bottom of the screen and
  ///   sets the slide direction. Defaults to [SizzlePosition.top].
  /// - [icon] overrides the type's default glyph.
  /// - [onTap] fires when the body is tapped; the toast then dismisses.
  /// - [showCloseButton] toggles the trailing close button.
  /// - [swipeToDismiss] lets the user flick the toast away horizontally.
  ///   Defaults to true.
  static void show(
    BuildContext context, {
    required String title,
    String? message,
    SizzleType type = SizzleType.success,
    Duration duration = const Duration(seconds: 4),
    SizzlePosition position = SizzlePosition.top,
    IconData? icon,
    VoidCallback? onTap,
    bool showCloseButton = true,
    bool swipeToDismiss = true,
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    _removeCurrent();

    final style = SizzleStyle.of(type);
    final isTop = position == SizzlePosition.top;
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: isTop ? 0 : null,
        bottom: isTop ? null : 0,
        left: 0,
        right: 0,
        child: SafeArea(
          top: isTop,
          bottom: !isTop,
          minimum: EdgeInsets.only(top: isTop ? 8 : 0, bottom: isTop ? 0 : 8),
          child: Align(
            alignment: isTop ? Alignment.topCenter : Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizzleToast(
                  style: style,
                  title: title,
                  message: message,
                  icon: icon ?? style.icon,
                  duration: duration,
                  position: position,
                  showCloseButton: showCloseButton,
                  swipeToDismiss: swipeToDismiss,
                  onTap: onTap,
                  onDismissed: () {
                    if (identical(_current, entry)) {
                      _current = null;
                    }
                    entry.remove();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );

    _current = entry;
    overlay.insert(entry);
  }

  static void _removeCurrent() {
    _current?.remove();
    _current = null;
  }
}
