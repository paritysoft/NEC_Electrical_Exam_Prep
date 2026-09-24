import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_2_wrappers.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../util/app_constants.dart';
import '../../widgets/common_widget.dart';
import 'subscription_service.dart';
import 'windows_iap_service.dart';

class PurchasePlanDialog extends StatefulWidget {
  const PurchasePlanDialog({Key? key}) : super(key: key);

  /// showDialog<bool>() will return `true` if subscribed, `false` otherwise.
  static Future<bool> show(BuildContext context) async {
    final bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must tap a button.
      builder: (ctx) => const PurchasePlanDialog(),
    );
    return result ?? false;
  }

  @override
  State<PurchasePlanDialog> createState() => _PurchasePlanDialogState();
}

class _PurchasePlanDialogState extends State<PurchasePlanDialog> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late final StreamSubscription<List<PurchaseDetails>> _purchaseSubscription;

  /// List of fetched products from the store.
  List<ProductDetails> _products = [];

  /// For showing a loading indicator while we fetch product details.
  bool _isLoading = true;
  bool _isProcessing = false;
  String? _errorMessage;

  /// Currently selected product/offer key.
  late String? _selectedProductId;

  /// Flag to ensure the dialog is closed only once.
  bool _isDialogClosed = false;

  // Subscription status variables.
  bool _isSubscribed = false;
  String _purchasedPlan = "";
  DateTime? subscriptionExpiryDate;

  @override
  void initState() {
    super.initState();
    _selectedProductId = _defaultSelectedProductId;
    _loadSubscriptionStatus();
    if (_isUnsupportedPlatform) {
      _isLoading = false;
      _errorMessage = 'In-app purchases are not available on this platform.';
      _purchaseSubscription = const Stream<List<PurchaseDetails>>.empty().listen((_) {});
      return;
    }
    if (_isWindowsPlatform) {
      // Windows purchases go through the Microsoft Store purchase UI
      // (WindowsIapService), not the in_app_purchase purchaseStream used by
      // Android/Apple below, so there's nothing to subscribe to here.
      _purchaseSubscription = const Stream<List<PurchaseDetails>>.empty().listen((_) {});
      _initStoreInfo();
      return;
    }
    _initStoreInfo();

    // Listen to purchase updates.
    _purchaseSubscription = _inAppPurchase.purchaseStream.listen(
      (purchases) => _handlePurchaseUpdates(purchases),
      onError: (error) {
        debugPrint('Purchase Stream Error: $error');
        if (mounted) setState(() {
          _isProcessing = false;
          _errorMessage = 'Store connection interrupted. Please try again.';
        });
      },
    );
  }

  /// Load subscription status from SharedPreferences.
  Future<void> _loadSubscriptionStatus() async {
    await SubscriptionService.instance.refresh();
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _isSubscribed = SubscriptionService.instance.isSubscribed;
      _purchasedPlan = SubscriptionService.instance.purchasedPlan;
      subscriptionExpiryDate = DateTime.tryParse(
        prefs.getString('subscriptionExpiryDate') ?? '',
      );
    });
  }

  /// Query the store for product details.
  Future<void> _initStoreInfo() async {
    if (_isWindowsPlatform) {
      try {
        await _queryWindowsStoreInfo();
      } catch (_) {
        if (mounted)
          setState(() {
            _isLoading = false;
            _errorMessage =
                'Unable to connect to the Microsoft Store. Please try again.';
          });
      }
      return;
    }
    try {
      await _queryStoreInfo();
    } catch (_) {
      if (mounted)
        setState(() {
          _isLoading = false;
          _errorMessage = 'Unable to connect to the store. Please try again.';
        });
    }
  }

  /// Fetches Windows Store product listings for whichever plans have a
  /// Store ID configured in app_constants.dart. WindowsIapService already
  /// adapts them to the same [ProductDetails] shape the Android/Apple UI
  /// below renders, so no windows_store_iap types appear in this file.
  Future<void> _queryWindowsStoreInfo() async {
    final products = await WindowsIapService.instance.fetchProducts();
    if (!mounted) return;
    if (products.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }
    setState(() {
      _products = products.values.toList()..sort(_compareProductsForDisplay);
      final defaultProduct = _defaultProductForSelection(_products);
      if (defaultProduct != null) {
        _selectedProductId = _selectionKeyForProduct(defaultProduct);
      }
      _isLoading = false;
    });
  }

  Future<void> _queryStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      debugPrint('In-app purchases are not available on this device.');
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    debugPrint('Querying subscription products: ${_productIds.join(', ')}');
    final response = await _inAppPurchase.queryProductDetails(_productIds);
    if (response.error != null) {
      debugPrint('Error fetching product details: ${response.error}');
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    if (response.notFoundIDs.isNotEmpty) {
      debugPrint(
        'Subscription products not found by the store: '
        '${response.notFoundIDs.join(', ')}',
      );
    }
    if (response.productDetails.isEmpty) {
      debugPrint(
        'No products found. Confirm this build was installed from a Play '
        'testing track and the package name matches the Play Console app.',
      );
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    if (!mounted) return;
    setState(() {
      _products = _preferTrialOffers(response.productDetails.toList())
        ..sort(_compareProductsForDisplay);
      final defaultProduct = _defaultProductForSelection(_products);
      if (defaultProduct != null) {
        _selectedProductId = _selectionKeyForProduct(defaultProduct);
      }
      _isLoading = false;
    });
  }

  bool get _isUnsupportedPlatform =>
      kIsWeb || defaultTargetPlatform == TargetPlatform.linux;

  bool get _isWindowsPlatform =>
      defaultTargetPlatform == TargetPlatform.windows;

  bool get _isApplePlatform =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  String _selectionKeyForProduct(ProductDetails product) {
    if (product is GooglePlayProductDetails &&
        product.offerToken != null &&
        product.offerToken!.isNotEmpty) {
      return '${product.id}::${product.offerToken}';
    }
    return product.id;
  }

  ProductDetails? get _selectedProduct {
    final selected = _selectedProductId;
    if (selected == null) return null;

    for (final product in _products) {
      if (_selectionKeyForProduct(product) == selected) {
        return product;
      }
    }
    for (final product in _products) {
      if (product.id == selected) {
        return product;
      }
    }
    return null;
  }

  String? get _selectedBaseProductId =>
      _selectedProduct?.id ?? _selectedProductId;

  bool _isTrialEligibleProduct(String? productId) {
    if (productId == null || productId == unlimitedPlan) {
      return false;
    }
    return productId == weeklyPlan ||
        productId == monthlyPlan ||
        productId == yearlyPlan;
  }

  // Query both configured NEC purchase options.
  Set<String> get _productIds => {monthlyPlan, unlimitedPlan};
  String? get _defaultSelectedProductId => monthlyPlan;

  int _compareProductsForDisplay(ProductDetails a, ProductDetails b) {
    final planCompare = _planSortOrder(a.id).compareTo(_planSortOrder(b.id));
    if (planCompare != 0) return planCompare;

    final trialCompare = _trialSortOrder(a).compareTo(_trialSortOrder(b));
    if (trialCompare != 0) return trialCompare;

    return a.rawPrice.compareTo(b.rawPrice);
  }

  int _trialSortOrder(ProductDetails product) {
    return _hasStoreConfiguredFreeTrial(product) ? 0 : 1;
  }

  ProductDetails? _defaultProductForSelection(List<ProductDetails> products) {
    for (final productId in [
      yearlyPlan,
      monthlyPlan,
      if (_isApplePlatform) weeklyPlan,
      unlimitedPlan,
    ]) {
      if (productId.isEmpty) continue;
      for (final product in products) {
        if (product.id == productId) {
          return product;
        }
      }
    }
    return products.isNotEmpty ? products.first : null;
  }

  List<ProductDetails> _preferTrialOffers(List<ProductDetails> products) {
    if (defaultTargetPlatform != TargetPlatform.android) return products;

    final productsWithTrial = products
        .where(_hasGoogleFreeTrialOffer)
        .map((product) => product.id)
        .toSet();

    if (productsWithTrial.isEmpty) return products;

    return products.where((product) {
      return !productsWithTrial.contains(product.id) ||
          _hasGoogleFreeTrialOffer(product);
    }).toList();
  }

  bool _hasGoogleFreeTrialOffer(ProductDetails product) {
    if (product is! GooglePlayProductDetails ||
        product.subscriptionIndex == null ||
        product.productDetails.subscriptionOfferDetails == null) {
      return false;
    }

    final offer = product
        .productDetails
        .subscriptionOfferDetails![product.subscriptionIndex!];
    return offer.pricingPhases.any(
      (phase) => phase.priceAmountMicros == 0 && phase.billingCycleCount > 0,
    );
  }

  bool _hasAppleFreeTrialOffer(ProductDetails product) {
    if (product is AppStoreProductDetails) {
      final intro = product.skProduct.introductoryPrice;
      if (intro == null ||
          intro.type != SKProductDiscountType.introductory ||
          intro.paymentMode != SKProductDiscountPaymentMode.freeTrail) {
        return false;
      }

      return _storeKitPeriodDays(
            numberOfPeriods: intro.numberOfPeriods,
            numberOfUnits: intro.subscriptionPeriod.numberOfUnits,
            unit: intro.subscriptionPeriod.unit,
          ) ==
          freeTrialDays;
    }

    if (product is AppStoreProduct2Details) {
      final offers = product.sk2Product.subscription?.promotionalOffers;
      if (offers == null) return false;

      return offers.any((offer) {
        return offer.type == SK2SubscriptionOfferType.introductory &&
            offer.paymentMode == SK2SubscriptionOfferPaymentMode.freeTrial &&
            _storeKit2PeriodDays(
                  periodCount: offer.periodCount,
                  value: offer.period.value,
                  unit: offer.period.unit,
                ) ==
                freeTrialDays;
      });
    }

    return false;
  }

  bool _hasStoreConfiguredFreeTrial(ProductDetails product) {
    if (product is GooglePlayProductDetails) {
      return _hasGoogleFreeTrialOffer(product);
    }
    if (product is AppStoreProductDetails ||
        product is AppStoreProduct2Details) {
      return _hasAppleFreeTrialOffer(product);
    }
    return false;
  }

  int _storeKitPeriodDays({
    required int numberOfPeriods,
    required int numberOfUnits,
    required SKSubscriptionPeriodUnit unit,
  }) {
    final unitDays = switch (unit) {
      SKSubscriptionPeriodUnit.day => 1,
      SKSubscriptionPeriodUnit.week => 7,
      SKSubscriptionPeriodUnit.month => 30,
      SKSubscriptionPeriodUnit.year => 365,
    };
    return numberOfPeriods * numberOfUnits * unitDays;
  }

  int _storeKit2PeriodDays({
    required int periodCount,
    required int value,
    required SK2SubscriptionPeriodUnit unit,
  }) {
    final unitDays = switch (unit) {
      SK2SubscriptionPeriodUnit.day => 1,
      SK2SubscriptionPeriodUnit.week => 7,
      SK2SubscriptionPeriodUnit.month => 30,
      SK2SubscriptionPeriodUnit.year => 365,
    };
    return periodCount * value * unitDays;
  }

  int _planSortOrder(String productId) {
    if (productId == weeklyPlan) return 0;
    if (productId == monthlyPlan) return 1;
    if (productId == yearlyPlan) return 2;
    if (productId == unlimitedPlan) return 3;
    return 99;
  }

  int? _planDurationDays(String productId) {
    if (productId == weeklyPlan) return 7;
    if (productId == monthlyPlan) return 30;
    if (productId == yearlyPlan) return 365;
    return null;
  }

  ProductDetails? _findProduct(String productId) {
    for (final product in _products) {
      if (product.id == productId) {
        return product;
      }
    }
    return null;
  }

  int? _calculateSavingsPercent(ProductDetails product) {
    if (_isApplePlatform && product.id == monthlyPlan) {
      final weeklyProduct = _findProduct(weeklyPlan);
      final productDays = _planDurationDays(product.id);
      final weeklyDays = _planDurationDays(weeklyPlan);

      if (weeklyProduct == null || productDays == null || weeklyDays == null) {
        return null;
      }

      final equivalentFullPrice =
          weeklyProduct.rawPrice * (productDays / weeklyDays);

      if (equivalentFullPrice <= 0 || product.rawPrice >= equivalentFullPrice) {
        return null;
      }

      final savingsPercent =
          ((equivalentFullPrice - product.rawPrice) / equivalentFullPrice) *
          100;

      return savingsPercent.round();
    }

    final monthlyProduct = _findProduct(monthlyPlan);
    final productDays = _planDurationDays(product.id);
    final monthlyDays = _planDurationDays(monthlyPlan);

    if (monthlyProduct == null ||
        product.id != yearlyPlan ||
        productDays == null ||
        monthlyDays == null) {
      return null;
    }

    final equivalentFullPrice =
        monthlyProduct.rawPrice * (productDays / monthlyDays);

    if (equivalentFullPrice <= 0 || product.rawPrice >= equivalentFullPrice) {
      return null;
    }

    final savingsPercent =
        ((equivalentFullPrice - product.rawPrice) / equivalentFullPrice) * 100;

    return savingsPercent.round();
  }

  Widget _buildSavingsBadge(BuildContext context, int savingsPercent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: smallLabel(
        context,
        'Save $savingsPercent%',
        color: Colors.green.shade700,
        textSize: 9,
      ),
    );
  }

  Future<void> _savePurchaseState(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSubscribed', true);
    await prefs.setString('purchasedPlan', productId);

    if (productId == unlimitedPlan) {
      await prefs.remove('subscriptionExpiryDate');
      if (!mounted) return;
      setState(() {
        _isSubscribed = true;
        _purchasedPlan = productId;
        subscriptionExpiryDate = null;
      });
      return;
    }

    final durationDays = _planDurationDays(productId);
    if (durationDays == null) {
      return;
    }

    final expiryDate = DateTime.now().add(Duration(days: durationDays));
    await prefs.setString(
      'subscriptionExpiryDate',
      expiryDate.toIso8601String(),
    );

    if (!mounted) return;
    setState(() {
      _isSubscribed = true;
      _purchasedPlan = productId;
      subscriptionExpiryDate = expiryDate;
    });
  }

  /// Handle purchase updates.
  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (var purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
          debugPrint('Purchase successful: ${purchase.productID}');
          if (purchase.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(purchase);
          }
          if (!_productIds.contains(purchase.productID)) {
            continue;
          }
          await _savePurchaseState(purchase.productID);
          await SubscriptionService.instance.refresh();
          _closeDialog(result: true);

          break;
        case PurchaseStatus.restored:
          debugPrint('Purchase restored: ${purchase.productID}');
          if (purchase.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(purchase);
          }
          if (!_productIds.contains(purchase.productID)) {
            continue;
          }
          await _savePurchaseState(purchase.productID);
          await SubscriptionService.instance.refresh();
          _closeDialog(result: true);

          break;
        case PurchaseStatus.error:
          debugPrint('Purchase error: ${purchase.error}');
          if (mounted)
            setState(() {
              _isProcessing = false;
              _errorMessage =
                  purchase.error?.message ??
                  'Purchase failed. Please try again.';
            });
          break;
        case PurchaseStatus.pending:
          if (mounted) setState(() => _isProcessing = true);
          break;
        case PurchaseStatus.canceled:
          if (mounted) setState(() => _isProcessing = false);
          break;
        default:
          break;
      }
    }
  }

  /// Initiate a purchase flow.
  Future<void> _buyProduct(String selectedProductKey) async {
    final product = _products.firstWhere(
      (p) =>
          _selectionKeyForProduct(p) == selectedProductKey ||
          p.id == selectedProductKey,
      orElse: () => throw Exception('Product not found'),
    );

    if (_isWindowsPlatform) {
      if (_isProcessing) return;
      setState(() {
        _isProcessing = true;
        _errorMessage = null;
      });
      try {
        final success = await WindowsIapService.instance.purchase(product.id);
        if (success) {
          await SubscriptionService.instance.refresh();
          await _loadSubscriptionStatus();
          _closeDialog(result: true);
        } else if (mounted) {
          setState(() {
            _isProcessing = false;
            _errorMessage = 'Purchase was not completed.';
          });
        }
      } catch (_) {
        if (mounted)
          setState(() {
            _isProcessing = false;
            _errorMessage = 'Unable to start purchase. Please try again.';
          });
      }
      return;
    }

    final purchaseParam = product is GooglePlayProductDetails
        ? GooglePlayPurchaseParam(
            productDetails: product,
            offerToken: product.offerToken,
          )
        : PurchaseParam(productDetails: product);
    // Use buyConsumable for points or buyNonConsumable Education subscription based on your product type.
    if (_isProcessing || _isUnsupportedPlatform) return;
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });
    try {
      final started = await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
      if (!started && mounted) setState(() => _isProcessing = false);
    } catch (_) {
      if (mounted)
        setState(() {
          _isProcessing = false;
          _errorMessage = 'Unable to start purchase. Please try again.';
        });
    }
  }

  /// Restore previous purchases.
  Future<void> _restorePurchases() async {
    if (_isProcessing || _isUnsupportedPlatform) return;
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });
    if (_isWindowsPlatform) {
      try {
        await SubscriptionService.instance.refresh();
        await _loadSubscriptionStatus();
        if (_isSubscribed) {
          _closeDialog(result: true);
        } else if (mounted) {
          setState(() => _errorMessage = 'No previous purchase found.');
        }
      } catch (_) {
        if (mounted)
          setState(
            () => _errorMessage =
                'Unable to restore purchases. Please try again.',
          );
      } finally {
        if (mounted) setState(() => _isProcessing = false);
      }
      return;
    }
    try {
      await _inAppPurchase.restorePurchases();
    } catch (_) {
      if (mounted)
        setState(
          () =>
              _errorMessage = 'Unable to restore purchases. Please try again.',
        );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  /// Safely close the dialog ensuring Navigator.pop is only called once.
  void _closeDialog({required bool result}) {
    if (_isDialogClosed || !mounted) return;
    _isDialogClosed = true;

    // Delay the pop call to let any ongoing transitions complete.
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        Navigator.of(context).pop(result);
      }
    });
  }

  /// Helper to return a human-readable plan name.
  String getPlanName(String planId) {
    if (planId == unlimitedPlan) return "Lifetime Plan";
    if (planId == yearlyPlan) return "Yearly Plan";
    if (planId == monthlyPlan) return "Monthly Plan";
    if (planId == weeklyPlan) return "Weekly Plan";
    return "Subscription";
  }

  @override
  void dispose() {
    _purchaseSubscription.cancel();
    super.dispose();
  }

  /// Whether we should surface a free trial for the currently selected plan.
  /// Intro offers on Apple are per-introductory-offer-eligible user and per
  /// subscription group, so we show the trial banner whenever the flavor
  /// advertises a trial length and the user is not already subscribed.
  bool get _showFreeTrialBanner =>
      !_isSubscribed &&
      hasFreeTrial &&
      _isTrialEligibleProduct(_selectedBaseProductId) &&
      _selectedProductSupportsConfiguredTrial;

  bool get _selectedProductSupportsConfiguredTrial {
    final product = _selectedProduct;
    if (product == null) return false;
    return _hasStoreConfiguredFreeTrial(product);
  }

  String get _freeTrialHeadline {
    final days = freeTrialDays;
    final dayWord = days == 1 ? 'day' : 'days';
    return 'Free for the first $days $dayWord';
  }

  String _trialBodyForProduct(ProductDetails? product) {
    final days = freeTrialDays;
    final dayWord = days == 1 ? 'day' : 'days';
    final storeName = defaultTargetPlatform == TargetPlatform.android
        ? 'Google Play'
        : 'the App Store';
    if (product == null) {
      return 'Start your $days-$dayWord free trial. '
          'Cancel anytime in $storeName before the trial ends.';
    }
    return 'Start your $days-$dayWord free trial, then ${product.price} '
        'for the ${getPlanName(product.id)}. '
        'Cancel anytime in $storeName before the trial ends.';
  }

  String get _emptyProductsMessage {
    if (kDebugMode && defaultTargetPlatform == TargetPlatform.android) {
      return 'No subscription plans available right now. For Android purchase '
          'testing, install this app from a Google Play testing track with a '
          'license tester account.';
    }
    if (_isWindowsPlatform && WindowsIapService.instance.configuredPlans.isEmpty) {
      return 'No subscription plans are configured for Windows yet.';
    }
    if (_isWindowsPlatform) {
      return 'No subscription plans available right now. Install this app '
          'from the Microsoft Store to purchase.';
    }
    return 'No subscription plans available right now. Please check your store '
        'setup and try again.';
  }

  Widget _buildFreeTrialBanner(BuildContext context) {
    final selected = _selectedProduct;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.card_giftcard, color: Colors.green.shade700, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                smallLabel(
                  context,
                  _freeTrialHeadline,
                  color: Colors.green.shade800,
                  textSize: 13,
                ),
                const SizedBox(height: 2),
                smallLabel(
                  context,
                  _trialBodyForProduct(selected),
                  color: Colors.black87,
                  textSize: 11,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dialogBody = _isLoading
        ? const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          )
        : _isSubscribed
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                smallLabel(
                  context,
                  "You are subscribed to: ${getPlanName(_purchasedPlan)}",
                ),
                const SizedBox(height: 8),
                smallLabel(
                  context,
                  "Expires on: ${subscriptionExpiryDate != null ? DateFormat.yMMMd().format(subscriptionExpiryDate!) : 'No Expiry Date'}",
                ),
              ],
            ),
          )
        : _products.isEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: smallLabel(
              context,
              _emptyProductsMessage,
              textSize: 13,
              color: Colors.black87,
            ),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_showFreeTrialBanner) _buildFreeTrialBanner(context),
              for (final product in _products)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: RadioListTile<String>(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: smallLabel(
                            context,
                            '${product.title} (${product.price})',
                            textSize: 15,
                          ),
                        ),
                        if (_calculateSavingsPercent(product)
                            case final savings?)
                          _buildSavingsBadge(context, savings),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: smallLabel(
                        context,
                        _productDescription(product),
                        textSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                    value: _selectionKeyForProduct(product),
                    groupValue: _selectedProductId,
                    onChanged: (value) {
                      setState(() => _selectedProductId = value);
                    },
                  ),
                ),
            ],
          );

    final mediaQuery = MediaQuery.of(context);
    final dialogWidth = (mediaQuery.size.width - 32)
        .clamp(280.0, 420.0)
        .toDouble();
    final dialogMaxHeight = mediaQuery.size.height * 0.65;

    return AlertDialog(
      scrollable: true,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          title15BoldColor(context, 'Unlock Premium Access'),
          if (_errorMessage != null)
            Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
          if (_isProcessing) const LinearProgressIndicator(),
          const SizedBox(height: 12),
          smallLabel(
            context,
            '${_showFreeTrialBanner ? '🎁 Free for the first $freeTrialDays days\n' : ''}'
            '✅ Conquer the $app_title with all-in-one study tools\n'
            '✅ Learn anytime with offline access\n'
            '✅ Stay updated with fresh exam content\n'
            '✅ Enjoy interactive quizzes & performance tracking',
            textSize: 13,
          ),
        ],
      ),
      content: SizedBox(
        width: dialogWidth,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: dialogMaxHeight),
          child: SingleChildScrollView(child: dialogBody),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isProcessing ? null : () => _closeDialog(result: false),
          child: smallLabel(context, 'Cancel', textSize: 13),
        ),
        if (!_isSubscribed) ...[
          TextButton(
            onPressed: _isProcessing ? null : _restorePurchases,
            child: smallLabel(context, 'Restore', textSize: 13),
          ),
          if (_products.isNotEmpty)
            TextButton(
              onPressed: _isProcessing
                  ? null
                  : () {
                      if (_selectedProductId != null) {
                        _buyProduct(_selectedProductId!);
                      } else {
                        return;
                      }
                    },
              child: smallLabel(
                context,
                _showFreeTrialBanner ? 'Start Free Trial' : 'Purchase',
                textSize: 14,
                color: Colors.red,
              ),
            ),
        ],
      ],
    );
  }

  String _productDescription(ProductDetails product) {
    if (hasFreeTrial &&
        _isTrialEligibleProduct(product.id) &&
        _hasStoreConfiguredFreeTrial(product)) {
      return '${product.description}\nFree for the first $freeTrialDays days for eligible users.';
    }
    return product.description;
  }
}
