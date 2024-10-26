import 'package:mobx/mobx.dart';
import 'package:flutter_ecommerce/features/cart/models/cart_item.dart';
import 'package:flutter_ecommerce/features/products/models/product.dart';

part 'cart_store.g.dart';

class CartStore = _CartStore with _$CartStore;

abstract class _CartStore with Store {
  @observable
  ObservableList<CartItem> items = ObservableList<CartItem>();

  @computed
  double get total => items.fold(0, (sum, item) => sum + item.total);

  @computed
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  @action
  void addToCart(Product product, [int quantity = 1]) {
    if (product.stockQuantity < quantity) {
      throw Exception('Not enough stock available');
    }

    final existingItem = items.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );

    if (existingItem.quantity == 0) {
      items.add(CartItem(product: product, quantity: quantity));
    } else {
      final index = items.indexOf(existingItem);
      if (existingItem.quantity + quantity > product.stockQuantity) {
        throw Exception('Not enough stock available');
      }
      items[index] = CartItem(
        product: product,
        quantity: existingItem.quantity + quantity,
      );
    }
  }

  @action
  void removeFromCart(String productId) {
    items.removeWhere((item) => item.product.id == productId);
  }

  @action
  void updateQuantity(String productId, int quantity) {
    final index = items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      final product = items[index].product;
      if (quantity <= 0) {
        items.removeAt(index);
      } else if (quantity <= product.stockQuantity) {
        items[index] = CartItem(
          product: product,
          quantity: quantity,
        );
      } else {
        throw Exception('Not enough stock available');
      }
    }
  }

  @action
  void clearCart() {
    items.clear();
  }

  @action
  void incrementQuantity(String productId) {
    final item = items.firstWhere((item) => item.product.id == productId);
    if (item.quantity < item.product.stockQuantity) {
      updateQuantity(productId, item.quantity + 1);
    }
  }

  @action
  void decrementQuantity(String productId) {
    final item = items.firstWhere((item) => item.product.id == productId);
    if (item.quantity > 1) {
      updateQuantity(productId, item.quantity - 1);
    } else {
      removeFromCart(productId);
    }
  }
}