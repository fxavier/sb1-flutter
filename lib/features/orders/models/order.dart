import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_ecommerce/features/cart/models/cart_item.dart';
import 'package:flutter_ecommerce/features/shipping/models/shipping_address.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double shippingCost;
  final double discount;
  final double total;
  final String status;
  final DateTime createdAt;
  final ShippingAddress shippingAddress;
  final String? trackingNumber;
  final String? couponCode;
  final String paymentMethod;
  final String paymentStatus;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.shippingCost,
    required this.discount,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.shippingAddress,
    this.trackingNumber,
    this.couponCode,
    required this.paymentMethod,
    required this.paymentStatus,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}