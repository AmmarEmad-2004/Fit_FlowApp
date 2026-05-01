import 'package:flutter/material.dart';

class OnboardingHeader extends StatelessWidget {
  final String title;

  const OnboardingHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: const Color(0xFF2F6CF6),
            fontWeight: FontWeight.w800,
          ),
        ),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.help_outline_rounded, size: 20),
        ),
      ],
    );
  }
}
