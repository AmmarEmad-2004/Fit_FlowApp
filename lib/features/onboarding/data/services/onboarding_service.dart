import 'package:flutter/material.dart';

import '../models/goal_model.dart';
import '../models/onboarding_model.dart';

class OnboardingService {
  Future<OnboardingModel> loadOnboardingData() async {
    return const OnboardingModel(
      goals: [
        GoalModel(
          id: 'build_muscle',
          title: 'Build Muscle',
          subtitle: 'Focus on hypertrophy and strength.',
          icon: Icons.fitness_center,
          color: Color(0xFF6D7CFF),
        ),
        GoalModel(
          id: 'get_strong',
          title: 'Get Strong',
          subtitle: 'Prioritize heavy lifting and power.',
          icon: Icons.sports_gymnastics,
          color: Color(0xFF2F6CF6),
        ),
        GoalModel(
          id: 'general_fitness',
          title: 'General Fitness',
          subtitle: 'Balanced health and mobility.',
          icon: Icons.directions_run,
          color: Color(0xFF23A6A6),
        ),
      ],
      availabilityOptions: ['2 Days', '3 Days', '4 Days', '5+ Days'],
      recoveryHint: 'Optimal recovery cycle',
    );
  }
}
