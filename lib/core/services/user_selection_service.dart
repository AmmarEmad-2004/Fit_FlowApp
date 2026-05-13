import 'package:hive_flutter/hive_flutter.dart';

/// Persists the user's onboarding selection (programType + daysPerWeek)
/// to a Hive box so the choice survives app restarts.
class UserSelectionService {
  static const boxName = 'user_selection';
  static const _keyProgramType = 'programType';
  static const _keyDaysPerWeek = 'daysPerWeek';

  final Box _box;
  UserSelectionService(this._box);

  // ── Getters ──────────────────────────────────────────────────────────────

  String? get programType => _box.get(_keyProgramType) as String?;
  int?    get daysPerWeek  => _box.get(_keyDaysPerWeek) as int?;

  /// Returns true when the user has already completed onboarding.
  bool get hasSelection => programType != null && daysPerWeek != null;

  // ── Setters ──────────────────────────────────────────────────────────────

  Future<void> save({
    required String programType,
    required int daysPerWeek,
  }) async {
    await _box.put(_keyProgramType, programType);
    await _box.put(_keyDaysPerWeek, daysPerWeek);
  }

  Future<void> clear() async => _box.clear();
}
