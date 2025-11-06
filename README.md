# story_maker    [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A package for creating instagram like story, you can use this package to edit images and make it story ready by adding other contents over it like text, stickers, gradients, and color filters.

![GIF 1](https://github.com/NarekManukyan/story_maker/raw/master/showcase1.GIF)
![GIF 2](https://github.com/NarekManukyan/story_maker/raw/master/showcase2.GIF)

## Getting Started

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  story_maker: ^1.1.0
```

## Example
```dart
import 'package:story_maker/story_maker.dart';

class _MyAppState extends State<MyApp> {
  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Designer Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await [
                  Permission.photos,
                  Permission.storage,
                ].request();
                final picker = ImagePicker();
                await picker
                    .pickImage(source: ImageSource.gallery)
                    .then((file) async {
                  final File editedFile = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => StoryMaker(
                        filePath: file!.path,
                      ),
                    ),
                  );
                  setState(() {
                    image = editedFile;
                  });
                  print('editedFile: ${image!.path}');
                });
              },
              child: const Text('Pick Image'),
            ),
            if (image != null)
              Expanded(
                child: Image.file(image!),
              ),
          ],
        ),
      ),
    );
  }
}

```

### Advanced Usage with Customization
```dart
import 'package:story_maker/story_maker.dart';

// Example with custom theme, stickers, and done button
StoryMaker(
  filePath: imagePath,
  theme: StoryMakerTheme.dark(), // or StoryMakerTheme.light()
  customStickers: [
    StickerItem.emoji('🎉'),
    StickerItem.emoji('🔥'),
    StickerItem.image('/path/to/sticker.png'),
  ],
  customFontList: ['Roboto', 'Open Sans', 'Lato'],
  customTextColors: [
    Colors.red,
    Colors.blue,
    Colors.green,
  ],
  customGradients: [
    [Colors.purple, Colors.pink],
    [Colors.blue, Colors.cyan],
  ],
  doneButtonBuilder: (theme, onDone, isLoading) {
    return ElevatedButton(
      onPressed: isLoading ? null : onDone,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(theme.buttonColor),
      ),
      child: isLoading
          ? CircularProgressIndicator()
          : Text('Save Story', style: TextStyle(color: theme.buttonTextColor)),
    );
  },
)
```

### Available Features

#### Core Features
- [x] Image scaling and rotation
- [x] Adding text to images with customizable:
  - Font family (with 50+ Google Fonts)
  - Font size (adjustable slider)
  - Text color (extensive color palette)
  - Text background gradients
- [x] Background gradients for images
- [x] Stickers support:
  - Emoji stickers (50+ default emojis)
  - Custom image/GIF stickers
  - Customizable sticker list
- [x] Color filters:
  - Sepia, Grayscale, Vintage
  - Cool, Warm, Bright, Dark
  - Swipe gestures for quick filter navigation
- [x] Theme customization:
  - Complete UI theming system
  - Pre-built dark and light themes
  - Customizable colors, borders, shadows
- [x] Custom done button builder
- [x] Customizable font lists
- [x] Customizable text color lists
- [x] Customizable gradient color lists


[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/narek.manukyan)
