import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ecommerce/core/di/service_locator.dart';
import 'package:flutter_ecommerce/features/wishlist/store/wishlist_store.dart';
import 'package:flutter_ecommerce/core/widgets/product_card.dart';
import 'package:go_router/go_router.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final _wishlistStore = getIt<WishlistStore>();

  @override
  void initState() {
    super.initState();
    _wishlistStore.loadWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        actions: [
          Observer(
            builder: (context) {
              if (_wishlistStore.wishlistItems.isEmpty) return const SizedBox();
              return IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Clear Wishlist'),
                      content: const Text(
                        'Are you sure you want to clear your wishlist?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () {
                            _wishlistStore.clearWishlist();
                            Navigator.pop(context);
                          },
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Observer(
        builder: (context) {
          if (_wishlistStore.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_wishlistStore.wishlistItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your wishlist is empty',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => context.go('/products'),
                    icon: const Icon(Icons.shopping_bag_outlined),
                    label: const Text('Browse Products'),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width ~/ 300,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _wishlistStore.wishlistItems.length,
            itemBuilder: (context, index) {
              final product = _wishlistStore.wishlistItems[index];
              return ProductCard(
                product: product,
                onTap: () => context.push('/products/${product.id}'),
                onAddToCart: () {
                  // TODO: Implement add to cart
                },
                onToggleWishlist: () => _wishlistStore.toggleWishlist(product),
                isInWishlist: true,
              );
            },
          );
        },
      ),
    );
  }
}