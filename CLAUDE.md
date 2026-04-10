# CLAUDE.md

## Project Overview

**story_maker** is a Flutter package (v1.2.0) for creating Instagram-like stories with image editing, text overlays, stickers, color filters, and gradient backgrounds. Published to pub.dev under the MIT license.

- **Language**: Dart 3.0.0+
- **Framework**: Flutter 3.0.0+
- **Platforms**: iOS, Android

## Repository Structure

```
lib/
├── story_maker.dart              # Main entry point: StoryMaker StatefulWidget + exports
├── controller/                   # State management
│   ├── controller.dart           # Barrel export
│   └── src/
│       └── story_maker_controller.dart  # ValueNotifier-based state controller
├── components/                   # Reusable UI widgets (all StatelessWidget)
│   ├── components.dart           # Barrel export
│   └── src/
│       ├── background_gradient_selector_widget.dart
│       ├── font_family_select_widget.dart
│       ├── footer_tools_widget.dart
│       ├── overlay_item_widget.dart
│       ├── remove_widget.dart
│       ├── size_slider_widget.dart
│       ├── sticker_selector_widget.dart
│       ├── text_color_select_widget.dart
│       ├── text_field_widget.dart
│       └── top_tools_widget.dart
├── constants/                    # Enums, palettes, gradients, stickers
│   ├── constants.dart            # Barrel export
│   └── src/
│       ├── color_filters.dart    # ColorFilterType enum with matrix/displayName methods
│       ├── font_colors.dart      # Default text colors
│       ├── font_styles.dart      # Default Google Fonts list
│       ├── gradients.dart        # 50+ gradient presets
│       ├── item_type.dart        # ItemType enum (IMAGE, TEXT, STICKER)
│       ├── stickers.dart         # 48 emoji stickers
│       └── ui_constants.dart     # UI magic numbers
├── models/                       # Data models
│   ├── models.dart               # Barrel export
│   └── src/
│       ├── editable_items.dart   # EditableItem (immutable, with copyWith)
│       └── sticker_item.dart     # StickerItem (emoji or image/GIF)
├── theme/                        # Theming system
│   ├── theme.dart                # Barrel export
│   └── src/
│       ├── story_maker_theme.dart           # StoryMakerTheme config class
│       └── story_maker_theme_provider.dart  # InheritedWidget provider
├── extensions/                   # Dart extensions
│   ├── extensions.dart           # Barrel export
│   └── src/
│       └── context_extension.dart  # BuildContext helpers
└── utils/                        # Utilities
    ├── utils.dart                # Barrel export
    └── src/
        └── gradient_util.dart    # Shader creation
example/                          # Example Flutter app
test/                             # Tests (placeholder)
```

## Common Commands

```bash
# Get dependencies
flutter pub get

# Run static analysis
flutter analyze

# Run tests
flutter test

# Run the example app
cd example && flutter run

# Format code (uses dart format)
dart format .

# Dry-run publish check
flutter pub publish --dry-run
```

## Architecture & Patterns

### Barrel Export Pattern

Every directory under `lib/` has a barrel file (e.g., `components/components.dart`) that re-exports its `src/` contents. Always:
- Add new files inside the `src/` subdirectory
- Export them from the barrel file
- Import via barrel files, never directly from `src/`

### State Management

- **ValueNotifier + ValueListenableBuilder** — all mutable state lives in `StoryMakerController` as individual `ValueNotifier` instances. The main widget uses `ValueListenableBuilder` to scope rebuilds to only the widgets that depend on each piece of state.
- **No setState** — the codebase has zero `setState` calls. All state mutations go through `ValueNotifier.value = ...` on the controller.
- **Theme propagation** via `InheritedWidget` (`StoryMakerThemeProvider`)

### StoryMakerController

`lib/controller/src/story_maker_controller.dart` owns all mutable state:

