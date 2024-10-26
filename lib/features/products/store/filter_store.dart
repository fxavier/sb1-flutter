import 'package:mobx/mobx.dart';

part 'filter_store.g.dart';

class FilterStore = _FilterStore with _$FilterStore;

abstract class _FilterStore with Store {
  @observable
  ObservableMap<String, bool> selectedBrands = ObservableMap<String, bool>();

  @observable
  ObservableList<String> selectedCategories = ObservableList<String>();

  @observable
  double? minPrice;

  @observable
  double? maxPrice;

  @observable
  ObservableMap<String, bool> selectedAttributes = ObservableMap<String, bool>();

  @observable
  String sortBy = 'popularity';

  @observable
  bool ascending = true;

  @action
  void toggleBrand(String brand) {
    selectedBrands[brand] = !(selectedBrands[brand] ?? false);
  }

  @action
  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
  }

  @action
  void setPriceRange(double? min, double? max) {
    minPrice = min;
    maxPrice = max;
  }

  @action
  void toggleAttribute(String attribute) {
    selectedAttributes[attribute] = !(selectedAttributes[attribute] ?? false);
  }

  @action
  void setSortBy(String sort, bool asc) {
    sortBy = sort;
    ascending = asc;
  }

  @action
  void clearFilters() {
    selectedBrands.clear();
    selectedCategories.clear();
    minPrice = null;
    maxPrice = null;
    selectedAttributes.clear();
    sortBy = 'popularity';
    ascending = true;
  }
}