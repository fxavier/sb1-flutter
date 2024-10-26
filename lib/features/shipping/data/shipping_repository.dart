import 'package:flutter_ecommerce/core/api/api_client.dart';
import 'package:flutter_ecommerce/features/shipping/models/shipping_address.dart';

abstract class ShippingRepository {
  Future<List<ShippingAddress>> getAddresses();
  Future<ShippingAddress> createAddress(ShippingAddress address);
  Future<ShippingAddress> updateAddress(ShippingAddress address);
  Future<void> deleteAddress(String id);
  Future<void> setDefaultAddress(String id);
}

class ShippingRepositoryImpl implements ShippingRepository {
  final ApiClient _apiClient;

  ShippingRepositoryImpl() : _apiClient = ApiClient();

  @override
  Future<List<ShippingAddress>> getAddresses() async {
    final response = await _apiClient.get('/shipping/addresses');
    return (response as List)
        .map((json) => ShippingAddress.fromJson(json))
        .toList();
  }

  @override
  Future<ShippingAddress> createAddress(ShippingAddress address) async {
    final response = await _apiClient.post(
      '/shipping/addresses',
      data: address.toJson(),
    );
    return ShippingAddress.fromJson(response);
  }

  @override
  Future<ShippingAddress> updateAddress(ShippingAddress address) async {
    final response = await _apiClient.put(
      '/shipping/addresses/${address.id}',
      data: address.toJson(),
    );
    return ShippingAddress.fromJson(response);
  }

  @override
  Future<void> deleteAddress(String id) async {
    await _apiClient.delete('/shipping/addresses/$id');
  }

  @override
  Future<void> setDefaultAddress(String id) async {
    await _apiClient.post('/shipping/addresses/$id/default');
  }
}