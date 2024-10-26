import 'package:mobx/mobx.dart';
import 'package:flutter_ecommerce/features/shipping/models/shipping_address.dart';

part 'shipping_store.g.dart';

class ShippingStore = _ShippingStore with _$ShippingStore;

abstract class _ShippingStore with Store {
  @observable
  ObservableList<ShippingAddress> addresses = ObservableList<ShippingAddress>();

  @observable
  ShippingAddress? selectedAddress;

  @observable
  bool isLoading = false;

  @action
  Future<void> fetchAddresses() async {
    isLoading = true;
    try {
      // TODO: Implement API call
      final fetchedAddresses = <ShippingAddress>[];
      addresses = ObservableList.of(fetchedAddresses);
      selectedAddress = addresses.firstWhere(
        (address) => address.isDefault,
        orElse: () => addresses.isEmpty ? null : addresses.first,
      );
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> addAddress(ShippingAddress address) async {
    // TODO: Implement API call
    addresses.add(address);
    if (address.isDefault || addresses.length == 1) {
      selectedAddress = address;
    }
  }

  @action
  void selectAddress(String addressId) {
    selectedAddress = addresses.firstWhere((address) => address.id == addressId);
  }

  @action
  Future<void> updateAddress(ShippingAddress address) async {
    // TODO: Implement API call
    final index = addresses.indexWhere((a) => a.id == address.id);
    if (index != -1) {
      addresses[index] = address;
      if (selectedAddress?.id == address.id) {
        selectedAddress = address;
      }
    }
  }

  @action
  Future<void> deleteAddress(String addressId) async {
    // TODO: Implement API call
    addresses.removeWhere((address) => address.id == addressId);
    if (selectedAddress?.id == addressId) {
      selectedAddress = addresses.isEmpty ? null : addresses.first;
    }
  }
}