import 'package:dartz/dartz.dart';

import '../../../../core/failures/failure.dart';
import '../models/onboarding_model.dart';

abstract class OnboardingRepo {
  Future<Either<Failure, OnboardingModel>> getOnboardingData();

  Either<Failure, Unit> persistSelection({required String goalId, required String availability});
}
