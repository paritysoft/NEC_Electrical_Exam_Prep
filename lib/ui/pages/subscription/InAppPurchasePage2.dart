import 'dart:async';
import 'package:electrician/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../../util/AppColors.dart';
import '../../../util/app_constants.dart';
import '../explore_screen/explore_screen.dart';

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
  String selectedPlan = "";
  DateTime? subscriptionExpiryDate;
  List<ProductDetails> _products = [];
  final Set<String> _processedPurchaseIds = {};

  final Set<String> _productIds = {
    weeklyPlan, // Replace with your product ID for weekly
    monthlyPlan, // Replace with your product ID for monthly
    yearlyPlan, // Replace with your product ID for yearly
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
        "Unknown Plan"; // Default to "Unknown Plan" if ID not found
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

    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(_productIds);

    if (response.error != null) {
      print("Error fetching product details: ${response.error}");
      return;
    }

    if (response.productDetails.isEmpty) {
      print("No products found. Check your product IDs in the store.");
    } else {
      print(
          "Products fetched: ${response.productDetails.map((p) => p.id).toList()}");
    }

    setState(() {
      _products = response.productDetails;
    });
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      if (_processedPurchaseIds.contains(purchaseDetails.purchaseID)) {
        // Skip already processed purchases
        continue;
      }

      _processedPurchaseIds.add(purchaseDetails.purchaseID ?? "");

      if (purchaseDetails.status == PurchaseStatus.purchased) {
        print("Purchase successful: ${purchaseDetails.productID}");
        _verifyPurchase(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.restored) {
        print("Purchase restored: ${purchaseDetails.productID}");
        _verifyPurchase(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        print("Purchase error: ${purchaseDetails.error}");
      }
    }
  }

  Future<void> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.pendingCompletePurchase) {
      await _inAppPurchase.completePurchase(purchaseDetails);

      if (_productIds.contains(purchaseDetails.productID)) {
        final prefs = await SharedPreferences.getInstance();
        DateTime now = DateTime.now();
        DateTime expiryDate;

        if (purchaseDetails.productID == weeklyPlan) {
          expiryDate = now.add(Duration(days: 7));
        } else if (purchaseDetails.productID == monthlyPlan) {
          expiryDate = now.add(Duration(days: 30));
        } else if (purchaseDetails.productID == yearlyPlan) {
          expiryDate = now.add(Duration(days: 365));
        } else {
          return; // Invalid product ID
        }

        await prefs.setBool('isSubscribed', true);
        await prefs.setString('purchasedPlan', purchaseDetails.productID);
        await prefs.setString(
            'subscriptionExpiryDate', expiryDate.toIso8601String());

        setState(() {
          isSubscribed = true;
          purchasedPlan = purchaseDetails.productID;
          subscriptionExpiryDate = expiryDate;
        });

        print(
            "Subscription for $purchasedPlan activated. Expiry date: $expiryDate");
      }
    }
  }

  void _buyProduct(ProductDetails product) {
    if (purchasedPlan == product.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You are already subscribed to this plan.")),
      );
      return;
    }

    setState(() {
      isProcessingBuy = true;
    });

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);

    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam).then((_) {
      // Reset isProcessingBuy after success
      setState(() {
        isProcessingBuy = false;
      });
    }).catchError((error) {
      // Handle error and reset isProcessingBuy
      print("Error purchasing product: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error purchasing product: $error"),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isProcessingBuy = false; // Reset after failure
      });
    });
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
                await prefs.setString('purchasedPlan', purchaseDetails.productID);

                setState(() {
                  isSubscribed = true;
                  purchasedPlan = purchaseDetails.productID;
                });
              }
            }
          }
        },
        onError: (error) {
          print("Error: $error");
          snackBar(context, "Error restoring purchases: $error");
          setState(() {
            isProcessing = false;
          });
        },
        onDone: () {
          print("Done restoring purchases");
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
      print("Error occurred during restore: $e");
      snackBar(context, "An error occurred: $e");
      setState(() {
        isProcessing = false;
      });
    }finally{
      setState(() {
        isProcessing = false;
      });
      snackBar(context, "No purchases found to restore.");

    }
  }

  // Future<void> _restorePurchases() async {
  //   setState(() {
  //     isProcessing = true;
  //   });
  //
  //   bool restoredAny = false;
  //
  //   try {
  //     await _inAppPurchase.restorePurchases();
  //
  //     // Listen for restored purchases via the purchase stream
  //     final Stream<List<PurchaseDetails>> purchaseUpdated =
  //         _inAppPurchase.purchaseStream;
  //     final subscription = purchaseUpdated.listen(
  //       (purchases) async {
  //         for (var purchaseDetails in purchases) {
  //           if (purchaseDetails.status == PurchaseStatus.restored) {
  //             restoredAny = true;
  //
  //             if (purchaseDetails.pendingCompletePurchase) {
  //               await _inAppPurchase.completePurchase(purchaseDetails);
  //             }
  //
  //             if (_productIds.contains(purchaseDetails.productID)) {
  //               // Save subscription details to SharedPreferences
  //               final prefs = await SharedPreferences.getInstance();
  //               await prefs.setBool('isSubscribed', true);
  //               await prefs.setString(
  //                   'purchasedPlan', purchaseDetails.productID);
  //
  //               setState(() {
  //                 isSubscribed = true;
  //                 purchasedPlan = purchaseDetails.productID;
  //               });
  //             }
  //           }
  //         }
  //       },
  //       onError: (error) {
  //         snackBar(context, "Error restoring purchases: $error");
  //
  //
  //       },
  //       onDone: () {
  //         if (restoredAny) {
  //           snackBar(context, "Purchases restored successfully!");
  //         } else {
  //           snackBar(context, "No purchases found to restore.");
  //           _subscription.cancel();
  //           setState(() {
  //             isProcessing = false;
  //           });
  //         }
  //       },
  //     );
  //   } catch (e) {
  //     snackBar(context, "An error occurred: $e");
  //
  //     setState(() {
  //       isProcessing = false;
  //     });
  //   } finally {
  //     // snackBar(context, "An error occurred:");
  //
  //     setState(() {
  //       isProcessing = false;
  //     });
  //   }
  // }

  // Future<void> _restorePurchases() async {
  //   try {
  //   var ad =  await _inAppPurchase.restorePurchases();
  //   } catch (e) {
  //     print("Error restoring purchases: $e");
  //   }
  // }
  // Future<void> _restorePurchases() async {
  //   try {
  //     // Trigger the restoration of purchases
  //     await _inAppPurchase.restorePurchases();
  //
  //     // Listen for restored purchases via the purchase stream
  //     final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
  //     final subscription = purchaseUpdated.listen(
  //           (purchases) async {
  //         for (var purchaseDetails in purchases) {
  //           if (purchaseDetails.status == PurchaseStatus.restored) {
  //             if (purchaseDetails.pendingCompletePurchase) {
  //               await _inAppPurchase.completePurchase(purchaseDetails);
  //             }
  //
  //             // Verify the product ID exists in your product list
  //             if (_productIds.contains(purchaseDetails.productID)) {
  //               // Save subscription details to SharedPreferences
  //               final prefs = await SharedPreferences.getInstance();
  //               await prefs.setBool('isSubscribed', true);
  //               await prefs.setString('purchasedPlan', purchaseDetails.productID);
  //
  //               setState(() {
  //                 isSubscribed = true;
  //                 purchasedPlan = purchaseDetails.productID;
  //               });
  //             }
  //           }
  //         }
  //       },
  //       onError: (error) {
  //         print("Error in purchase stream: $error");
  //       },
  //       onDone: () {
  //         _subscription.cancel();
  //       },
  //     );
  //   } catch (e) {
  //     print("Error restoring purchases: $e");
  //   }
  // }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: primary,
          elevation: 0,
          title: title15BoldColor(context, "In-App Purchases",
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
      body: Column(
        children: [
          // Promotional Section
          Container(
            color: primary,
            width: double.infinity,
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Achieve Your Goals with Premium Features!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "• 2500+ questions and explanations to practice\n"
                  "• Improve faster with subject-based practice and performance analysis\n"
                  "• Unlimited access to 6 efficient exercise modes\n"
                  "• Guaranteed to pass the exam",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
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
                        ? Center(
                            child: Text(
                                "No products available. Check product setup."))
                        : ListView(
                            children: [
                              ..._products.map((product) {
                                return ListTile(
                                  onTap: () {
                                    setState(() {
                                      selectedPlan = product.id;
                                    });
                                  },
                                  title: Text(product.title),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Description: ${product.description}"),
                                      Text("Price: ${product.price}"),
                                    ],
                                  ),
                                  leading: Radio<String>(
                                    value: product.id,
                                    groupValue: selectedPlan,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedPlan = value!;
                                      });
                                    },
                                  ),
                                  trailing: purchasedPlan == product.id
                                      ? Text(
                                          "Purchased",
                                          style: TextStyle(color: Colors.green),
                                        )
                                      : isProcessingBuy
                                          ? CircularProgressIndicator() // Show progress bar
                                          : ElevatedButton(
                                              onPressed:
                                                  selectedPlan == product.id
                                                      ? () {
                                                          _buyProduct(product);
                                                        }
                                                      : null,
                                              child: Text('Buy'),
                                            ),
                                );
                              }).toList(),
                              Divider(),
                              Center(
                                child: isProcessing
                                    ? CircularProgressIndicator() // Show progress bar
                                    : ElevatedButton(
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
    );
  }
}
