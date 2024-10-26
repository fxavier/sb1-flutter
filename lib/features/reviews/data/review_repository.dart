import 'package:flutter_ecommerce/core/api/api_client.dart';
import 'package:flutter_ecommerce/features/reviews/models/review.dart';

abstract class ReviewRepository {
  Future<List<Review>> getProductReviews(String productId);
  Future<Review> createReview(Review review);
  Future<Review> updateReview(Review review);
  Future<void> deleteReview(String id);
  Future<void> markReviewHelpful(String id);
}

class ReviewRepositoryImpl implements ReviewRepository {
  final ApiClient _apiClient;

  ReviewRepositoryImpl() : _apiClient = ApiClient();

  @override
  Future<List<Review>> getProductReviews(String productId) async {
    final response = await _apiClient.get('/products/$productId/reviews');
    return (response as List).map((json) => Review.fromJson(json)).toList();
  }

  @override
  Future<Review> createReview(Review review) async {
    final response = await _apiClient.post(
      '/reviews',
      data: review.toJson(),
    );
    return Review.fromJson(response);
  }

  @override
  Future<Review> updateReview(Review review) async {
    final response = await _apiClient.put(
      '/reviews/${review.id}',
      data: review.toJson(),
    );
    return Review.fromJson(response);
  }

  @override
  Future<void> deleteReview(String id) async {
    await _apiClient.delete('/reviews/$id');
  }

  @override
  Future<void> markReviewHelpful(String id) async {
    await _apiClient.post('/reviews/$id/helpful');
  }
}