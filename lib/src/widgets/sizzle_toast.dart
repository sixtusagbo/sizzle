import 'dart:async';

import 'package:flutter/material.dart';

import '../sizzle_style.dart';
import 'sizzle_card.dart';

/// Wraps [SizzleCard] with entrance/exit motion and auto-dismiss timing.
///
/// It slides and fades down from the top on show, holds for [duration], then
/// reverses and calls [onDismissed] so the overlay entry can be removed. The
/// close button and (optional) body tap dismiss it early.
class SizzleToast extends StatefulWidget {
  const SizzleToast({
    super.key,
    required this.style,
    required this.title,
    required this.icon,
    required this.duration,
    required this.showCloseButton,
    required this.onDismissed,
    this.message,
    this.onTap,
  });

  /// Resolved colors for the toast's type.
  final SizzleStyle style;

  /// Bold headline text.
  final String title;

  /// Glyph shown in the icon chip.
  final IconData icon;

  /// How long the toast stays before auto-dismissing. [Duration.zero] disables
  /// the timer so it stays until dismissed by tap.
  final Duration duration;

  /// Whether the close button is shown.
  final bool showCloseButton;

  /// Called once the exit animation completes; removes the overlay entry.
  final VoidCallback onDismissed;

  /// Optional secondary line under the title.
  final String? message;

  /// Optional callback for a tap on the toast body. When provided, the tap
  /// fires this and then dismisses the toast.
  final VoidCallback? onTap;

  @override
  State<SizzleToast> createState() => _SizzleToastState();
}

class _SizzleToastState extends State<SizzleToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  Timer? _timer;
  bool _dismissing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
      reverseDuration: const Duration(milliseconds: 280),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _controller.forward();
    if (widget.duration > Duration.zero) {
      _timer = Timer(widget.duration, _dismiss);
    }
  }

  void _dismiss() {
    if (_dismissing) return;
    _dismissing = true;
    _timer?.cancel();
    _controller.reverse().whenComplete(widget.onDismissed);
  }

  void _handleTap() {
    widget.onTap!.call();
    _dismiss();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(_animation);
    return SlideTransition(
      position: slide,
      child: FadeTransition(
        opacity: _animation,
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: widget.onTap == null ? null : _handleTap,
            child: SizzleCard(
              style: widget.style,
              title: widget.title,
              message: widget.message,
              icon: widget.icon,
              showCloseButton: widget.showCloseButton,
              onClose: _dismiss,
            ),
          ),
        ),
      ),
    );
  }
}