| ValueNotifier | Type | Purpose |
|---|---|---|
| `stackData` | `List<EditableItem>` | All items on the canvas |
| `activeItem` | `EditableItem?` | Currently selected item |
| `isTextInput` | `bool` | Text editing mode |
| `isDeletePosition` | `bool` | Item over delete zone |
| `selectedTextColor` | `Color` | Current text color |
| `selectedTextBackgroundGradient` | `int` | Text background gradient index |
| `selectedFontSize` | `double` | Font size |
| `selectedFontFamily` | `int` | Font family index |
| `isColorPickerSelected` | `bool` | Text color picker visibility |
| `isBackgroundColorPickerSelected` | `bool` | Background gradient picker visibility |
| `isStickerPickerSelected` | `bool` | Sticker picker visibility |
| `isColorFilterPickerSelected` | `bool` | Color filter picker visibility |
| `selectedColorFilter` | `ColorFilterType` | Active color filter |
| `selectedBackgroundGradient` | `int` | Background gradient index |
| `isLoading` | `bool` | Export loading state |
| `displayedStyleName` | `String?` | Temporary style name overlay |
| `displayedFilterName` | `String?` | Temporary filter name overlay |

Non-reactive state (gesture tracking: `_initPos`, `_currentPos`, `_currentScale`, `_currentRotation`, `_inAction`) stays as plain fields since they don't drive UI rebuilds.

### Main Entry Point

`StoryMaker` widget in `lib/story_maker.dart` is the primary public API. It accepts:
- `filePath` (required) — path to the image to edit
- `theme` — optional `StoryMakerTheme` for full visual customization
- `customFontList`, `customTextColors`, `customGradients`, `customStickers` — override defaults
- `doneButtonBuilder` — custom done button with theme, callback, and loading state

### Immutable Models

`EditableItem` is `@immutable` with `const` constructor, `copyWith()`, and `==`/`hashCode`. To update an item, create a new copy and replace it in the list:
```dart
final updated = item.copyWith(position: newPos);
final items = List<EditableItem>.from(stackData.value);
items[idx] = updated;
stackData.value = items;
```

### Public API Surface

Exported classes: `StoryMaker`, `StoryMakerController`, `EditableItem`, `StickerItem`, `StoryMakerTheme`, `StoryMakerThemeProvider`, `ColorFilterType`, `ItemType`

### ColorFilterType Enum

Filters expose their data via enum methods — no free functions needed:
```dart
filter.matrix       // List<double> color matrix
filter.displayName  // Human-readable name
```

## Code Style & Conventions

### Enforced by analysis_options.yaml

- **Single quotes** (`prefer_single_quotes`) — always use single quotes for strings
- **Trailing commas** (`require_trailing_commas`) — required on all multi-line argument lists
- **Relative imports** (`prefer_relative_imports`) — use relative imports within the package
- **Const constructors** (`prefer_const_constructors`) — use `const` wherever possible
- **Final locals** (`prefer_final_locals`, `prefer_final_in_for_each`) — prefer `final` for local variables
- **No print statements** (`avoid_print`) — use `dart:developer` `log()` instead
- **Always declare return types** (`always_declare_return_types`)
- **Use key in widget constructors** (`use_key_in_widget_constructors`)
- **Avoid void async** (`avoid_void_async`) — async functions should return `Future<void>`
- **No logic in createState** (`no_logic_in_create_state`)

### Severity Escalations (errors, not warnings)

These lint violations are treated as **errors** and will fail analysis:
`invalid_assignment`, `duplicate_import`, `unused_import`, `unused_local_variable`, `dead_code`, `avoid_print`, `cancel_subscriptions`, `close_sinks`, `cascade_invocations`, `implementation_imports`, `prefer_relative_imports`, `prefer_single_quotes`, `require_trailing_commas`

### Additional Conventions

- Widget constructors use `super.key` (not `Key? key`)
- Use `camelCase` for variables/methods, `PascalCase` for classes/enums
- No code generation — all models are hand-written
- Avoid `dynamic` types (`avoid_annotating_with_dynamic`)
- Use `omit_local_variable_types` — let Dart infer local types
- All component widgets are `StatelessWidget` — state flows in via constructor params from `ValueListenableBuilder`

## Dependencies

| Package | Purpose |
|---|---|
| `path_provider` | File system access for saving edited images |
| `google_fonts` | Google Fonts integration for text styling |
| `photo_view` | Image viewing with zoom/pan gestures |

Dev: `flutter_test` (standard Flutter testing framework)

## Testing

Tests live in `test/`. Currently a placeholder exists at `test/story_maker_test.dart`. Run with `flutter test`.

When adding tests:
- Use `flutter_test` framework with `testWidgets` for widget tests
- Follow the existing file naming: `<feature>_test.dart`

## Git Conventions

- Default branch: `master`
- Commit message style: `type: Description` (e.g., `feat:`, `fix:`, `refactor:`)
- Versioning tracked in `pubspec.yaml` and `CHANGELOG.md`
