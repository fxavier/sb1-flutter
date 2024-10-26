import 'package:mobx/mobx.dart';
import 'package:flutter_ecommerce/features/orders/models/order.dart';

part 'order_store.g.dart';

class OrderStore = _OrderStore with _$OrderStore;

abstract class _OrderStore with Store {
  @observable
  ObservableList<Order> orders = ObservableList<Order>();

  @observable
  bool isLoading = false;

  @observable
  String? filterStatus;

  @computed
  List<Order> get filteredOrders => filterStatus == null
      ? orders
      : orders.where((order) => order.status == filterStatus).toList();

  @action
  Future<void> fetchOrders() async {
    isLoading = true;
    try {
      // TODO: Implement API call
      final fetchedOrders = <Order>[];
      orders = ObservableList.of(fetchedOrders);
    } finally {
      isLoading = false;
    }
  }

  @action
  void setStatusFilter(String? status) {
    filterStatus = status;
  }

  @action
  Future<void> cancelOrder(String orderId) async {
    // TODO: Implement API call
    final index = orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      final updatedOrder = Order(
        id: orders[index].id,
        userId: orders[index].userId,
        items: orders[index].items,
        subtotal: orders[index].subtotal,
        tax: orders[index].tax,
        shippingCost: orders[index].shippingCost,
        discount: orders[index].discount,
        total: orders[index].total,
        status: 'cancelled',
        createdAt: orders[index].createdAt,
        shippingAddress: orders[index].shippingAddress,
        trackingNumber: orders[index].trackingNumber,
        couponCode: orders[index].couponCode,
        paymentMethod: orders[index].paymentMethod,
        paymentStatus: orders[index].paymentStatus,
      );
      orders[index] = updatedOrder;
    }
  }

  @action
  Future<void> reorder(String orderId) async {
    // TODO: Implement API call
    final order = orders.firstWhere((order) => order.id == orderId);
    // Add items to cart
  }
}