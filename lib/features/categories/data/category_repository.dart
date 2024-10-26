import 'package:flutter_ecommerce/core/api/api_client.dart';
import 'package:flutter_ecommerce/features/categories/models/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
  Future<Category> getCategoryById(String id);
  Future<Category> createCategory(Category category);
  Future<Category> updateCategory(Category category);
  Future<void> deleteCategory(String id);
}

class CategoryRepositoryImpl implements CategoryRepository {
  final ApiClient _apiClient;

  CategoryRepositoryImpl() : _apiClient = ApiClient();

  @override
  Future<List<Category>> getCategories() async {
    final response = await _apiClient.get('/categories');
    return (response as List).map((json) => Category.fromJson(json)).toList();
  }

  @override
  Future<Category> getCategoryById(String id) async {
    final response = await _apiClient.get('/categories/$id');
    return Category.fromJson(response);
  }

  @override
  Future<Category> createCategory(Category category) async {
    final response = await _apiClient.post(
      '/categories',
      data: category.toJson(),
    );
    return Category.fromJson(response);
  }

  @override
  Future<Category> updateCategory(Category category) async {
    final response = await _apiClient.put(
      '/categories/${category.id}',
      data: category.toJson(),
    );
    return Category.fromJson(response);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _apiClient.delete('/categories/$id');
  }
}