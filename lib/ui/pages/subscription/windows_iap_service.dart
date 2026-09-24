import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:windows_store_iap/windows_store_iap.dart' as msstore;

import '../../../util/app_constants.dart';

/// A currently-owned Windows Store entitlement, resolved back to our
/// internal plan id (the same weeklyPlan/monthlyPlan/yearlyPlan/unlimitedPlan
/// constants used for the Android/Apple product IDs).
class WindowsEntitlement {
  const WindowsEntitlement({required this.planId, this.expiresAt});

  final String planId;

  /// Null for a non-expiring (lifetime) entitlement, or when the Store
  /// didn't report one.
  final DateTime? expiresAt;
}

/// Thin wrapper around the windows_store_iap plugin. Keeps the Windows-only
/// plugin types out of the shared subscription/paywall code, which only
/// works with plain data (internal plan ids, ProductDetails, DateTime).
class WindowsIapService {
  WindowsIapService._internal();
  static final WindowsIapService instance = WindowsIapService._internal();

  final msstore.WindowsStoreIap _iap = msstore.WindowsStoreIap();

  /// Internal plan id -> Microsoft Store Product Store ID, for whichever
  /// add-ons have actually been configured in app_constants.dart.
  Map<String, String> get configuredPlans {
    const byPlan = {
      weeklyPlan: windowsWeeklyPlanStoreId,
      monthlyPlan: windowsMonthlyPlanStoreId,
      yearlyPlan: windowsYearlyPlanStoreId,
      unlimitedPlan: windowsUnlimitedPlanStoreId,
    };
    return {
      for (final entry in byPlan.entries)
        if (entry.value.isNotEmpty) entry.key: entry.value,
    };
  }

  String? storeIdForPlan(String planId) {
    final id = configuredPlans[planId];
    return (id == null || id.isEmpty) ? null : id;
  }

  /// Product listing (title/description/price) for every configured plan,
  /// keyed by our internal plan id and adapted to the same [ProductDetails]
  /// shape the Android/Apple purchase UI already renders, so no
  /// windows_store_iap type needs to leave this file.
  Future<Map<String, ProductDetails>> fetchProducts() async {
    final plans = configuredPlans;
    if (plans.isEmpty) return {};
    try {
      final products = await _iap.getProducts();
      final byStoreId = <String, msstore.Product>{
        for (final product in products)
          if (product.storeId != null) product.storeId!: product,
      };
      return {
        for (final entry in plans.entries)
          if (byStoreId[entry.value] != null)
            entry.key: _toProductDetails(entry.key, byStoreId[entry.value]!),
      };
    } catch (e) {
      debugPrint('WindowsIapService.fetchProducts failed: $e');
      return {};
    }
  }

  ProductDetails _toProductDetails(String planId, msstore.Product product) {
    final price = product.storePrice;
    return ProductDetails(
      id: planId,
      title: product.title ?? planId,
      description: product.description ?? '',
      price: price?.formattedPrice ?? product.price ?? '',
      rawPrice: price?.unformattedPrice ?? 0,
      currencyCode: price?.currencyCode ?? 'USD',
    );
  }

  /// Plans the user currently holds a valid (non-expired) Store entitlement
  /// for. Always re-checked against the Store rather than trusted from local
  /// cache, since that's what the plugin's license APIs are for.
  Future<List<WindowsEntitlement>> currentEntitlements() async {
    final plans = configuredPlans;
    if (plans.isEmpty) return [];
    try {
      final licenses = await _iap.getAddonLicenses();
      final owned = <WindowsEntitlement>[];
      for (final entry in plans.entries) {
        final storeId = entry.value;
        msstore.StoreLicense? license = licenses[storeId];
        license ??= licenses.values
            .where(
              (l) => l.productStoreId == storeId || l.skuStoreId == storeId,
            )
            .cast<msstore.StoreLicense?>()
            .firstWhere((_) => true, orElse: () => null);
        if (license != null && license.isCurrentlyEntitled()) {
          owned.add(
            WindowsEntitlement(planId: entry.key, expiresAt: license.expiresAt),
          );
        }
      }
      return owned;
    } catch (e) {
      debugPrint('WindowsIapService.currentEntitlements failed: $e');
      return [];
    }
  }

  /// Opens the Microsoft Store purchase UI for [planId]. Returns true when
  /// the purchase completed or the user already owned it.
  Future<bool> purchase(String planId) async {
    final storeId = storeIdForPlan(planId);
    if (storeId == null) return false;
    try {
      final status = await _iap.makePurchase(storeId);
      return status == msstore.StorePurchaseStatus.succeeded ||
          status == msstore.StorePurchaseStatus.alreadyPurchased;
    } catch (e) {
      debugPrint('WindowsIapService.purchase failed: $e');
      return false;
    }
  }
}
