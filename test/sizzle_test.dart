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

Icon _iconNamed(WidgetTester tester, IconData glyph) {
  return tester.widget<Icon>(find.byIcon(glyph));
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

  testWidgets('success renders the green check icon', (tester) async {
    await _showVia(
      tester,
      (c) => Sizzle.show(c, title: 'Saved', duration: Duration.zero),
    );

    final icon = _iconNamed(tester, Icons.check_rounded);
    expect(icon.color, const Color(0xFF1FA463));
  });

  testWidgets('error renders the red close icon', (tester) async {
    await _showVia(
      tester,
      (c) => Sizzle.show(
        c,
        type: SizzleType.error,
        title: 'No Internet Connection',
        duration: Duration.zero,
      ),
    );

    // The chip icon and the close button both use close_rounded for an error
    // toast, so match by the accent color the chip icon carries.
    final colors = tester
        .widgetList<Icon>(find.byIcon(Icons.close_rounded))
        .map((i) => i.color)
        .toList();
    expect(colors, contains(const Color(0xFFE5484D)));
  });

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
