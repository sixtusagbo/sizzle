import 'package:flutter/material.dart';
import 'package:sizzle/sizzle.dart';

void main() => runApp(const SizzleExampleApp());

class SizzleExampleApp extends StatelessWidget {
  const SizzleExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'sizzle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF4F5F7)),
      home: const HomePage(),
    );
  }
}

/// One demo: a label and the toast it shows.
class Demo {
  const Demo(this.label, this.show);

  final String label;
  final void Function(BuildContext context) show;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  List<Demo> get _demos => [
    Demo(
      'Success preset',
      (c) =>
          Sizzle.show(c, title: 'Saved', message: 'Your changes were saved.'),
    ),
    Demo(
      'Error preset',
      (c) => Sizzle.show(
        c,
        type: SizzleType.error,
        title: 'Upload failed',
        message: 'Something went wrong. Try again.',
      ),
    ),
    Demo(
      'Warning preset',
      (c) => Sizzle.show(
        c,
        type: SizzleType.warning,
        title: 'Storage almost full',
        message: 'Free up space to keep syncing.',
      ),
    ),
    Demo(
      'Info preset',
      (c) => Sizzle.show(
        c,
        type: SizzleType.info,
        title: 'Update available',
        message: 'Version 2.1 is ready to install.',
      ),
    ),
    Demo(
      'Connection restored (custom icon)',
      (c) => Sizzle.show(
        c,
        title: 'Connection Restored',
        message: 'You are back online.',
        icon: Icons.wifi_tethering_rounded,
      ),
    ),
    Demo(
      'No internet (custom icon)',
      (c) => Sizzle.show(
        c,
        type: SizzleType.error,
        title: 'No Internet Connection',
        message: 'Please check your connection and try again.',
        icon: Icons.wifi_off_rounded,
      ),
    ),
    Demo(
      'Title only, no close button',
      (c) => Sizzle.show(
        c,
        title: 'Copied to clipboard',
        showCloseButton: false,
        duration: const Duration(seconds: 2),
      ),
    ),
    Demo(
      'Bottom position',
      (c) => Sizzle.show(
        c,
        type: SizzleType.info,
        title: 'Saved to downloads',
        message: 'Tap to open the file.',
        position: SizzlePosition.bottom,
      ),
    ),
    Demo(
      'Tappable, via context.sizzle',
      (c) => c.sizzle(
        title: 'Update available',
        message: 'Tap to install the latest version.',
        onTap: () {},
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'sizzle',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              const Text(
                'Tap a button to fire a toast.',
                style: TextStyle(fontSize: 15, color: Color(0xFF6B6F76)),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: ListView.separated(
                  itemCount: _demos.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, i) => DemoButton(demo: _demos[i]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A full-width button that fires its demo's toast.
class DemoButton extends StatelessWidget {
  const DemoButton({super.key, required this.demo});

  final Demo demo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => demo.show(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF15161A),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 18),
          alignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          demo.label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
