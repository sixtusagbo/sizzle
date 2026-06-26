# Contributing to sizzle

Thanks for your interest in improving sizzle. This is a small Flutter package, so the process is light.

## Getting started

```bash
git clone https://github.com/sixtusagbo/sizzle.git
cd sizzle
flutter pub get
```

Run the demo to see your changes:

```bash
cd example
flutter run
```

## Before you open a pull request

Run the same checks CI runs, and make sure they pass:

```bash
dart format .          # format
flutter analyze        # zero issues
flutter test           # all green
```

Guidelines:

- One change per pull request. Keep it focused.
- New behavior ships with tests in the same pull request.
- No duplicated code, including in tests.
- Match the existing style: no emojis or em-dashes in code, comments, or docs.
- Public API needs dartdoc comments.

## Reporting bugs and ideas

Open an issue at https://github.com/sixtusagbo/sizzle/issues with steps to reproduce, what you expected, and what happened. A minimal code snippet helps a lot.

By contributing, you agree your work is licensed under the project's [MIT License](LICENSE).
