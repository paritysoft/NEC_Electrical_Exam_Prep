import 'package:dartz/dartz.dart';

import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

import '../../core/error/exception.dart';
import '../../core/usecase/usecase.dart';
import '../../data/repositories/subscription_repository.dart';

class GetPastPurchases extends UseCase<List<PurchasedItem>?, NoParam> {
  final SubscriptionRepository repository;
  GetPastPurchases(this.repository);
  @override
  Future<Either<Failure, List<PurchasedItem>?>> call(NoParam params) async {
    return await repository.getPastPurchases();
  }
}
