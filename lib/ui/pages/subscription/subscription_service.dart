import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../util/app_constants.dart';
import 'windows_iap_service.dart';

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

    if (defaultTargetPlatform == TargetPlatform.windows) {
      await _checkWindowsSubscription(prefs);
      return;
    }

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

  /// Windows has no locally-trustworthy purchase record (there's no
  /// on-device receipt like Play/App Store), so subscription state is
  /// re-derived from the live Microsoft Store license on every check rather
  /// than from a client-side expiry date.
  Future<void> _checkWindowsSubscription(SharedPreferences prefs) async {
    final owned = await WindowsIapService.instance.currentEntitlements();

    WindowsEntitlement? best;
    for (final candidate in [unlimitedPlan, yearlyPlan, monthlyPlan, weeklyPlan]) {
      for (final entitlement in owned) {
        if (entitlement.planId == candidate) {
          best = entitlement;
          break;
        }
      }
      if (best != null) break;
    }

    if (best != null) {
      await prefs.setBool('isSubscribed', true);
      await prefs.setString('purchasedPlan', best.planId);
      if (best.planId == unlimitedPlan || best.expiresAt == null) {
        await prefs.remove('subscriptionExpiryDate');
      } else {
        await prefs.setString(
          'subscriptionExpiryDate',
          best.expiresAt!.toIso8601String(),
        );
      }
      _isSubscribed = true;
      _plan = best.planId;
    } else {
      await prefs.setBool('isSubscribed', false);
      await prefs.remove('purchasedPlan');
      await prefs.remove('subscriptionExpiryDate');
      _isSubscribed = false;
      _plan = '';
    }

    notifyListeners();
  }
}
