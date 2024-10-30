import 'package:dartz/dartz.dart';

import '../../core/error/exception.dart';
import '../../core/usecase/usecase.dart';
import '../../data/repositories/subscription_repository.dart';


class InitializeSubscription extends UseCase<dynamic, NoParam> {
  final SubscriptionRepository repository;
  InitializeSubscription(this.repository);
  @override
  Future<Either<Failure, dynamic>> call(NoParam params) {
    return repository.initializeSubscription();
  }
}
