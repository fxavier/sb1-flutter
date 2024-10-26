import 'package:get_it/get_it.dart';
import 'package:flutter_ecommerce/features/auth/data/auth_repository.dart';
import 'package:flutter_ecommerce/features/products/data/product_repository.dart';
import 'package:flutter_ecommerce/features/categories/data/category_repository.dart';
import 'package:flutter_ecommerce/features/auth/store/auth_store.dart';
import 'package:flutter_ecommerce/features/products/store/product_store.dart';
import 'package:flutter_ecommerce/features/cart/store/cart_store.dart';
import 'package:flutter_ecommerce/features/categories/store/category_store.dart';
import 'package:flutter_ecommerce/features/checkout/store/checkout_store.dart';
import 'package:flutter_ecommerce/features/payment/services/stripe_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl());
  getIt.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl());

  // Services
  getIt.registerLazySingleton<StripeService>(() => StripeService());

  // Stores
  getIt.registerLazySingleton<AuthStore>(() => AuthStore(getIt<AuthRepository>()));
  getIt.registerLazySingleton<ProductStore>(() => ProductStore(getIt<ProductRepository>()));
  getIt.registerLazySingleton<CartStore>(() => CartStore());
  getIt.registerLazySingleton<CategoryStore>(() => CategoryStore(getIt<CategoryRepository>()));
  getIt.registerLazySingleton<CheckoutStore>(() => CheckoutStore(
        getIt<CartStore>(),
        getIt<StripeService>(),
      ));
}