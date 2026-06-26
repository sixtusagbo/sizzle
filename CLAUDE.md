# sizzle — Claude Code Instructions

Ground rules and conventions for Claude Code (and any other AI coding tool) working in this repo. `sizzle` is a Flutter/Dart package of beautiful, animated, customizable toast notifications, headed for pub.dev. The look (shape, shadow, motion, color, icon treatment) is the whole point of the package.

## How to work

Do the whole thing and do it right: tests, docs, the permanent fix over the workaround. Ship the finished product, not a plan to build it. Before calling anything done, be able to explain why the code is correct and where it would break. Tests passing is not understanding.

## Search before building

In order: tried-and-true (standard Flutter widgets and patterns) first, then new-and-popular, then first-principles only if genuinely different (document why). Look at how `toastification` and `motion_toast` shape their APIs for prior art, then improve on it. Don't copy code or visuals from other packages.

## Build and verify commands

```bash
flutter pub get                    # install deps
flutter analyze                    # lint, must be zero issues
dart format .                      # format (run before committing)
flutter test                       # run widget tests
flutter pub publish --dry-run      # publish readiness check
cd example && flutter run          # run the demo app
```

## Project rules

- Let me (Sixtus) test before you mark any phase or feature complete.
- One feature at a time. No scope creep. Get one gorgeous toast variant looking exactly like the reference and shipping cleanly before adding more variants, queueing, positioning, swipe-to-dismiss, theming, etc.
- The design reference (LinkedIn screenshots) lives locally only, excluded via `.git/info/exclude`. They are third-party copyrighted; never commit or publish them.

## Architecture

Single Flutter package. Public API in `lib/sizzle.dart` (barrel file, exports only). Implementation in `lib/src/`. Toasts render through an `Overlay` so they float above app content without needing a `Scaffold`.

Public entry points (both forward to the same code path):
- `Sizzle.show(context, type: ..., title: ..., message: ...)`
- `context.sizzle(type: ..., title: ..., message: ...)` (BuildContext extension)

## Project structure

```
lib/
  sizzle.dart            # public barrel: exports the API surface only
  src/
    sizzle.dart          # Sizzle.show entry + overlay insertion
    sizzle_context.dart  # BuildContext extension
    sizzle_type.dart     # SizzleType enum (success, error, ...)
    sizzle_style.dart    # colors/icons/config per type
    widgets/             # toast card + sub-widgets (real classes, not functions)
test/                    # widget tests, mirror lib/ structure
example/                 # demo app, every variant on a button
```

## Code quality

**Naming:** `PascalCase` classes, `camelCase` members, `snake_case` files. Descriptive names, no abbreviations.

**Critical rules:**
- DRY above all, including in tests. Removing duplication is priority one, even over shipping faster.
- Build UI from real widget classes, never ad-hoc functions returning Widgets.

**Size limits:** UI files 200-250 lines max (split them). Functions 20-50 lines max (extract helpers).

**Public API:** dartdoc comment every public member. This drives the pub.dev score.

## Tests

- Tests ship in the **same commit** as the feature, never the next one.
- Every bug fix ships with a regression test that would have caught it.
- Cover show, auto-dismiss timeout, tap-to-dismiss, and per-type rendering. Deterministic, fast, no flakiness.
- No duplication: factor shared setup into a helper, do not copy-paste test bodies.

## Verification workflow (before "done")

1. `flutter analyze` (zero issues)  2. `dart format .`  3. `flutter test` (green)  4. `flutter pub publish --dry-run` clean  5. Sixtus confirms the look on a device.

Run 1-4 automatically after implementing a feature. Step 5 is Sixtus's.

## Commits and git

- Commit atomically as you go: one logical change per commit, each builds and stands alone. No need to ask before each commit.
- **NEVER run `git push`.** Sixtus pushes.
- Commit messages: capital-letter plain statement, no `feat:`/`fix:` prefixes, no multi-paragraph stories.
- **NEVER** add `Co-Authored-By`, "Generated with Claude", or any attribution.
- Local-only ignores go in `.git/info/exclude`, not the committed `.gitignore` (which carries only build artifacts everyone should ignore).

## Style

- No emojis in the codebase or docs. No em-dashes anywhere. No AI-prose filler (delve, crucial, robust, comprehensive, seamless, etc.).
- Direct, short, concrete. Reference specific files and lines.

## pub.dev publishing checklist

- `pubspec.yaml`: name `sizzle`, description 60-180 chars, `repository`/`homepage`, version, SDK constraints.
- `README.md` with a GIF/screenshot, install snippet, quick-start, customization section.
- `CHANGELOG.md` entry per version. `LICENSE` (MIT).
- `example/` app demonstrating every variant.
- Dartdoc on all public API. `flutter pub publish --dry-run` clean.
- Re-check the name is free: `https://pub.dev/packages/sizzle` returning 404 means still free.

## Completion status

End every task with one of: **DONE** (all steps done, evidence given, tests in the diff), **DONE_WITH_CONCERNS** (list each with severity + follow-up), **BLOCKED** (what's blocking, what you tried), **NEEDS_CONTEXT** (what's missing). "Partially done" is not a status.
