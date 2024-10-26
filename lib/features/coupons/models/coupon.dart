import 'package:json_annotation/json_annotation.dart';

part 'coupon.g.dart';

@JsonSerializable()
class Coupon {
  final String id;
  final String code;
  final String description;
  final double discountAmount;
  final bool isPercentage;
  final DateTime validFrom;
  final DateTime validUntil;
  final int? maxUses;
  final int usedCount;
  final double? minimumPurchaseAmount;

  Coupon({
    required this.id,
    required this.code,
    required this.description,
    required this.discountAmount,
    required this.isPercentage,
    required this.validFrom,
    required this.validUntil,
    this.maxUses,
    required this.usedCount,
    this.minimumPurchaseAmount,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);
  Map<String, dynamic> toJson() => _$CouponToJson(this);

  bool get isValid {
    final now = DateTime.now();
    return now.isAfter(validFrom) &&
        now.isBefore(validUntil) &&
        (maxUses == null || usedCount < maxUses!);
  }

  double calculateDiscount(double amount) {
    if (!isValid) return 0;
    if (minimumPurchaseAmount != null && amount < minimumPurchaseAmount!) {
      return 0;
    }
    return isPercentage ? amount * (discountAmount / 100) : discountAmount;
  }
}