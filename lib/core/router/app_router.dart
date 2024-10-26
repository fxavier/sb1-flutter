import 'package:go_router/go_router.dart';
import 'package:flutter_ecommerce/features/auth/ui/login_screen.dart';
import 'package:flutter_ecommerce/features/products/ui/product_list_screen.dart';
import 'package:flutter_ecommerce/features/products/ui/product_detail_screen.dart';
import 'package:flutter_ecommerce/features/cart/ui/cart_screen.dart';
import 'package:flutter_ecommerce/features/categories/ui/category_list_screen.dart';
import 'package:flutter_ecommerce/features/checkout/ui/checkout_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/products',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductListScreen(),
    ),
    GoRoute(
      path: '/products/:id',
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductDetailScreen(product: product);
      },
    ),
    GoRoute(
      path: '/categories',
      builder: (context, state) => const CategoryListScreen(),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => CartScreen(),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
  ],
);