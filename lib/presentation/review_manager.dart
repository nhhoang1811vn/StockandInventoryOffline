import 'dart:math';

import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

class ReviewManager {
  static final _random = Random();

  /// Call this to request a review with a 10% chance
  static Future<void> maybeRequestReview() async {
    final shouldRequestReview = _random.nextInt(100) < 10; // 10% chance
    //final shouldRequestReview = true;
    if (!shouldRequestReview) return;

    final inAppReview = InAppReview.instance;
    try {
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      } else {
        await inAppReview.openStoreListing();
      }
    } catch (e) {
      debugPrint('ReviewManager error: $e');
    }
  }
}
