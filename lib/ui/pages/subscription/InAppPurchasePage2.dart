import 'dart:async';
import 'package:electrician/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../../util/AppColors.dart';
import '../../../util/app_constants.dart';
import 'package:in_app_purchase/in_app_purchase.dart';


class InAppPurchasePage2 extends StatefulWidget {
  @override
  State<InAppPurchasePage2> createState() => _InAppPurchasePageState();
}

class _InAppPurchasePageState extends State<InAppPurchasePage2> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  bool _available = false;
  bool isSubscribed = false;
  String purchasedPlan = "";
  String selectedPlan = inAppPurchases;
  DateTime? subscriptionExpiryDate;
  List<ProductDetails> _products = [];
  final Set<String> _processedPurchaseIds = {};
  bool isLoading = false;

  final Set<String> _productIds = {
    inAppPurchases, // Replace with your product ID for weekly
    // monthlyPlan, // Replace with your product ID for monthly
    // yearlyPlan, // Replace with your product ID for yearly
  };
  bool isProcessing = false;
  bool isProcessingBuy = false;

  @override
  void initState() {
    super.initState();
    _checkSubscriptionStatus();
    _initializeIAP();

    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
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

  Future<void> _checkSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSubscribed = prefs.getBool('isSubscribed') ?? false;
      purchasedPlan = prefs.getString('purchasedPlan') ?? "";
      final expiryDateString = prefs.getString('subscriptionExpiryDate');
      if (expiryDateString != null) {
        subscriptionExpiryDate = DateTime.parse(expiryDateString);
      }
    });

    // Check if the subscription has expired
    if (subscriptionExpiryDate != null &&
        DateTime.now().isAfter(subscriptionExpiryDate!)) {
      await _clearSubscriptionData();
    }
  }

  final Map<String, String> planNames = {
    weeklyPlan: "Weekly Plan",
    monthlyPlan: "Monthly Plan",
    yearlyPlan: "Yearly Plan",
  };

  String getPlanName(String productId) {
    return planNames[productId] ??
        "Unlimited Plan"; // Default to "Unknown Plan" if ID not found
  }

  Future<void> _clearSubscriptionData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      isSubscribed = false;
      purchasedPlan = "";
      subscriptionExpiryDate = null;
    });
    print("Subscription data cleared. Subscription has expired.");
  }

  Future<void> _initializeIAP() async {
    print("Initializing In-App Purchases...");
    _available = await _inAppPurchase.isAvailable();
    if (!_available) {
      print("In-App Purchases are unavailable.");
      setState(() {});
      return;
    }

    await _checkPendingTransactions(); // 🔥 Call this to complete any pending transactions

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

  Future<void> _checkPendingTransactions() async {
    // Restore past purchases
    await _inAppPurchase.restorePurchases();

    // Listen for restored purchases
    final Stream<List<PurchaseDetails>> purchaseUpdates = _inAppPurchase.purchaseStream;

    purchaseUpdates.listen((List<PurchaseDetails> purchases) async {
      for (var purchase in purchases) {
        if (purchase.status == PurchaseStatus.purchased && purchase.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchase);
          print("Completed pending transaction for ${purchase.productID}");
        }
      }
    }, onError: (error) {
      print("Error in purchase stream: $error");
    });
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      if (_processedPurchaseIds.contains(purchaseDetails.purchaseID)) {
        continue; // Skip already processed purchases
      }
      _processedPurchaseIds.add(purchaseDetails.purchaseID ?? "");

      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        print("Purchase successful: ${purchaseDetails.productID}");
        await _verifyPurchase(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        print("Purchase error: ${purchaseDetails.error}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Purchase error: ${purchaseDetails.error?.message}")),
        );
      }
    }
  }


  Future<void> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.pendingCompletePurchase) {
      await _inAppPurchase.completePurchase(purchaseDetails);
    }

    if (_productIds.contains(purchaseDetails.productID)) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isSubscribed', true);
      await prefs.setString('purchasedPlan', purchaseDetails.productID);

      setState(() {
        isSubscribed = true;
        purchasedPlan = purchaseDetails.productID;
      });

      print("Subscription activated for ${purchaseDetails.productID}");
    }
  }

  void _selectPlan(ProductDetails product) {
    setState(() {
      selectedProduct = product;
      selectedPlan = product.id;
      _buyProduct(product);
    });
  }

  late ProductDetails selectedProduct;

  void _buyProduct(ProductDetails product) async {
    setState(() {
      isLoading = true;
    });

    // Check if there's a pending transaction for this product
    // final QueryPurchaseDetailsResponse response = await _inAppPurchase.queryPastPurchases();
    // for (var purchase in response.pastPurchases) {
    //   if (purchase.productID == product.id && purchase.pendingCompletePurchase) {
    //     print("Pending transaction found. Completing purchase for ${product.id}");
    //     await _inAppPurchase.completePurchase(purchase);
    //     setState(() {
    //       isLoading = false;
    //     });
    //     return;
    //   }
    // }
    final Stream<List<PurchaseDetails>> purchaseUpdates = _inAppPurchase.purchaseStream;

    purchaseUpdates.listen((List<PurchaseDetails> purchases) async {
      for (PurchaseDetails purchase in purchases) {
        if (purchase.productID == product.id && purchase.pendingCompletePurchase) {
          print("Pending transaction found. Completing purchase for ${product.id}");
          await _inAppPurchase.completePurchase(purchase);
          setState(() {
            isLoading = false;
          });
          return;
        }
      }
    }, onError: (error) {
      print("Error in purchase stream: $error");
    });

    if (purchasedPlan == product.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You are already subscribed to this plan.")),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    setState(() {
      isProcessingBuy = true;
    });

    try {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (error) {
      print("Error purchasing product: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error purchasing product: $error"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isProcessingBuy = false;
        isLoading = false;
      });
    }
  }

  Future<void> _restorePurchases() async {
    setState(() {
      isProcessing = true;
    });

    bool restoredAny = false;
    late StreamSubscription<List<PurchaseDetails>> subscription; // Declare subscription earlier

    try {
      await _inAppPurchase.restorePurchases();

      final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;

      subscription = purchaseUpdated.listen(
        (purchases) async {
          print("Restored purchases: $purchases");
          for (var purchaseDetails in purchases) {
            if (purchaseDetails.status == PurchaseStatus.restored) {
              restoredAny = true;

              if (purchaseDetails.pendingCompletePurchase) {
                await _inAppPurchase.completePurchase(purchaseDetails);
              }

              if (_productIds.contains(purchaseDetails.productID)) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isSubscribed', true);
                await prefs.setString(
                    'purchasedPlan', purchaseDetails.productID);

                setState(() {
                  isSubscribed = true;
                  purchasedPlan = purchaseDetails.productID;
                });
              }
            } else {
              snackBar(context, "No purchases found to restore.");
            }
          }
        },
        onError: (error) {
          print("Restored Error: $error");
          snackBar(context, "Error restoring purchases: $error");
          setState(() {
            isProcessing = false;
          });
        },
        onDone: () {
          print("Done Restored purchases");
          if (restoredAny) {
            snackBar(context, "Purchases restored successfully!");
          } else {
            snackBar(context, "No purchases found to restore.");
          }
          setState(() {
            isProcessing = false;
          });
          subscription.cancel();
        },
      );
      subscription.cancel();
    } catch (e) {
      print("Error occurred during Restored: $e");
      snackBar(context, "An error occurred: $e");
      setState(() {
        isProcessing = false;
      });
    } finally {
      setState(() {
        isProcessing = false;
      });
      //  snackBar(context, "No purchases found to restore.");
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate crossAxisCount based on screen width
    int crossAxisCount = screenWidth > 600 ? 3 : 2; // Example: 3 columns on tablets, 2 on phones
    double textSize = crossAxisCount == 3 ? 12.0 : 16.0; // Adjust the font size accordingly

    return Scaffold(
      appBar: AppBar(
          backgroundColor: primary,
          elevation: 0,
          title: title15BoldColor(context, "Unlock Your Ultimate NEC Electrical Exam Prep!",
              color: Colors.white),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          // <= You can change your color here.),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Return to the previous screen with a value
              Navigator.pop(context, true);
            },
          )),
      body: Stack(
        children: [
          Column(
            children: [
              // Promotional Section
              Container(
                color: primary,
                width: double.infinity,
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    smallLabel(
                        context,
                    "✅ 1300+ Expert-Crafted Questions\n"
                    "✅ Unlimited Access, One-Time Purchase – No subscriptions, no hidden fees—pay once, enjoy forever!\n"
                    "✅ Exclusive Study Features – Track progress, review weak areas, and stay ahead with real-time insights.\n"
                    "✅ Offline Access – Study anytime, anywhere, even without the internet.\n"
                    "✅ Support & Updates – Help us improve and add new features! 🚀\n"
                    "🎯 Invest in Your Future—Get Lifetime Access Today! \n",
                        textSize: textSize,
                        color: Colors.white
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Expanded(
                child: _available
                    ? (isSubscribed
                    ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            "You are subscribed to: ${getPlanName(purchasedPlan)}"),
                        Text(
                            "Expires on: ${subscriptionExpiryDate != null ? DateFormat.yMMMd().format(subscriptionExpiryDate!) : 'No Expiry Date'}"),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Navigator.pop(context);
                            Navigator.pop(context, true);
                          },
                          child: Text("Go Back"),
                        ),
                      ],
                    ),
                  ),
                )
                    : (_products.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: _products.map((product) {
                        if (product.id == inAppPurchases) {
                          selectedProduct = product;
                        }
                        return SubscriptionCard(
                          product: product,
                          isSelected: selectedPlan == product.id,
                          onTap: () => {_selectPlan(product)},
                          //onBuy: () => _buyProduct(product),
                          //selectedPlan: selectedPlan,
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 8,
                    ),

                    Center(
                      child: isProcessingBuy
                          ? CircularProgressIndicator() // Show progress bar
                          : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          // Button color
                          foregroundColor: Colors.white,
                          // Text color
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 40),
                          // Larger padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12), // Rounded corners
                          ),
                          elevation: 8,
                          // Adds shadow effect for focus
                          shadowColor: Colors
                              .black54, // Slight shadow color
                        ),
                        onPressed: () =>
                            _buyProduct(selectedProduct),
                        child: title15BoldColor(context,
                          "Purchase Now",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Divider(),
                    SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: isProcessing
                          ? CircularProgressIndicator() // Show progress bar
                          : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 24), // Larger padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12), // Rounded corners
                          ),
                          elevation:
                          2, // Adds shadow effect for focus
                          shadowColor: Colors
                              .black54, // Slight shadow color
                        ),
                        onPressed: _restorePurchases,
                        child: Text("Restore Purchases"),
                      ),
                    ),
                  ],
                )))
                    : Center(
                  child: Text('Store unavailable or initialization failed.'),
                ),
              ),
            ],
          ),
          if (isLoading)
            Positioned(
              top: 50, // Adjust top position
              left: 0,
              right: 0,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final ProductDetails product;
  final bool isSelected;
  final VoidCallback onTap;

  SubscriptionCard({
    required this.product,
    required this.isSelected,
    required this.onTap,
  });

  String calculatePerDayCost(String price, int duration) {
    double priceValue =
        double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
    double perDayCost = priceValue / duration;
    return "\$${perDayCost.toStringAsFixed(2)}/day";
  }

  @override
  Widget build(BuildContext context) {
    int durationDays = product.id.contains("weekly")
        ? 7
        : product.id.contains("monthly")
            ? 30
            : 365;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.fromLTRB(23,10, 23, 10),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: Colors.blue.shade200,
                      blurRadius: 10,
                      spreadRadius: 4)
                ]
              : [BoxShadow(color: Colors.grey.shade300, blurRadius: 8)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                     Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: title15BoldColor(
                  context, isSelected ? "Life Time Subscription" : "Choose Plan",
                  color: isSelected ? Colors.white : Colors.white),
            ),
            SizedBox(height: 10,),
            title15BoldColor(
              context,
              "Only ${product.price}",
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ],
        ),
      ),
    );
  }
}

