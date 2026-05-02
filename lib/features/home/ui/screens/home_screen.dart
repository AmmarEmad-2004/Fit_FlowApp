import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/home_cubit.dart';
import '../logic/home_state.dart';
import '../logic/home_utils.dart';
import 'widgets/home_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) => switch (state) {
            // ── Loading ────────────────────────────────────────────────────
            HomeInitial() || HomeLoading() => const Center(
                child: CircularProgressIndicator(),
              ),

            // ── Failure ────────────────────────────────────────────────────
            HomeFailure(:final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.cloud_off_rounded,
                        size: 64,
                        color: Color(0xFFD1D5DB),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () => context.read<HomeCubit>().load(),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Try Again'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF2F6CF6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // ── Success ────────────────────────────────────────────────────
            HomeSuccess() => _buildContent(context, state),
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeSuccess state) {
    final cubit = context.read<HomeCubit>();
    final currentDay = HomeUtils.getCurrentDay(state.program, state.selectedDayIndex);
    final plan = HomeUtils.getCurrentPlan(state.program, state.selectedDayIndex);
    final labels = HomeUtils.getDayLabels(state.program);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            children: [
              const HomeHeader(
                title: 'Good Morning',
                subtitle: "Let's get to work.",
              ),
              const SizedBox(height: 24),

              // ── Week Blueprint header ─────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Weekly Blueprint',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '${state.program.daysPerWeek} Days / Week',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // ── Training day selector ─────────────────────────────────
              WeekSelector(
                labels: labels,
                selectedIndex: state.selectedDayIndex,
                onSelect: cubit.selectDay,
              ),
              const SizedBox(height: 14),

              // ── Plan card — shows day name + duration ─────────────────
              PlanCard(plan: plan, onStart: () {}),
              const SizedBox(height: 18),

              // ── Exercises ─────────────────────────────────────────────
              Text(
                '${currentDay.day} Exercises',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),

              ...currentDay.exercises.map(
                (ex) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ExerciseTile(exercise: ex),
                ),
              ),

              const SizedBox(height: 8),

              // ── Stats ─────────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'RECOVERY',
                      value: '94%',
                      subtitle: 'Optimal status for training today.',
                      bgColor: const Color(0xFFE9F8F2),
                      titleColor: const Color(0xFF14B8A6),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      title: 'WEEKLY BURN',
                      value: '2450',
                      subtitle: 'Active kcal burned this week.',
                      bgColor: const Color(0xFFFFF3E9),
                      titleColor: const Color(0xFFF97316),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── Bottom Nav ────────────────────────────────────────────────
        HomeBottomNav(
          currentIndex: state.selectedTabIndex,
          onTap: cubit.selectTab,
        ),
      ],
    );
  }
}
