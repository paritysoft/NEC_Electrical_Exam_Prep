import 'package:dartz/dartz.dart';

import '../../core/error/exception.dart';
import '../../core/usecase/usecase.dart';
import '../../data/repositories/subscription_repository.dart';


class CheckSubscriptionReadyStatus extends UseCase<int, NoParam> {
  SubscriptionRepository repository;
  CheckSubscriptionReadyStatus(this.repository);
  @override
  Future<Either<Failure, int>> call(NoParam params) {
    return repository.checkSubscriptionReadyStatus();
  }
}
