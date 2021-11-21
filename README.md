# story_maker    [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A package for creating instagram like story, you can use this package to edit images and make it story ready by adding other contents over it like text and gradients.

![GIF 1](https://github.com/NarekManukyan/story_maker/raw/master/showcase1.GIF)
![GIF 2](https://github.com/NarekManukyan/story_maker/raw/master/showcase2.GIF)

## Getting Started

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  story_maker: ^1.0.2
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

### Available for use now
- [x] Image scaling
- [x] Rotate the image
- [x] Adding text to an image
- [x] Choosing text size, font family, and color
- [x] Selecting gradients for text background
- [x] Selecting gradients for the background of the image

### To be added

- [ ] Customize text font list
- [ ] Customize the list of text colors
- [ ] Customize gradient color list
- [ ] Adding stickers
- [ ] Adding color filters
- [ ] Animations for text
- [ ] Export GIF


[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/narek.manukyan)
