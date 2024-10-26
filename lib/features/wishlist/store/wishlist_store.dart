import 'package:mobx/mobx.dart';
import 'package:flutter_ecommerce/features/products/models/product.dart';
import 'package:flutter_ecommerce/features/products/data/product_repository.dart';

part 'wishlist_store.g.dart';

class WishlistStore = _WishlistStore with _$WishlistStore;

abstract class _WishlistStore with Store {
  final ProductRepository _productRepository;

  _WishlistStore(this._productRepository);

  @observable
  ObservableList<Product> wishlistItems = ObservableList<Product>();

  @observable
  bool isLoading = false;

  @computed
  bool Function(String) get isInWishlist =>
      (String productId) => wishlistItems.any((item) => item.id == productId);

  @action
  Future<void> loadWishlist() async {
    isLoading = true;
    try {
      // TODO: Implement API call to fetch wishlist
      final products = await _productRepository.getProducts();
      wishlistItems = ObservableList.of(products);
    } finally {
      isLoading = false;
    }
  }

  @action
  void toggleWishlist(Product product) {
    final exists = wishlistItems.any((item) => item.id == product.id);
    if (exists) {
      wishlistItems.removeWhere((item) => item.id == product.id);
    } else {
      wishlistItems.add(product);
    }
    // TODO: Sync with backend
  }

  @action
  void removeFromWishlist(String productId) {
    wishlistItems.removeWhere((item) => item.id == productId);
    // TODO: Sync with backend
  }

  @action
  void clearWishlist() {
    wishlistItems.clear();
    // TODO: Sync with backend
  }
}