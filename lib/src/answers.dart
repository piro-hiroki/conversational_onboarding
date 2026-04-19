import 'package:flutter/foundation.dart';

/// Immutable view of onboarding answers keyed by step id.
///
/// Values are stored as [Object] to keep the API ergonomic; use the typed
/// accessors ([getString], [getInt], [getList]) when you need a guarantee.
@immutable
class OnboardingAnswers {
  OnboardingAnswers(Map<String, Object?> values)
      : _values = Map.unmodifiable(values);

  const OnboardingAnswers.empty() : _values = const <String, Object?>{};

  final Map<String, Object?> _values;

  Map<String, Object?> toMap() => Map<String, Object?>.from(_values);

  bool has(String id) => _values.containsKey(id);

  Object? operator [](String id) => _values[id];

  T? get<T>(String id) {
    final v = _values[id];
    if (v is T) return v;
    return null;
  }

  String? getString(String id) => get<String>(id);

  int? getInt(String id) {
    final v = _values[id];
    if (v is int) return v;
    if (v is double) return v.toInt();
    return null;
  }

  double? getDouble(String id) {
    final v = _values[id];
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return null;
  }

  bool? getBool(String id) => get<bool>(id);

  DateTime? getDateTime(String id) => get<DateTime>(id);

  List<T>? getList<T>(String id) {
    final v = _values[id];
    if (v is List) return v.whereType<T>().toList(growable: false);
    return null;
  }

  @override
  String toString() => 'OnboardingAnswers($_values)';
}
