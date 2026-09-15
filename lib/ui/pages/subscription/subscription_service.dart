import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../util/app_constants.dart';

class SubscriptionService extends ChangeNotifier {
  SubscriptionService._internal();
  static final SubscriptionService instance = SubscriptionService._internal();

  bool _isSubscribed = false;
  String _plan = '';

  bool get isSubscribed => _isSubscribed;
  String get purchasedPlan => _plan;

  /// Call once on app start
  Future<void> init() async {
    await _checkSubscription();
  }

  Future<void> refresh() async {
    await _checkSubscription();
  }

  Future<void> _checkSubscription() async {
    final prefs = await SharedPreferences.getInstance();

    final plan = prefs.getString('purchasedPlan');
    final expiryDateString = prefs.getString('subscriptionExpiryDate');

    bool valid = false;

    if (plan == unlimitedPlan) {
      valid = true;
    } else if (expiryDateString != null) {
      final expiry = DateTime.tryParse(expiryDateString);
      if (expiry != null && DateTime.now().isBefore(expiry)) {
        valid = true;
      }
    }

    if (!valid) {
      await prefs.setBool('isSubscribed', false);
      await prefs.remove('purchasedPlan');
      await prefs.remove('subscriptionExpiryDate');
    }

    await prefs.setBool('isSubscribed', valid);
    _isSubscribed = valid;
    _plan = valid ? (plan ?? '') : '';

    notifyListeners();
  }
}
