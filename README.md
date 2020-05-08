<<<<<<< HEAD
# mxxd

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## create .arb from localization.dart

```
flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/localizations.dart
```

## create intl_messages_xx.dart from .arb

```
flutter pub pub run intl_translation:generate_from_arb lib/localizations.dart lib/l10n/*.arb --output-dir=lib/l10n
```
=======
# Hello-word
>>>>>>> 515ad0e4aee717a370083f85e1ea93af6639270e
