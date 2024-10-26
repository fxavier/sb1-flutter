import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  final String id;
  final String name;
  final String? description;
  final CategoryImage image;
  final String? parentId;
  final List<String>? subCategoryIds;
  final bool isActive;

  Category({
    required this.id,
    required this.name,
    this.description,
    required this.image,
    this.parentId,
    this.subCategoryIds,
    this.isActive = true,
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}