## [1.0.0] - 10/11/2021.

* First release version.

## [1.0.1] - 10/11/2021.

* Improved the quality of the edited image.

## [1.0.2] - 21/11/2021.

* Fixed aspect ratio issues.

## [1.0.3] - 23/11/2021.

* Fixed widgets positions for small devices.
## [1.0.4] - 27/07/2022.

* Updated libraries.
* Fixed some bugs.

## [1.0.5] - 4/12/2023

* Updated Dart and Pub dependencies.
* Improved code documentation.
* Fixed various bugs and issues.
* Optimized code for better performance.
* Updated example app.

## [1.1.0] - 2024

### Major Features Added
* **Stickers Support**: Added comprehensive sticker functionality with emoji and image/GIF support
  - Support for emoji stickers (default set of 50+ emojis)
  - Support for custom image/GIF stickers via `StickerItem` class
  - Customizable sticker list via `customStickers` parameter
  - Sticker selector widget with horizontal scrolling interface

* **Color Filters**: Added 8 color filter options for image enhancement
  - Sepia, Grayscale, Vintage, Cool, Warm, Bright, Dark filters
  - Swipe left/right gesture support for quick filter navigation
  - Filter name overlay display when selecting filters
  - Color filter picker with visual preview

* **Theme Customization System**: Complete theming support for StoryMaker
  - `StoryMakerTheme` class for comprehensive UI customization
  - Customizable colors, borders, shadows, and border radius
  - Pre-built dark and light theme variants
  - Theme provider system for easy access throughout widget tree
  - Support for custom button styles and decorations

* **Custom Done Button Builder**: Added flexibility for custom done button implementation
  - `doneButtonBuilder` parameter for complete control over done button appearance
  - Access to theme, onDone callback, and loading state

### Improvements
* **UI Constants**: Centralized all magic numbers and UI constants in `ui_constants.dart`
  - Viewport fractions, position thresholds, font size constraints
  - Better maintainability and easier configuration

* **Enhanced User Experience**:
  - Style name overlay when changing font families
  - Filter name overlay when changing color filters
  - Haptic feedback on color and filter selection
  - Improved gesture handling for filter navigation

* **Code Quality**:
  - Better code organization with new utility files
  - Improved documentation throughout the codebase
  - Enhanced type safety with new model classes (`StickerItem`)

### New Files
* `lib/components/sticker_selector_widget.dart` - Sticker selection UI
* `lib/components/text_animation_selector_widget.dart` - Text animation selector (prepared for future use)
* `lib/constants/color_filters.dart` - Color filter definitions and matrices
* `lib/constants/stickers.dart` - Default sticker emoji list
* `lib/constants/text_animations.dart` - Text animation type definitions
* `lib/constants/ui_constants.dart` - Centralized UI constants
* `lib/models/sticker_item.dart` - Sticker item model class
* `lib/theme/story_maker_theme.dart` - Theme customization class
* `lib/theme/story_maker_theme_provider.dart` - Theme provider widget
* `lib/utils/animation_util.dart` - Animation utility functions

### Breaking Changes
* None - All new features are backward compatible

### Notes
* Text animations infrastructure is prepared but not yet fully integrated into the main editor
