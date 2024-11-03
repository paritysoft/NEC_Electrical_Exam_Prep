import 'package:electrician/subscription/presentation/subscription/screen/subscription_screen.dart';
import 'package:flutter/material.dart';

class SubscriptionPage extends StatelessWidget {
  static String tag = 'subscription-page';
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SubscriptionScreen());
  }
}
