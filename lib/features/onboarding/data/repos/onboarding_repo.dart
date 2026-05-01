import '../models/onboarding_model.dart';

abstract class OnboardingRepo {
  Future<OnboardingModel> getOnboardingData();
}
