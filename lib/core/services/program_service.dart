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
          return _deepCast(cached['data'] as Map);
        }
      } catch (_) {
        // Cache is corrupt or old structure — delete and re-fetch
        await _box.delete(key);
      }
    }

    // Firestore structure: collection('programs').doc(programType).collection(daysPerWeek.toString()).docs
    final docRef = _firestore
        .collection('programs')
        .doc(programType)
        .collection(daysPerWeek.toString());
    final snapshot = await docRef.get();

    final Map<String, dynamic> programData = {
      'programType': programType,
      'daysPerWeek': daysPerWeek,
      'days': {},
    };

    for (final doc in snapshot.docs) {
      programData['days'][doc.id] = doc.data();
    }

    // Save to Hive
    _box.put(key, {
      'fetchedAt': DateTime.now().toIso8601String(),
      'data': programData,
    });

    return programData;
  }

  /// Try to load from cache; if missing, fetch from Firestore.
  Future<Map<String, dynamic>?> loadCachedProgram(
    String programType,
    int daysPerWeek,
  ) async {
    final key = _cacheKey(programType, daysPerWeek);
    if (!_box.containsKey(key)) return null;
    final cached = _box.get(key) as Map;
    return Map<String, dynamic>.from(cached['data'] as Map);
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
      final value =
          v is Map ? _deepCast(v) : (v is List ? _deepCastList(v) : v);
      return MapEntry(k.toString(), value);
    });
  }

  List<dynamic> _deepCastList(List raw) {
    return raw.map((e) => e is Map ? _deepCast(e) : e).toList();
  }
}

