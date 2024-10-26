import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ecommerce/core/di/service_locator.dart';
import 'package:flutter_ecommerce/features/reviews/store/review_store.dart';
import 'package:flutter_ecommerce/features/reviews/models/review.dart';

class ReviewList extends StatelessWidget {
  final String productId;

  const ReviewList({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final reviewStore = getIt<ReviewStore>();

    return Observer(
      builder: (context) {
        final reviews = reviewStore.productReviews[productId] ?? [];

        if (reviews.isEmpty) {
          return const Center(
            child: Text('No reviews yet. Be the first to review!'),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return ReviewCard(review: review);
          },
        );
      },
    );
  }
}

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(review.userName[0]),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Posted on ${review.createdAt.toString()}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (review.isVerifiedPurchase)
                  Chip(
                    label: const Text('Verified Purchase'),
                    backgroundColor: Colors.green.withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: Colors.green[700],
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < review.rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(review.comment),
            if (review.images != null && review.images!.isNotEmpty) ...[
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: review.images!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          review.images![index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    // TODO: Implement helpful functionality
                  },
                  icon: const Icon(Icons.thumb_up_outlined),
                  label: Text('Helpful (${review.helpfulCount})'),
                ),
                const Spacer(),
                Wrap(
                  spacing: 4,
                  children: review.tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      labelStyle: const TextStyle(fontSize: 12),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}