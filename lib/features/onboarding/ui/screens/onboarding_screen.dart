import 'package:fit_flow/features/onboarding/ui/screens/widgets/failure_massage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../logic/onboarding_cubit.dart';
import 'widgets/onboarding_widgets.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<OnboardingCubit, PlansState>(
          builder: (context, state) => switch (state) {
            OnboardingInitial() || OnboardingLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            OnboardingFailure(:final message) => Center(
              child: FailureMassage(message: message),
            ),
            OnboardingSuccess(
              :final model,
              :final selectedGoalId,
              :final selectedAvailability,
            ) =>
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: 72 + MediaQuery.of(context).padding.bottom,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const OnboardingHeader(title: 'FitFlow'),
                          const SizedBox(height: 26),
                          Text(
                            'Select Your Goal',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF111827),
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Customize your journey for precision performance.',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: const Color(0xFF6B7280)),
                          ),
                          const SizedBox(height: 24),
                          Column(
                            children: [
                              for (final goal in model.goals) ...[
                                OnboardingGoalCard(
                                  goal: goal,
                                  selected: selectedGoalId == goal.id,
                                  onTap: () => context
                                      .read<OnboardingCubit>()
                                      .selectGoal(goal.id),
                                ),
                                const SizedBox(height: 12),
                              ],
                              const SizedBox(height: 8),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Weekly Availability',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              AvailabilitySelector(
                                options: model.availabilityOptions,
                                selectedOption: selectedAvailability,
                                onSelect: (opt) => context
                                    .read<OnboardingCubit>()
                                    .selectAvailability(opt),
                              ),
                              const SizedBox(height: 14),
                              if (selectedAvailability == '3 Days')
                                RecommendedCard(
                                  title: 'Recommended',
                                  subtitle: model.recoveryHint,
                                ),
                            ],
                          ),
                          const SizedBox(height: 14),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: SafeArea(
                        top: false,
                        child: PrimaryActionButton(
                          label: 'Continue',
                          onPressed: () {
                            context.read<OnboardingCubit>().persistSelection();
                            context.push('/home');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          },
        ),
      ),
    );
  }
}
