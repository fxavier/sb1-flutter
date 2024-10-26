import 'package:json_annotation/json_annotation.dart';

part 'image_size.g.dart';

@JsonSerializable()
class ImageSize {
  final String url;
  final int width;
  final int height;

  ImageSize({
    required this.url,
    required this.width,
    required this.height,
  });

  factory ImageSize.fromJson(Map<String, dynamic> json) => _$ImageSizeFromJson(json);
  Map<String, dynamic> toJson() => _$ImageSizeToJson(this);
}