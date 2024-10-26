import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ecommerce/core/di/service_locator.dart';
import 'package:flutter_ecommerce/features/products/store/product_store.dart';
import 'package:flutter_ecommerce/features/cart/store/cart_store.dart';
import 'package:flutter_ecommerce/core/widgets/product_card.dart';
import 'package:go_router/go_router.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _productStore = getIt<ProductStore>();
  final _cartStore = getIt<CartStore>();
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _productStore.fetchProducts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _productStore.loadMoreProducts();
    }
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Products',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Minimum Price',
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final min = double.tryParse(value);
                _productStore.setPriceRange(min, _productStore.maxPrice);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Maximum Price',
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final max = double.tryParse(value);
                _productStore.setPriceRange(_productStore.minPrice, max);
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    _productStore.setPriceRange(null, null);
                    Navigator.pop(context);
                  },
                  child: const Text('Clear'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => context.push('/cart'),
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => context.push('/wishlist'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: _productStore.setSearchQuery,
                  ),
                ),
                const SizedBox(width: 16),
                IconButton.filled(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _showFilterDialog,
                ),
              ],
            ),
          ),
          Expanded(
            child: Observer(
              builder: (context) {
                if (_productStore.isLoading && _productStore.products.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final products = _productStore.filteredProducts;

                if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No products found',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            _searchController.clear();
                            _productStore.setSearchQuery('');
                            _productStore.setPriceRange(null, null);
                          },
                          child: const Text('Clear Filters'),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => _productStore.fetchProducts(),
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width ~/ 300,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: products.length + (_productStore.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == products.length) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final product = products[index];
                      return ProductCard(
                        product: product,
                        onTap: () => context.push(
                          '/products/${product.id}',
                          extra: product,
                        ),
                        onAddToCart: () {
                          _cartStore.addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              action: SnackBarAction(
                                label: 'View Cart',
                                onPressed: () => context.push('/cart'),
                              ),
                            ),
                          );
                        },
                        onToggleWishlist: () => _productStore.toggleWishlist(product.id),
                        isInWishlist: _productStore.isInWishlist(product.id),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}