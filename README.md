# sizzle

Beautiful, animated, customizable toast notifications for Flutter. Drop-in success and error toasts with a premium look and a one-line API.

A sizzle toast is a white, rounded card that slides and fades in from the top: a tinted circular icon chip, a bold title, an optional message, and a close button. It floats above your app through the root overlay, so no `Scaffold` is required at the call site.

<!-- Add a screenshot or GIF here once captured from the example app: -->
<!-- ![sizzle toasts](doc/preview.png) -->

## Install

Add it to your `pubspec.yaml`:

```yaml
dependencies:
  sizzle: ^0.1.0
```

Then import it:

```dart
import 'package:sizzle/sizzle.dart';
```

## Quick start

```dart
Sizzle.show(
  context,
  type: SizzleType.success,
  title: 'Connection Restored',
  message: 'You are back online.',
);
```

Prefer an extension on `BuildContext`? Same result:

```dart
context.sizzle(
  type: SizzleType.error,
  title: 'No Internet Connection',
  message: 'Please check your connection and try again.',
);
```

## Customization

Both `Sizzle.show` and `context.sizzle` take the same options:

| Parameter         | Type           | Default                  | Description                                              |
| ----------------- | -------------- | ------------------------ | -------------------------------------------------------- |
| `title`           | `String`       | required                 | The bold headline.                                       |
| `message`         | `String?`      | `null`                   | The gray line beneath the title.                         |
| `type`            | `SizzleType`   | `SizzleType.success`     | One of `success`, `error`, `warning`, `info`. Sets the accent color and default icon. |
| `duration`        | `Duration`     | `Duration(seconds: 4)`   | Time on screen. Use `Duration.zero` to keep until tapped.|
| `position`        | `SizzlePosition`| `SizzlePosition.top`    | Anchors the toast to the top or bottom; sets the slide direction. |
| `icon`            | `IconData?`    | the type's default       | Overrides the glyph in the icon chip.                    |
| `onTap`           | `VoidCallback?`| `null`                   | Fires when the body is tapped, then dismisses the toast. |
| `showCloseButton` | `bool`         | `true`                   | Toggles the trailing close button.                       |

### Types

Four presets, each with its own accent color and default glyph:

| Type                   | Accent | Default icon          |
| ---------------------- | ------ | --------------------- |
| `SizzleType.success`   | Green  | check                 |
| `SizzleType.error`     | Red    | close                 |
| `SizzleType.warning`   | Amber  | exclamation           |
| `SizzleType.info`      | Blue   | info                  |

Override the icon to match your context:

```dart
Sizzle.show(
  context,
  title: 'Connection Restored',
  message: 'You are back online.',
  icon: Icons.wifi_tethering_rounded,
);
```

### Positioning

Toasts slide in from the top by default. Anchor to the bottom instead, and the slide direction follows:

```dart
Sizzle.show(
  context,
  title: 'Saved to downloads',
  position: SizzlePosition.bottom,
);
```

A toast auto-dismisses after `duration`, or the user can tap the close button. Showing a new toast replaces the one on screen.

## Example

The `example/` app shows every variant. From its directory:

```bash
flutter run
```

## Roadmap

Milestone 1 ships one clean toast at a time. Planned next:

- Stacking with a count badge when toasts pile up.
- Swipe-to-dismiss.
- Full theming of colors, shape, and motion.

## License

MIT. See [LICENSE](LICENSE).
