// removed ignore: depend_on_referenced_packages
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/littlefish_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../../common/presentaion/components/app_progress_indicator.dart';

class ProductReviewsList extends StatefulWidget {
  final String? businessId;

  final String? productId;

  final bool managementLayout;

  const ProductReviewsList({
    Key? key,
    required this.businessId,
    required this.productId,
    this.managementLayout = false,
  }) : super(key: key);

  @override
  State<ProductReviewsList> createState() => _ProductReviewsListState();
}

class _ProductReviewsListState extends State<ProductReviewsList> {
  final AsyncMemoizer<List<StoreProductRating>> _memoizer = AsyncMemoizer();

  final FirestoreService _service = FirestoreService();

  bool _isLoading = false;

  void setLoading(bool value) {
    if (mounted) {
      setState(() {
        _isLoading = value;
      });
    } else {
      _isLoading = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 48,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      child: FutureBuilder<List<StoreProductRating>>(
        future: _memoizer.runOnce(
          () async => await _service.getProductRatings(
            widget.businessId,
            widget.productId,
          ),
        ),
        builder:
            (
              BuildContext context,
              AsyncSnapshot<List<StoreProductRating>> snapshot,
            ) {
              if (_isLoading) return const AppProgressIndicator();

              if (snapshot.connectionState != ConnectionState.done) {
                return const AppProgressIndicator();
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Error'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No Data'));
              }

              var reviews = snapshot.data;

              return MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reviews?.length ?? 0,
                  itemBuilder: (context, index) {
                    var review = reviews![index];
                    return Material(
                      child: ListTile(
                        tileColor: Theme.of(context).colorScheme.background,
                        title: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(review.review!, maxLines: 5),
                        ),
                        subtitle: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    review.displayName!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    timeago.format(review.reviewDate!),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              ratingBar(review.rating!, 5, itemSize: 12),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
      ),
    );
  }

  Widget ratingBar(
    double currentRating,
    double maxRating, {
    double itemSize = 20,
  }) {
    var bar = RatingBarIndicator(
      rating: currentRating,
      itemSize: itemSize,
      direction: Axis.horizontal,
      itemCount: maxRating.toInt(),
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
    );

    return bar;
  }
}
