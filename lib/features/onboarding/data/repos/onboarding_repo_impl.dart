import '../models/onboarding_model.dart';
import '../services/onboarding_service.dart';
import 'onboarding_repo.dart';

class OnboardingRepoImpl implements OnboardingRepo {
  OnboardingRepoImpl(this._service);

  final OnboardingService _service;

  @override
  Future<OnboardingModel> getOnboardingData() {
    return _service.loadOnboardingData();
  }
}
