import 'package:json_annotation/json_annotation.dart';

part 'product_image.g.dart';

@JsonSerializable()
class ProductImage {
  final String id;
  final String url;
  final bool isCover;
  final String? alt;
  final int sortOrder;

  ProductImage({
    required this.id,
    required this.url,
    required this.isCover,
    this.alt,
    required this.sortOrder,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) => _$ProductImageFromJson(json);
  Map<String, dynamic> toJson() => _$ProductImageToJson(this);
}