import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../logic/onboarding_cubit.dart';
import '../logic/onboarding_state.dart';
import 'widgets/onboarding_widgets.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: (context, state) {
            if (state.isLoading || state.model == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final model = state.model!;

            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const OnboardingHeader(title: 'FitFlow'),
                  const SizedBox(height: 26),
                  Text(
                    'Select Your Goal',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Customize your journey for precision performance.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.separated(
                      itemCount: model.goals.length + 2,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        if (index < model.goals.length) {
                          final goal = model.goals[index];
                          final selected = state.selectedGoalId == goal.id;

                          return OnboardingGoalCard(
                            goal: goal,
                            selected: selected,
                            onTap: () => context
                                .read<OnboardingCubit>()
                                .selectGoal(goal.id),
                          );
                        }

                        if (index == model.goals.length) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              const Text(
                                'Weekly Availability',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 14),
                              AvailabilitySelector(
                                options: model.availabilityOptions,
                                selectedOption: state.selectedAvailability,
                                onSelect: (opt) => context
                                    .read<OnboardingCubit>()
                                    .selectAvailability(opt),
                              ),
                              const SizedBox(height: 14),
                              RecommendedCard(
                                title: 'Recommended',
                                subtitle: model.recoveryHint,
                              ),
                            ],
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  const SizedBox(height: 14),
                  PrimaryActionButton(
                    label: 'Continue',
                    onPressed: () async {
                      await context
                          .read<OnboardingCubit>()
                          .completeOnboarding();
                      if (context.mounted) {
                        context.go('/home');
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
