import 'package:mobx/mobx.dart';
import 'package:flutter_ecommerce/features/categories/models/category.dart';
import 'package:flutter_ecommerce/features/categories/data/category_repository.dart';

part 'category_store.g.dart';

class CategoryStore = _CategoryStore with _$CategoryStore;

abstract class _CategoryStore with Store {
  final CategoryRepository _repository;

  _CategoryStore(this._repository);

  @observable
  ObservableList<Category> categories = ObservableList<Category>();

  @observable
  bool isLoading = false;

  @observable
  String? error;

  @action
  Future<void> fetchCategories() async {
    isLoading = true;
    error = null;
    try {
      final fetchedCategories = await _repository.getCategories();
      categories = ObservableList.of(fetchedCategories);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> createCategory(Category category) async {
    isLoading = true;
    error = null;
    try {
      final createdCategory = await _repository.createCategory(category);
      categories.add(createdCategory);
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> updateCategory(Category category) async {
    isLoading = true;
    error = null;
    try {
      final updatedCategory = await _repository.updateCategory(category);
      final index = categories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        categories[index] = updatedCategory;
      }
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> deleteCategory(String id) async {
    isLoading = true;
    error = null;
    try {
      await _repository.deleteCategory(id);
      categories.removeWhere((c) => c.id == id);
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  @computed
  List<Category> get parentCategories =>
      categories.where((c) => c.parentId == null).toList();

  @computed
  List<Category> Function(String) get subCategories =>
      (String parentId) => categories.where((c) => c.parentId == parentId).toList();
}