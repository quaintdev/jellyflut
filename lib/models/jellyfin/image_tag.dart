import 'package:epubx/epubx.dart';
import 'package:jellyflut/models/enum/image_type.dart';

class ImageTag {
  final ImageType imageType;
  final String value;

  const ImageTag({required this.imageType, required this.value});

  static List<ImageTag> fromMap(Map<String, dynamic> json) {
    final imageTags = <ImageTag>[];
    json.forEach((key, value) => imageTags.add(ImageTag(
        imageType: EnumFromString<ImageType>(ImageType.values).get(key)!,
        value: value)));
    return imageTags;
  }

  Map<String, dynamic> toMap() =>
      {'ImageType': imageTypeValues.reverse[imageType], 'value': value};
}
