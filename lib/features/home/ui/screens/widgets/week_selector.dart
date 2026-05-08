import 'package:flutter/material.dart';

class WeekSelector extends StatelessWidget {
  const WeekSelector({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.activeDays,
    required this.onSelect,
  });

  /// Short labels for each weekday (e.g. ["M", "T", "W", "T", "F", "S", "S"])
  final List<String> labels;
  final int selectedIndex;
  final List<bool> activeDays;
  final void Function(int index) onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final isActive = i < activeDays.length && activeDays[i];
          final isSelected = selectedIndex == i;

          final bgColor = isSelected
              ? const Color(0xFF2F6CF6)
              : (isActive ? const Color(0xFFE7EEFF) : const Color(0xFFF3F4F6));
          final textColor = isSelected ? Colors.white : const Color(0xFF6B7280);

          return Expanded(
            child: GestureDetector(
              onTap: isActive ? () => onSelect(i) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF2F6CF6)
                        : Colors.transparent,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[i],
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
