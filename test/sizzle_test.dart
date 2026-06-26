import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizzle/sizzle.dart';

/// Pumps a minimal app whose single button runs [action] with its context.
Widget _host(void Function(BuildContext context) action) {
  return MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => action(context),
          child: const Text('show'),
        ),
      ),
    ),
  );
}

/// Pumps the host, taps the button, and settles the entrance animation.
Future<void> _showVia(
  WidgetTester tester,
  void Function(BuildContext context) action,
) async {
  await tester.pumpWidget(_host(action));
  await tester.tap(find.text('show'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  testWidgets('shows the title and message', (tester) async {
    await _showVia(
      tester,
      (c) => Sizzle.show(
        c,
        title: 'Connection Restored',
        message: 'You are back online.',
        duration: Duration.zero,
      ),
    );

    expect(find.text('Connection Restored'), findsOneWidget);
    expect(find.text('You are back online.'), findsOneWidget);
  });

  // Each type renders its glyph in its accent color. Matching by `contains`
  // covers the error case, where the chip glyph and the close button share
  // close_rounded.
  const typeCases = <(SizzleType, IconData, Color)>[
    (SizzleType.success, Icons.check_rounded, Color(0xFF1FA463)),
    (SizzleType.error, Icons.close_rounded, Color(0xFFE5484D)),
    (SizzleType.warning, Icons.priority_high_rounded, Color(0xFFE8910A)),
    (SizzleType.info, Icons.info_outline_rounded, Color(0xFF2D7FF9)),
  ];
  for (final (type, glyph, accent) in typeCases) {
    testWidgets('${type.name} renders its accent glyph', (tester) async {
      await _showVia(
        tester,
        (c) => Sizzle.show(c, type: type, title: 'X', duration: Duration.zero),
      );

      final colors = tester
          .widgetList<Icon>(find.byIcon(glyph))
          .map((i) => i.color)
          .toList();
      expect(colors, contains(accent));
    });
  }

  // The toast anchors to its position: top toasts sit in the upper half of the
  // screen, bottom toasts in the lower half.
  const positionCases = <(SizzlePosition, bool)>[
    (SizzlePosition.top, true),
    (SizzlePosition.bottom, false),
  ];
  for (final (position, inUpperHalf) in positionCases) {
    testWidgets('${position.name} position anchors the toast', (tester) async {
      await _showVia(
        tester,
        (c) => Sizzle.show(
          c,
          title: 'Saved',
          position: position,
          duration: Duration.zero,
        ),
      );

      final mid = tester.getSize(find.byType(MaterialApp)).height / 2;
      final dy = tester.getCenter(find.text('Saved')).dy;
      expect(inUpperHalf ? dy < mid : dy > mid, isTrue);
    });
  }

  testWidgets('a custom icon overrides the type default', (tester) async {
    await _showVia(
      tester,
      (c) => Sizzle.show(
        c,
        title: 'Online',
        icon: Icons.wifi_tethering,
        duration: Duration.zero,
      ),
    );

    expect(find.byIcon(Icons.wifi_tethering), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsNothing);
  });

  testWidgets('auto-dismisses after the duration', (tester) async {
    await _showVia(
      tester,
      (c) =>
          Sizzle.show(c, title: 'Saved', duration: const Duration(seconds: 2)),
    );
    expect(find.text('Saved'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Saved'), findsNothing);
  });

  testWidgets('tapping the close button dismisses it', (tester) async {
    await _showVia(
      tester,
      (c) => Sizzle.show(c, title: 'Saved', duration: Duration.zero),
    );

    // success chip uses check_rounded, so close_rounded is the close button.
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Saved'), findsNothing);
  });

  testWidgets('hides the close button when asked', (tester) async {
    await _showVia(
      tester,
      (c) => Sizzle.show(
        c,
        title: 'Saved',
        showCloseButton: false,
        duration: Duration.zero,
      ),
    );

    expect(find.byIcon(Icons.close_rounded), findsNothing);
  });

  testWidgets('swiping the toast horizontally dismisses it', (tester) async {
    await _showVia(
      tester,
      (c) => Sizzle.show(c, title: 'Saved', duration: Duration.zero),
    );

    await tester.drag(find.text('Saved'), const Offset(500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Saved'), findsNothing);
  });

  testWidgets('swipe does nothing when swipeToDismiss is false', (
    tester,
  ) async {
    await _showVia(
      tester,
      (c) => Sizzle.show(
        c,
        title: 'Saved',
        duration: Duration.zero,
        swipeToDismiss: false,
      ),
    );

    await tester.drag(find.text('Saved'), const Offset(500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Saved'), findsOneWidget);
  });

  testWidgets('tapping the body fires onTap and dismisses', (tester) async {
    var tapped = false;
    await _showVia(
      tester,
      (c) => Sizzle.show(
        c,
        title: 'Saved',
        duration: Duration.zero,
        onTap: () => tapped = true,
      ),
    );

    await tester.tap(find.text('Saved'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(tapped, isTrue);
    expect(find.text('Saved'), findsNothing);
  });

  testWidgets('showing a new toast replaces the current one', (tester) async {
    var second = false;
    await tester.pumpWidget(
      _host(
        (c) =>
            Sizzle.show(c, title: second ? 'B' : 'A', duration: Duration.zero),
      ),
    );

    await tester.tap(find.text('show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('A'), findsOneWidget);

    second = true;
    await tester.tap(find.text('show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('A'), findsNothing);
    expect(find.text('B'), findsOneWidget);
  });

  testWidgets('context.sizzle shows a toast', (tester) async {
    await _showVia(
      tester,
      (c) => c.sizzle(title: 'From extension', duration: Duration.zero),
    );

    expect(find.text('From extension'), findsOneWidget);
  });
}
