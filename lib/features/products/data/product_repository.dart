import 'package:flutter_ecommerce/core/api/api_client.dart';
import 'package:flutter_ecommerce/features/products/models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> getProductById(String id);
  Future<Product> createProduct(Product product);
  Future<Product> updateProduct(Product product);
  Future<void> deleteProduct(String id);
  Future<List<Product>> searchProducts(String query);
}

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient _apiClient;

  ProductRepositoryImpl() : _apiClient = ApiClient();

  @override
  Future<List<Product>> getProducts() async {
    final response = await _apiClient.get('/products');
    return (response as List).map((json) => Product.fromJson(json)).toList();
  }

  @override
  Future<Product> getProductById(String id) async {
    final response = await _apiClient.get('/products/$id');
    return Product.fromJson(response);
  }

  @override
  Future<Product> createProduct(Product product) async {
    final response = await _apiClient.post(
      '/products',
      data: product.toJson(),
    );
    return Product.fromJson(response);
  }

  @override
  Future<Product> updateProduct(Product product) async {
    final response = await _apiClient.put(
      '/products/${product.id}',
      data: product.toJson(),
    );
    return Product.fromJson(response);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _apiClient.delete('/products/$id');
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final response = await _apiClient.get(
      '/products/search',
      queryParameters: {'q': query},
    );
    return (response as List).map((json) => Product.fromJson(json)).toList();
  }
}