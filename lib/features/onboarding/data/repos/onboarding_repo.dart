import '../models/onboarding_model.dart';

abstract class OnboardingRepo {
  Future<OnboardingModel> getOnboardingData();

  void persistSelection({required String goalId, required String availability});
}
