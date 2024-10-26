import 'package:mobx/mobx.dart';
import 'package:flutter_ecommerce/features/products/data/product_repository.dart';
import 'package:flutter_ecommerce/features/products/models/product.dart';

part 'product_store.g.dart';

class ProductStore = _ProductStore with _$ProductStore;

abstract class _ProductStore with Store {
  final ProductRepository _productRepository;

  _ProductStore(this._productRepository);

  @observable
  ObservableList<Product> products = ObservableList<Product>();

  @observable
  ObservableList<String> wishlist = ObservableList<String>();

  @observable
  bool isLoading = false;

  @observable
  String? selectedCategory;

  @observable
  String searchQuery = '';

  @observable
  double? minPrice;

  @observable
  double? maxPrice;

  @computed
  List<Product> get filteredProducts {
    return products.where((product) {
      final matchesCategory = selectedCategory == null || product.category == selectedCategory;
      final matchesSearch = searchQuery.isEmpty || 
        product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
        product.description.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesPrice = (minPrice == null || product.price >= minPrice!) &&
        (maxPrice == null || product.price <= maxPrice!);
      
      return matchesCategory && matchesSearch && matchesPrice;
    }).toList();
  }

  @action
  Future<void> fetchProducts() async {
    isLoading = true;
    try {
      final fetchedProducts = await _productRepository.getProducts();
      products = ObservableList.of(fetchedProducts);
    } finally {
      isLoading = false;
    }
  }

  @action
  void setSearchQuery(String query) {
    searchQuery = query;
  }

  @action
  void setCategory(String? category) {
    selectedCategory = category;
  }

  @action
  void setPriceRange(double? min, double? max) {
    minPrice = min;
    maxPrice = max;
  }

  @action
  void toggleWishlist(String productId) {
    if (wishlist.contains(productId)) {
      wishlist.remove(productId);
    } else {
      wishlist.add(productId);
    }
  }

  bool isInWishlist(String productId) => wishlist.contains(productId);
}