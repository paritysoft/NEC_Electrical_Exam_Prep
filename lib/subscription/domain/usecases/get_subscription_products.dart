import 'package:dartz/dartz.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

import '../../core/error/exception.dart';
import '../../core/usecase/usecase.dart';
import '../../data/repositories/subscription_repository.dart';

class GetSubscriptionProducts
    extends UseCase<List<IAPItem>, GetSubscriptionProductsParam> {
  final SubscriptionRepository repository;
  GetSubscriptionProducts(this.repository);
  @override
  Future<Either<Failure, List<IAPItem>>> call(
      GetSubscriptionProductsParam params) async {
    return await repository.getSubscriptionProducts(params.productsIds);
  }
}

class GetSubscriptionProductsParam extends NoParam {
  final List<String> productsIds;
  GetSubscriptionProductsParam(this.productsIds);

  @override
  List<Object?> get props => [productsIds];

  @override
  bool? get stringify => true;
}
