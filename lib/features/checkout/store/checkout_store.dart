import 'package:mobx/mobx.dart';
import 'package:flutter_ecommerce/features/cart/store/cart_store.dart';
import 'package:flutter_ecommerce/features/coupons/models/coupon.dart';
import 'package:flutter_ecommerce/features/payment/services/stripe_service.dart';

part 'checkout_store.g.dart';

class CheckoutStore = _CheckoutStore with _$CheckoutStore;

abstract class _CheckoutStore with Store {
  final CartStore _cartStore;
  final StripeService _stripeService;

  _CheckoutStore(this._cartStore, this._stripeService);

  @observable
  Coupon? appliedCoupon;

  @observable
  bool isProcessing = false;

  @computed
  double get subtotal => _cartStore.total;

  @computed
  double get discount => appliedCoupon?.calculateDiscount(subtotal) ?? 0;

  @computed
  double get total => subtotal - discount;

  @action
  Future<bool> processPayment() async {
    isProcessing = true;
    try {
      final success = await _stripeService.handlePayment(total, 'USD');
      if (success) {
        _cartStore.clearCart();
      }
      return success;
    } finally {
      isProcessing = false;
    }
  }

  @action
  void applyCoupon(Coupon coupon) {
    if (coupon.isValid) {
      appliedCoupon = coupon;
    }
  }

  @action
  void removeCoupon() {
    appliedCoupon = null;
  }
}