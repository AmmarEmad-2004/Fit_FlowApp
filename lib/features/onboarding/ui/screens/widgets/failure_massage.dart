import 'package:fit_flow/features/onboarding/ui/logic/onboarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FailureMassage extends StatelessWidget {
  const FailureMassage({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message,
          style: const TextStyle(color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => context.read<OnboardingCubit>().load(),
          child: const Text('Retry'),
        ),
      ],
    );
  }
}