import 'package:flutter/material.dart';

import '../sizzle_style.dart';
import 'sizzle_icon_chip.dart';

/// The static visual of a toast: a white, rounded card with a tinted icon
/// chip, a bold title, an optional gray message, and an optional close button.
///
/// Pure presentation. It does not animate or manage timing; [SizzleToast]
/// wraps it for that.
class SizzleCard extends StatelessWidget {
  const SizzleCard({
    super.key,
    required this.style,
    required this.title,
    required this.icon,
    required this.showCloseButton,
    required this.onClose,
    this.message,
  });

  /// The resolved colors for this toast's type.
  final SizzleStyle style;

  /// Bold headline text.
  final String title;

  /// The glyph shown in the icon chip.
  final IconData icon;

  /// Whether to render the trailing close button.
  final bool showCloseButton;

  /// Invoked when the close button is tapped.
  final VoidCallback onClose;

  /// Optional secondary line under the title.
  final String? message;

  static const Color _titleColor = Color(0xFF15161A);
  static const Color _messageColor = Color(0xFF8E929B);
  static const Color _closeColor = Color(0xFF4A4D55);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(22)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 30,
            spreadRadius: -6,
            offset: Offset(0, 12),
          ),
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SizzleIconChip(style: style, icon: icon),
          const SizedBox(width: 14),
          Expanded(child: _text()),
          if (showCloseButton) ...[const SizedBox(width: 8), _closeButton()],
        ],
      ),
    );
  }

  Widget _text() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w700,
            color: _titleColor,
            height: 1.2,
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 3),
          Text(
            message!,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: _messageColor,
              height: 1.25,
            ),
          ),
        ],
      ],
    );
  }

  Widget _closeButton() {
    return InkResponse(
      onTap: onClose,
      radius: 22,
      child: const Padding(
        padding: EdgeInsets.all(2),
        child: Icon(Icons.close_rounded, size: 20, color: _closeColor),
      ),
    );
  }
}
