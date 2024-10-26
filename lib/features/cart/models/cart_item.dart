import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_ecommerce/features/products/models/product.dart';

part 'cart_item.g.dart';

@JsonSerializable()
class CartItem {
  final Product product;
  final int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  double get total => product.price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}