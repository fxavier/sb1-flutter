import 'package:json_annotation/json_annotation.dart';

part 'category_image.g.dart';

@JsonSerializable()
class CategoryImage {
  final String id;
  final String url;
  final String? alt;
  final ImageSize thumbnail;
  final ImageSize medium;
  final ImageSize large;

  CategoryImage({
    required this.id,
    required this.url,
    this.alt,
    required this.thumbnail,
    required this.medium,
    required this.large,
  });

  factory CategoryImage.fromJson(Map<String, dynamic> json) => _$CategoryImageFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryImageToJson(this);
}