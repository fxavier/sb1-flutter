import 'package:flutter_ecommerce/core/api/api_client.dart';
import 'package:flutter_ecommerce/features/coupons/models/coupon.dart';

abstract class CouponRepository {
  Future<List<Coupon>> getCoupons();
  Future<Coupon> getCouponByCode(String code);
  Future<Coupon> createCoupon(Coupon coupon);
  Future<Coupon> updateCoupon(Coupon coupon);
  Future<void> deleteCoupon(String id);
  Future<bool> validateCoupon(String code, double amount);
}

class CouponRepositoryImpl implements CouponRepository {
  final ApiClient _apiClient;

  CouponRepositoryImpl() : _apiClient = ApiClient();

  @override
  Future<List<Coupon>> getCoupons() async {
    final response = await _apiClient.get('/coupons');
    return (response as List).map((json) => Coupon.fromJson(json)).toList();
  }

  @override
  Future<Coupon> getCouponByCode(String code) async {
    final response = await _apiClient.get('/coupons/code/$code');
    return Coupon.fromJson(response);
  }

  @override
  Future<Coupon> createCoupon(Coupon coupon) async {
    final response = await _apiClient.post(
      '/coupons',
      data: coupon.toJson(),
    );
    return Coupon.fromJson(response);
  }

  @override
  Future<Coupon> updateCoupon(Coupon coupon) async {
    final response = await _apiClient.put(
      '/coupons/${coupon.id}',
      data: coupon.toJson(),
    );
    return Coupon.fromJson(response);
  }

  @override
  Future<void> deleteCoupon(String id) async {
    await _apiClient.delete('/coupons/$id');
  }

  @override
  Future<bool> validateCoupon(String code, double amount) async {
    final response = await _apiClient.post(
      '/coupons/validate',
      data: {
        'code': code,
        'amount': amount,
      },
    );
    return response['valid'] as bool;
  }
}