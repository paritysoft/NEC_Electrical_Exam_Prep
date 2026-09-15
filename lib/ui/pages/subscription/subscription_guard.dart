import 'package:flutter/material.dart';

import 'PurchasePlanDialog.dart';
import 'subscription_service.dart';

Future<void> checkAccessAndNavigate(
  BuildContext context,
  VoidCallback onSuccess,
) async {
  final service = SubscriptionService.instance;
  await service.refresh();
  if (!context.mounted) return;
  if (!service.isSubscribed) {
    final purchased = await PurchasePlanDialog.show(context);
    if (!purchased || !context.mounted) return;
    await service.refresh();
  }
  if (context.mounted && service.isSubscribed) onSuccess();
}
