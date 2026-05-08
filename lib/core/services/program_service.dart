import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Simple program service: fetch by programType and daysPerWeek from Firestore,
// cache in Hive with 24h TTL, and provide a weekly blueprint generator.
class ProgramService {
  final FirebaseFirestore _firestore;
  final Box _box;
  final Duration _ttl;

  ProgramService._(this._firestore, this._box, this._ttl);

  static Future<ProgramService> create({Duration? ttl}) async {
    await Hive.initFlutter();
    final box = await Hive.openBox('programs_cache');
    return ProgramService._(
      FirebaseFirestore.instance,
      box,
      ttl ?? const Duration(hours: 24),
    );
  }

  String _cacheKey(String programType, int daysPerWeek) =>
      'program_${programType}_$daysPerWeek';

  Future<Map<String, dynamic>> fetchProgram(
    String programType,
    int daysPerWeek, {
    bool forceRefresh = false,
  }) async {
    final key = _cacheKey(programType, daysPerWeek);

    if (!forceRefresh && _box.containsKey(key)) {
      try {
        final cached = _box.get(key) as Map;
        final timestamp = DateTime.parse(cached['fetchedAt'] as String);
        if (DateTime.now().difference(timestamp) <= _ttl) {
          final cachedData = _deepCast(cached['data'] as Map);
          final normalized = _normalizeProgramData(cachedData);
          if (_hasTrainingDays(normalized)) {
            return normalized;
          }
        }
      } catch (_) {
        // Cache is corrupt or old structure — delete and re-fetch
        await _box.delete(key);
      }
    }

    final Map<String, dynamic> programData = {
      'programType': programType,
      'daysPerWeek': daysPerWeek,
      'days': <String, dynamic>{},
    };

    // Preferred Firestore structure (current uploader):
    // programs/{programType}/plans/{daysPerWeek}_days { workouts: [...] }
    final plansDoc = await _firestore
        .collection('programs')
        .doc(programType)
        .collection('plans')
        .doc('${daysPerWeek}_days')
        .get();

    if (plansDoc.exists) {
      final data = plansDoc.data() ?? <String, dynamic>{};
      final workouts = data['workouts'];
      programData['days'] = _normalizeWorkoutsToDays(workouts);
    } else {
      // Legacy structure: programs/{programType}/{daysPerWeek}/day_* docs
      final docRef = _firestore
          .collection('programs')
          .doc(programType)
          .collection(daysPerWeek.toString());
      final snapshot = await docRef.get();

      for (final doc in snapshot.docs) {
        programData['days'][doc.id] = doc.data();
      }
    }

    final normalized = _normalizeProgramData(programData);

    // Save to Hive
    _box.put(key, {
      'fetchedAt': DateTime.now().toIso8601String(),
      'data': normalized,
    });

    return normalized;
  }

  /// Try to load from cache; if missing, fetch from Firestore.
  Future<Map<String, dynamic>?> loadCachedProgram(
    String programType,
    int daysPerWeek,
  ) async {
    final key = _cacheKey(programType, daysPerWeek);
    if (!_box.containsKey(key)) return null;
    final cached = _box.get(key) as Map;
    final raw = Map<String, dynamic>.from(cached['data'] as Map);
    return _normalizeProgramData(raw);
  }

  /// Force refresh and return latest.
  Future<Map<String, dynamic>> refreshProgram(
    String programType,
    int daysPerWeek,
  ) async {
    return fetchProgram(programType, daysPerWeek, forceRefresh: true);
  }

  /// Generate a weekly blueprint (7-length list) for shading the "Weekly Blueprint" UI.
  /// This distributes `daysPerWeek` training days across 7 days approximately evenly.
  List<bool> generateWeeklyBlueprint(int daysPerWeek) {
    final blueprint = List<bool>.filled(7, false);
    if (daysPerWeek <= 0) return blueprint;
    if (daysPerWeek >= 7) return List<bool>.filled(7, true);

    final double step = 7 / daysPerWeek;
    for (int k = 0; k < daysPerWeek; k++) {
      final idx = (k * step).round() % 7;
      blueprint[idx] = true;
    }

    // Ensure exact count (fix collisions)
    int current = blueprint.where((b) => b).length;
    int i = 0;
    while (current < daysPerWeek) {
      if (!blueprint[i]) {
        blueprint[i] = true;
        current++;
      }
      i = (i + 1) % 7;
    }
    while (current > daysPerWeek) {
      // remove from end
      for (int j = 6; j >= 0 && current > daysPerWeek; j--) {
        if (blueprint[j]) {
          blueprint[j] = false;
          current--;
        }
      }
    }

    return blueprint;
  }

  // ── Hive deep-cast helpers ──────────────────────────────────────────────────

  /// Recursively converts any Map to `Map<String, dynamic>`.
  /// Required because Hive deserialises nested maps as `Map<dynamic, dynamic>`.
  Map<String, dynamic> _deepCast(Map raw) {
    return raw.map((k, v) {
      final value = v is Map
          ? _deepCast(v)
          : (v is List ? _deepCastList(v) : v);
      return MapEntry(k.toString(), value);
    });
  }

  List<dynamic> _deepCastList(List raw) {
    return raw.map((e) => e is Map ? _deepCast(e) : e).toList();
  }

  // ── Normalization helpers ─────────────────────────────────────────────────-

  Map<String, dynamic> _normalizeProgramData(Map<String, dynamic> raw) {
    final days = raw['days'];
    if (days is Map) {
      final normalizedDays = <String, dynamic>{};
      days.forEach((key, value) {
        if (value is Map) {
          normalizedDays[key.toString()] = _normalizeDay(value);
        }
      });
      return {...raw, 'days': normalizedDays};
    }

    if (raw['workouts'] is List) {
      return {
        'programType': raw['programType'] ?? '',
        'daysPerWeek': raw['daysPerWeek'] ?? (raw['workouts'] as List).length,
        'days': _normalizeWorkoutsToDays(raw['workouts']),
      };
    }

    return raw;
  }

  bool _hasTrainingDays(Map<String, dynamic> data) {
    final days = data['days'];
    return days is Map && days.isNotEmpty;
  }

  Map<String, dynamic> _normalizeWorkoutsToDays(dynamic workouts) {
    final daysMap = <String, dynamic>{};
    final list = workouts is List ? workouts : <dynamic>[];

    for (int i = 0; i < list.length; i++) {
      final rawDay = list[i];
      if (rawDay is Map) {
        daysMap['day_$i'] = _normalizeDay(rawDay);
      }
    }

    return daysMap;
  }

  Map<String, dynamic> _normalizeDay(Map rawDay) {
    final exercisesRaw = rawDay['exercises'];
    final List<Map<String, dynamic>> exercises;

    if (exercisesRaw is Map) {
      exercises = exercisesRaw.values
          .whereType<Map>()
          .map(_normalizeExercise)
          .toList();
    } else if (exercisesRaw is List) {
      exercises = exercisesRaw
          .whereType<Map>()
          .map(_normalizeExercise)
          .toList();
    } else {
      exercises = <Map<String, dynamic>>[];
    }

    return {
      'day': rawDay['day'] ?? 'Training Day',
      'time': (rawDay['time'] as num?)?.toInt() ?? 45,
      'exercises': exercises,
    };
  }

  Map<String, dynamic> _normalizeExercise(Map raw) {
    return {
      'name': raw['name'] ?? 'Unknown Exercise',
      'targetArea':
          raw['targetArea'] ?? raw['desc'] ?? raw['description'] ?? '—',
      'reps': raw['reps'] ?? '—',
    };
  }
}
