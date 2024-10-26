import 'package:mobx/mobx.dart';
import 'package:flutter_ecommerce/features/reviews/models/review.dart';

part 'review_store.g.dart';

class ReviewStore = _ReviewStore with _$ReviewStore;

abstract class _ReviewStore with Store {
  @observable
  ObservableMap<String, ObservableList<Review>> productReviews = ObservableMap();

  @observable
  bool isLoading = false;

  @action
  Future<void> fetchReviews(String productId) async {
    isLoading = true;
    try {
      // TODO: Implement API call
      final reviews = <Review>[];
      productReviews[productId] = ObservableList.of(reviews);
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> addReview(Review review) async {
    // TODO: Implement API call
    final reviews = productReviews[review.productId] ?? ObservableList<Review>();
    reviews.add(review);
    productReviews[review.productId] = reviews;
  }

  @action
  Future<void> markHelpful(String reviewId) async {
    // TODO: Implement API call
  }

  @computed
  double Function(String) get averageRating => (String productId) {
        final reviews = productReviews[productId];
        if (reviews == null || reviews.isEmpty) return 0;
        final sum = reviews.fold(0, (sum, review) => sum + review.rating);
        return sum / reviews.length;
      };
}