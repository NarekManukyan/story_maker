/// Represents a sticker item that can be displayed.
///
/// A sticker can be either an emoji string or an image/GIF path.
class StickerItem {
  /// The value of the sticker.
  ///
  /// If [isImage] is false, this is an emoji string.
  /// If [isImage] is true, this is a file path or URL to an image/GIF.
  final String value;

  /// Whether this sticker is an image/GIF (true) or an emoji (false).
  final bool isImage;

  /// Creates a sticker item from an emoji string.
  StickerItem.emoji(this.value) : isImage = false;

  /// Creates a sticker item from an image/GIF path.
  StickerItem.image(this.value) : isImage = true;

  @override
  String toString() => value;
}
