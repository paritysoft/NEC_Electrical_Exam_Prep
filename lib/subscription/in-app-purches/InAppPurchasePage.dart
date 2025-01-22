import 'dart:async';
import 'package:electrician/subscription/core/sharepref_helper.dart';
import 'package:electrician/ui/pages/home.dart';
import 'package:electrician/ui/pages/home_updated.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchasePage extends StatefulWidget {
  @override
  State<InAppPurchasePage> createState() => _InAppPurchasePageState();
}

class _InAppPurchasePageState extends State<InAppPurchasePage> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription =
  const Stream<List<PurchaseDetails>>.empty().listen((_) {});

  bool _available = false;
  List<ProductDetails> _products = [];
  final Set<String> _productIds = {'com.paritysoft.acnp_exam_prep_mcqs'}; // Replace with your product IDs

  @override
  void initState() {
    super.initState();
    _initializeIAP();

    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdated,
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        print('Purchase Stream Error: $error');
      },
    );
  }

  Future<void> _initializeIAP() async {
    print("Initializing In-App Purchases...");
    _available = await _inAppPurchase.isAvailable();
    if (!_available) {
      print("In-App Purchases are unavailable.");
      setState(() {});
      return;
    }

    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(_productIds);

    if (response.error != null) {
      print("Error fetching product details: ${response.error}");
      return;
    }

    if (response.productDetails.isEmpty) {
      print("No products found. Check your product IDs in the store.");
    } else {
      print("Products fetched: ${response.productDetails.map((p) => p.id).toList()}");
    }

    setState(() {
      _products = response.productDetails;
    });
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        print("Purchase successful: ${purchaseDetails.productID}");
        _verifyPurchase(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        print("Purchase error: ${purchaseDetails.error}");
      }
    }
  }

  Future<void> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // Implement server-side verification for added security
    if (purchaseDetails.pendingCompletePurchase) {
      await _inAppPurchase.completePurchase(purchaseDetails);
      SharedPreferenceHelper.setSubscription(true);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizHomePage(),
        ),
      );
      print("Purchase completed for product: ${purchaseDetails.productID}");
    }
  }

  @override
  void dispose() {
    // Ensure _subscription is initialized before attempting to cancel
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('In-App Purchases')),
      body: _available
          ? (_products.isEmpty
          ? Center(child: Text("No products available. Check product setup."))
          : ListView(
        children: _products.map((product) {
          return ListTile(
            title: Text(product.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Description: ${product.description}"),
                Text("Price: ${product.price}"),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {
                final PurchaseParam purchaseParam =
                PurchaseParam(productDetails: product);
                _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
              },
              child: Text('Buy'),
            ),
          );
        }).toList(),
      ))
          : Center(child: Text('Store unavailable or initialization failed.')),
    );
  }
}
