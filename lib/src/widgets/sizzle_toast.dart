import 'dart:async';

import 'package:flutter/material.dart';

import '../sizzle_position.dart';
import '../sizzle_style.dart';
import 'sizzle_card.dart';

/// Wraps [SizzleCard] with entrance/exit motion and auto-dismiss timing.
///
/// It slides and fades in from the toast's [position], holds for [duration],
/// then reverses and calls [onDismissed] so the overlay entry can be removed.
/// The close button, an optional body tap, and a horizontal swipe (when
/// [swipeToDismiss] is set) dismiss it early.
class SizzleToast extends StatefulWidget {
  const SizzleToast({
    super.key,
    required this.style,
    required this.title,
    required this.icon,
    required this.duration,
    required this.position,
    required this.showCloseButton,
    required this.swipeToDismiss,
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

  /// Which edge the toast is anchored to; sets the slide-in direction.
  final SizzlePosition position;

  /// Whether the close button is shown.
  final bool showCloseButton;

  /// Whether a horizontal swipe flings the toast away.
  final bool swipeToDismiss;

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

  // The swipe already animates the card off-screen, so skip the reverse and
  // just drop the overlay entry.
  void _handleSwipe() {
    _dismissing = true;
    _timer?.cancel();
    widget.onDismissed();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final beginOffset = widget.position == SizzlePosition.top
        ? const Offset(0, -1)
        : const Offset(0, 1);
    final slide = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(_animation);
    return SlideTransition(
      position: slide,
      child: FadeTransition(
        opacity: _animation,
        child: Material(
          color: Colors.transparent,
          child: _wrapSwipe(
            GestureDetector(
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
      ),
    );
  }

  Widget _wrapSwipe(Widget child) {
    if (!widget.swipeToDismiss) return child;
    return Dismissible(
      key: const ValueKey('sizzle-toast'),
      direction: DismissDirection.horizontal,
      resizeDuration: null,
      onDismissed: (_) => _handleSwipe(),
      child: child,
    );
  }
}
