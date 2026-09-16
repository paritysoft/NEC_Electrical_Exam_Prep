import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:electrician/ui/pages/subscription/PurchasePlanDialog.dart';
import 'package:electrician/ui/pages/subscription/subscription_service.dart';
import 'package:electrician/util/app_constants.dart';

class TestStore extends InAppPurchasePlatform {
  final updates = StreamController<List<PurchaseDetails>>.broadcast();
  Set<String>? queriedIds;
  @override
  Stream<List<PurchaseDetails>> get purchaseStream => updates.stream;
  @override
  Future<bool> isAvailable() async => true;
  @override
  Future<ProductDetailsResponse> queryProductDetails(
    Set<String> identifiers,
  ) async {
    queriedIds = identifiers;
    return ProductDetailsResponse(
      productDetails: [
        ProductDetails(
          id: monthlyPlan,
          title: 'Monthly Access',
          description: 'One month of NEC study features',
          price: r'$4.99',
          rawPrice: 4.99,
          currencyCode: 'USD',
        ),
        ProductDetails(
          id: unlimitedPlan,
          title: 'Lifetime Access',
          description: 'All NEC study features',
          price: r'$19.99',
          rawPrice: 19.99,
          currencyCode: 'USD',
        ),
      ],
      notFoundIDs: [],
    );
  }

  @override
  Future<bool> buyNonConsumable({required PurchaseParam purchaseParam}) async {
    emitPurchase(purchaseParam.productDetails.id, PurchaseStatus.purchased);
    return true;
  }

  @override
  Future<void> restorePurchases({String? applicationUserName}) async {
    emitPurchase(unlimitedPlan, PurchaseStatus.restored);
  }

  void emitPurchase(String id, PurchaseStatus status) {
    updates.add([
      PurchaseDetails(
        purchaseID: 'test',
        productID: id,
        verificationData: PurchaseVerificationData(
          localVerificationData: '',
          serverVerificationData: '',
          source: 'test',
        ),
        transactionDate: '0',
        status: status,
      ),
    ]);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late TestStore store;
  setUp(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    // Initialize without registering a native store. Widget tests use Android
    // by default, regardless of the operating system running the tests.
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    InAppPurchase.instance;
    debugDefaultTargetPlatformOverride = null;
    store = TestStore();
    InAppPurchasePlatform.instance = store;
    await SubscriptionService.instance.refresh();
  });
  tearDown(() => store.updates.close());

  test(
    'Recognizes existing lifetime purchase even with stale expiry',
    () async {
      SharedPreferences.setMockInitialValues({
        'purchasedPlan': unlimitedPlan,
        'isSubscribed': true,
        'subscriptionExpiryDate': '2020-01-01',
      });
      await SubscriptionService.instance.refresh();
      expect(SubscriptionService.instance.isSubscribed, isTrue);
    },
  );
  test('Expired access is cleared', () async {
    SharedPreferences.setMockInitialValues({
      'purchasedPlan': monthlyPlan,
      'isSubscribed': true,
      'subscriptionExpiryDate': '2020-01-01',
    });
    await SubscriptionService.instance.refresh();
    expect(SubscriptionService.instance.isSubscribed, isFalse);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('isSubscribed'), isFalse);
  });

  Future<void> openDialog(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => PurchasePlanDialog.show(context),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Unlock Premium Access'), findsOneWidget);
    expect(store.queriedIds, {monthlyPlan, unlimitedPlan});
    expect(find.textContaining('Monthly Access'), findsOneWidget);
    expect(find.textContaining('Lifetime Access'), findsOneWidget);
  }

  for (final platform in [TargetPlatform.windows, TargetPlatform.linux]) {
    testWidgets('$platform does not query an unsupported store', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: PurchasePlanDialog()),
      );
      await tester.pumpAndSettle();
      expect(
        find.text('In-app purchases are not available on this platform.'),
        findsOneWidget,
      );
      expect(store.queriedIds, isNull);
      expect(find.text('Purchase'), findsNothing);
      await tester.tap(find.text('Restore'));
      await tester.pumpAndSettle();
      expect(SubscriptionService.instance.isSubscribed, isFalse);
      expect(tester.takeException(), isNull);
    }, variant: TargetPlatformVariant({platform}));
  }

  testWidgets('Cancel does not grant access', (tester) async {
    await openDialog(tester);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(SubscriptionService.instance.isSubscribed, isFalse);
    expect(find.byType(PurchasePlanDialog), findsNothing);
  });
  for (final action in ['Purchase', 'Restore']) {
    testWidgets('$action updates access and closes dialog', (tester) async {
      await openDialog(tester);
      await tester.tap(find.text(action));
      await tester.pumpAndSettle();
      expect(SubscriptionService.instance.isSubscribed, isTrue);
      expect(find.byType(PurchasePlanDialog), findsNothing);
    });
  }
  testWidgets('Unknown product does not grant access', (tester) async {
    await openDialog(tester);
    store.emitPurchase('another.app.product', PurchaseStatus.restored);
    await tester.pumpAndSettle();
    expect(SubscriptionService.instance.isSubscribed, isFalse);
    expect(find.byType(PurchasePlanDialog), findsOneWidget);
  });
}
