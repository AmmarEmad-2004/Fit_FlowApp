import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/user_selection_service.dart';

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
      'program_${programType}_$daysPerWeek';

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
          final days = normalized['days'];
          if (days is Map && days.isNotEmpty) {
            return normalized;
          }
        }
      } catch (_) {
        await _box.delete(key);
      }
    }

    final Map<String, dynamic> programData = {
      'programType': programType,
      'daysPerWeek': daysPerWeek,
      'days': <String, dynamic>{},
    };

    final plansDoc = await _firestore
        .collection('programs')
        .doc(programType)
        .collection('plans')
        .doc('${daysPerWeek}_days')
        .get();

    if (plansDoc.exists) {
      final data = plansDoc.data() ?? <String, dynamic>{};
      programData['days'] = _normalizeWorkoutsToDays(data['workouts']);
    } else {
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

    _box.put(key, {
      'fetchedAt': DateTime.now().toIso8601String(),
      'data': normalized,
    });

    return normalized;
  }

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
