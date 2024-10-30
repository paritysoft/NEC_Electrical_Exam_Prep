import 'dart:io';
import 'package:dartz/dartz.dart';

import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

import '../../core/error/exception.dart';
import '../../core/usecase/usecase.dart';
import '../../data/repositories/subscription_repository.dart';

class CompleteTransaction extends UseCase<dynamic, CompleteTransactionParam> {
  SubscriptionRepository repository;
  CompleteTransaction(this.repository);
  @override
  Future<Either<Failure, dynamic>> call(CompleteTransactionParam params) {
    if (Platform.isIOS) {
      return repository.completeTransaction(
          transactionId: params.transactionId ?? "");
    } else {
      return repository.completeTransaction(
          item: params.purchasedItem!,
          transactionId: params.transactionId ?? "",
          isConsumable: params.isConsumable ?? false);
    }
  }
}

class CompleteTransactionParam extends NoParam {
  final PurchasedItem? purchasedItem;
  final String? transactionId;
  final bool? isConsumable;
  CompleteTransactionParam(
      {this.purchasedItem, this.transactionId, this.isConsumable});

  @override
  List<Object?> get props => [purchasedItem, transactionId, isConsumable];

  @override
  bool? get stringify => true;
}
