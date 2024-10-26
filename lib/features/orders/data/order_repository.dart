import 'package:flutter_ecommerce/core/api/api_client.dart';
import 'package:flutter_ecommerce/features/orders/models/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders();
  Future<Order> getOrderById(String id);
  Future<Order> createOrder(Order order);
  Future<Order> updateOrderStatus(String id, String status);
  Future<void> cancelOrder(String id);
}

class OrderRepositoryImpl implements OrderRepository {
  final ApiClient _apiClient;

  OrderRepositoryImpl() : _apiClient = ApiClient();

  @override
  Future<List<Order>> getOrders() async {
    final response = await _apiClient.get('/orders');
    return (response as List).map((json) => Order.fromJson(json)).toList();
  }

  @override
  Future<Order> getOrderById(String id) async {
    final response = await _apiClient.get('/orders/$id');
    return Order.fromJson(response);
  }

  @override
  Future<Order> createOrder(Order order) async {
    final response = await _apiClient.post(
      '/orders',
      data: order.toJson(),
    );
    return Order.fromJson(response);
  }

  @override
  Future<Order> updateOrderStatus(String id, String status) async {
    final response = await _apiClient.put(
      '/orders/$id/status',
      data: {'status': status},
    );
    return Order.fromJson(response);
  }

  @override
  Future<void> cancelOrder(String id) async {
    await _apiClient.post('/orders/$id/cancel');
  }
}